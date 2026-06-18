import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import 'signup_page_widget.dart';

class SignupPageModel extends FlutterFlowModel<SignupPageWidget> {
  final formKey = GlobalKey<FormState>();

  FocusNode? nameFocusNode;
  TextEditingController? nameTextController;

  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  bool passwordVisibility = false;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {
    nameFocusNode = FocusNode();
    nameTextController = TextEditingController();
    emailFocusNode = FocusNode();
    emailTextController = TextEditingController();
    passwordFocusNode = FocusNode();
    passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameTextController?.dispose();
    emailFocusNode?.dispose();
    emailTextController?.dispose();
    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
