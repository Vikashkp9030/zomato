import 'package:flutter/material.dart';

class FFButtonWidget extends StatefulWidget {
  const FFButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    required this.options,
  });

  final Future<void> Function()? onPressed;
  final String text;
  final FFButtonOptions options;

  @override
  State<FFButtonWidget> createState() => _FFButtonWidgetState();
}

class _FFButtonWidgetState extends State<FFButtonWidget> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.options.width ?? double.infinity,
      height: widget.options.height ?? 52,
      child: ElevatedButton(
        onPressed: (widget.onPressed == null || _loading)
            ? null
            : () async {
                setState(() => _loading = true);
                await widget.onPressed!();
                if (mounted) setState(() => _loading = false);
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.options.color,
          foregroundColor: widget.options.textStyle?.color ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: widget.options.borderRadius ?? BorderRadius.circular(12),
          ),
          elevation: widget.options.elevation ?? 0,
          disabledBackgroundColor: widget.options.color.withOpacity(0.6),
        ),
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(widget.text, style: widget.options.textStyle),
      ),
    );
  }
}

class FFButtonOptions {
  const FFButtonOptions({
    this.width,
    this.height,
    required this.color,
    required this.textStyle,
    this.elevation,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final Color color;
  final TextStyle? textStyle;
  final double? elevation;
  final BorderRadius? borderRadius;
}
