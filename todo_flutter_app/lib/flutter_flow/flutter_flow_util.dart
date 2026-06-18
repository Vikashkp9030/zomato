export 'package:go_router/go_router.dart';
export 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String dateTimeFormat(String format, DateTime? dateTime) {
  if (dateTime == null) return '';
  try {
    return DateFormat(format).format(dateTime);
  } catch (_) {
    return '';
  }
}

extension FFContextExt on BuildContext {
  void safePop() {
    if (Navigator.canPop(this)) Navigator.pop(this);
  }
}
