import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_manager.dart';
import 'create_edit_todo_page_model.dart';

export 'create_edit_todo_page_model.dart';

class CreateEditTodoPageWidget extends StatefulWidget {
  const CreateEditTodoPageWidget({super.key, this.existingTodo});
  final Map<String, dynamic>? existingTodo;

  @override
  State<CreateEditTodoPageWidget> createState() =>
      _CreateEditTodoPageWidgetState();
}

class _CreateEditTodoPageWidgetState extends State<CreateEditTodoPageWidget> {
  late CreateEditTodoPageModel _model;
  bool get isEditing => widget.existingTodo != null;

  @override
  void initState() {
    super.initState();
    _model = CreateEditTodoPageModel()..initState(context);
    if (isEditing) {
      final todo = widget.existingTodo!;
      _model.titleTextController!.text = todo['title'] as String? ?? '';
      _model.descriptionTextController!.text =
          todo['description'] as String? ?? '';
      _model.priority = todo['priority'] as String? ?? 'medium';
      final dueDateStr = todo['due_date'] as String?;
      if (dueDateStr != null && dueDateStr.isNotEmpty) {
        try {
          _model.dueDate = DateTime.parse(dueDateStr);
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_model.formKey.currentState!.validate()) return;
    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    final token = context.read<FFAppState>().authToken;
    final title = _model.titleTextController!.text.trim();
    final description = _model.descriptionTextController!.text.trim();
    final dueDateStr =
        _model.dueDate?.toUtc().toIso8601String();

    ApiCallResponse response;
    if (isEditing) {
      final id = (widget.existingTodo!['id'] as num).toInt();
      response = await UpdateTodoCall.call(
        token: token,
        id: id,
        title: title,
        description: description,
        priority: _model.priority,
        dueDate: dueDateStr,
      );
    } else {
      response = await CreateTodoCall.call(
        token: token,
        title: title,
        description: description,
        priority: _model.priority,
        dueDate: dueDateStr,
      );
    }

    if (!mounted) return;
    if (response.succeeded) {
      context.pop();
    } else {
      setState(() {
        _model.errorMessage =
            response.errorMessage ?? 'Failed to save todo';
        _model.isLoading = false;
      });
    }
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _model.dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FlutterFlowTheme.of(context).primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _model.dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: theme.primaryText, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text(
            isEditing ? 'Edit Todo' : 'New Todo',
            style: theme.headlineSmall,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  _label('Title *', theme),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.titleTextController,
                    focusNode: _model.titleFocusNode,
                    style: theme.bodyLarge,
                    decoration: _inputDecoration(theme,
                        hint: 'What needs to be done?'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _label('Description', theme),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.descriptionTextController,
                    focusNode: _model.descriptionFocusNode,
                    style: theme.bodyLarge,
                    maxLines: 3,
                    decoration: _inputDecoration(theme,
                        hint: 'Add details (optional)'),
                  ),
                  const SizedBox(height: 20),

                  // Priority
                  _label('Priority', theme),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.alternate),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _model.priority,
                        isExpanded: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        items: [
                          _dropdownItem('low', 'Low', theme.success, theme),
                          _dropdownItem(
                              'medium', 'Medium', theme.warning, theme),
                          _dropdownItem('high', 'High', theme.error, theme),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _model.priority = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Due Date
                  _label('Due Date', theme),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDueDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.alternate),
                      ),
                      child: Row(children: [
                        Icon(Icons.calendar_today_outlined,
                            color: theme.secondaryText, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          _model.dueDate != null
                              ? DateFormat('MMM d, yyyy').format(_model.dueDate!)
                              : 'No due date',
                          style: _model.dueDate != null
                              ? theme.bodyLarge
                              : theme.labelMedium,
                        ),
                        const Spacer(),
                        if (_model.dueDate != null)
                          GestureDetector(
                            onTap: () =>
                                setState(() => _model.dueDate = null),
                            child: Icon(Icons.close,
                                color: theme.secondaryText, size: 18),
                          ),
                      ]),
                    ),
                  ),

                  if (_model.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: theme.error.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        Icon(Icons.error_outline,
                            color: theme.error, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(_model.errorMessage!,
                                style: theme.bodySmall
                                    .copyWith(color: theme.error))),
                      ]),
                    ),
                  ],

                  const SizedBox(height: 32),
                  FFButtonWidget(
                    onPressed: _model.isLoading ? null : _save,
                    text: _model.isLoading
                        ? 'Saving…'
                        : isEditing
                            ? 'Update Todo'
                            : 'Create Todo',
                    options: FFButtonOptions(
                      height: 52,
                      color: theme.primary,
                      textStyle: theme.titleSmall.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text, FlutterFlowTheme theme) =>
      Text(text, style: theme.labelLarge.copyWith(color: theme.primaryText));

  DropdownMenuItem<String> _dropdownItem(
      String value, String label, Color color, FlutterFlowTheme theme) {
    return DropdownMenuItem(
      value: value,
      child: Row(children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: theme.bodyMedium),
      ]),
    );
  }

  InputDecoration _inputDecoration(FlutterFlowTheme theme,
          {required String hint}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: theme.labelMedium,
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
