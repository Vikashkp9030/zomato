import 'package:flutter/material.dart';

abstract class FlutterFlowModel<W extends Widget> {
  late W widget;
  void initState(BuildContext context);
  void dispose();
}
