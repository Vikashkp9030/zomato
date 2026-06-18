import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_manager.dart';
import 'login_page_model.dart';

export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = LoginPageModel()..initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_model.formKey.currentState!.validate()) return;
    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    final response = await LoginCall.call(
      email: _model.emailTextController!.text.trim(),
      password: _model.passwordTextController!.text,
    );

    if (!mounted) return;
    if (response.succeeded) {
      final token = LoginCall.token(response);
      final user = LoginCall.user(response);
      if (token != null) {
        final appState = context.read<FFAppState>();
        appState.update(() {
          appState.authToken = token;
          appState.currentUserID = (user?['id'] as num?)?.toInt() ?? 0;
          appState.currentUserName = user?['name'] as String? ?? '';
          appState.currentUserEmail = user?['email'] as String? ?? '';
        });
        context.go('/home');
      }
    } else {
      setState(() {
        _model.errorMessage = response.errorMessage ?? 'Login failed';
        _model.isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: _model.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: theme.primary,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 40),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text('Welcome back', style: theme.headlineMedium),
                      const SizedBox(height: 6),
                      Text('Sign in to continue', style: theme.labelLarge),
                      const SizedBox(height: 32),

                      // Email
                      _buildLabel('Email', theme),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _model.emailTextController,
                        focusNode: _model.emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        style: theme.bodyLarge,
                        decoration: _inputDecoration(
                          theme,
                          hint: 'Enter your email',
                          prefixIcon: Icons.email_outlined,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password
                      _buildLabel('Password', theme),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _model.passwordTextController,
                        focusNode: _model.passwordFocusNode,
                        obscureText: !_model.passwordVisibility,
                        style: theme.bodyLarge,
                        decoration: _inputDecoration(
                          theme,
                          hint: 'Enter your password',
                          prefixIcon: Icons.lock_outline,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _model.passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: theme.secondaryText,
                              size: 20,
                            ),
                            onPressed: () => setState(() {
                              _model.passwordVisibility =
                                  !_model.passwordVisibility;
                            }),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          return null;
                        },
                      ),

                      if (_model.errorMessage != null) ...[
                        const SizedBox(height: 12),
                        _buildError(_model.errorMessage!, theme),
                      ],

                      const SizedBox(height: 28),
                      FFButtonWidget(
                        onPressed: _model.isLoading ? null : _login,
                        text: _model.isLoading ? 'Signing in…' : 'Sign In',
                        options: FFButtonOptions(
                          height: 52,
                          color: theme.primary,
                          textStyle: theme.titleSmall.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w600),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go('/signup'),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Don't have an account? ",
                                  style: theme.bodyMedium),
                              TextSpan(
                                text: 'Sign Up',
                                style: theme.bodyMedium.copyWith(
                                    color: theme.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, FlutterFlowTheme theme) =>
      Text(text, style: theme.labelLarge.copyWith(color: theme.primaryText));

  Widget _buildError(String msg, FlutterFlowTheme theme) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.error.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(Icons.error_outline, color: theme.error, size: 16),
          const SizedBox(width: 8),
          Expanded(
              child: Text(msg,
                  style: theme.bodySmall.copyWith(color: theme.error))),
        ]),
      );

  InputDecoration _inputDecoration(
    FlutterFlowTheme theme, {
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) =>
      InputDecoration(
        hintText: hint,
        hintStyle: theme.labelMedium,
        prefixIcon: Icon(prefixIcon, color: theme.secondaryText, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: theme.secondaryBackground,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.alternate)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.primary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.error, width: 2)),
      );
}
