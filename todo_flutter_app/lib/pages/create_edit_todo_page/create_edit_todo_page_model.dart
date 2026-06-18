import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import 'create_edit_todo_page_widget.dart';

class CreateEditTodoPageModel extends FlutterFlowModel<CreateEditTodoPageWidget> {
  final formKey = GlobalKey<FormState>();

  FocusNode? titleFocusNode;
  TextEditingController? titleTextController;

  FocusNode? descriptionFocusNode;
  TextEditingController? descriptionTextController;

  String priority = 'medium';
  DateTime? dueDate;

  bool isLoading = false;
  String? errorMessage;

  @override
  void initState(BuildContext context) {
    titleFocusNode = FocusNode();
    titleTextController = TextEditingController();
    descriptionFocusNode = FocusNode();
    descriptionTextController = TextEditingController();
  }

  @override
  void dispose() {
    titleFocusNode?.dispose();
    titleTextController?.dispose();
    descriptionFocusNode?.dispose();
    descriptionTextController?.dispose();
  }
}
