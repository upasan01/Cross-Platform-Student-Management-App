import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum PopupType { success, error, info }

class CupertinoPopupMessage extends StatefulWidget {
  final String message;
  final PopupType type;
  final VoidCallback onDismiss;

  const CupertinoPopupMessage({
    super.key,
    required this.message,
    this.type = PopupType.info,
    required this.onDismiss,
  });

  static void show(BuildContext context, String message, {PopupType type = PopupType.info}) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (_) => CupertinoPopupMessage(
        message: message,
        type: type,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  State<CupertinoPopupMessage> createState() => _CupertinoPopupMessageState();
}

class _CupertinoPopupMessageState extends State<CupertinoPopupMessage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _visible = false);
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case PopupType.success:
        return const Color(0xFFD6F5D6); // Soft green
      case PopupType.error:
        return const Color(0xFFFFD6D6); // Soft red
      case PopupType.info:
        return const Color(0xFFD6E6FF); // Soft blue
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case PopupType.success:
        return CupertinoIcons.check_mark_circled_solid;
      case PopupType.error:
        return CupertinoIcons.exclamationmark_triangle_fill;
      case PopupType.info:
        return CupertinoIcons.info_circle_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _offsetAnimation,
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 350),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBackgroundColor(),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getIcon(), size: 22, color: CupertinoColors.black),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 15,
                        color: CupertinoColors.black,
                      ),
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
}
