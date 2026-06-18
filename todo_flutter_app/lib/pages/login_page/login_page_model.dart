import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import 'login_page_widget.dart';

class LoginPageModel extends FlutterFlowModel<LoginPageWidget> {
  final formKey = GlobalKey<FormState>();

  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  bool passwordVisibility = false;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {
    emailFocusNode = FocusNode();
    emailTextController = TextEditingController();
    passwordFocusNode = FocusNode();
    passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
