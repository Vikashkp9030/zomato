import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_flow_model.dart';
import 'home_page_widget.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  List<dynamic> todos = [];
  bool isLoading = false;
  String? errorMessage;

  // Filter state
  String filterStatus = 'all'; // 'all' | 'active' | 'completed'
  String? filterPriority; // null | 'low' | 'medium' | 'high'

  List<dynamic> get filteredTodos {
    return todos.where((t) {
      final completed = t['completed'] as bool? ?? false;
      if (filterStatus == 'active' && completed) return false;
      if (filterStatus == 'completed' && !completed) return false;
      if (filterPriority != null && t['priority'] != filterPriority) return false;
      return true;
    }).toList();
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
