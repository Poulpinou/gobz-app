import 'package:flutter/material.dart';
import 'package:gobz_app/utils/LoggingUtils.dart';

class HoldMenu<T> extends StatefulWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;
  final Function(T? value)? onSelected;

  const HoldMenu({
    Key? key,
    required this.child,
    required this.items,
    this.onSelected,
  }) : super(key: key);

  _HoldMenuState<T> createState() => _HoldMenuState<T>();
}

class _HoldMenuState<T> extends State<HoldMenu<T>> {
  Offset _tapPosition = Offset.zero;

  Future<void> _showPopupMenu() async {
    final RenderBox? overlay = Overlay.of(context)?.context.findRenderObject() as RenderBox;

    if (overlay == null) {
      Log.error("RenderBox not found in context", NullThrownError());
    }

    final T? result = await showMenu<T>(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay!.size // Bigger rect, the entire screen
          ),
      items: widget.items,
    );

    widget.onSelected?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _tapPosition = details.globalPosition,
      onLongPress: () => _showPopupMenu(),
      child: widget.child,
    );
  }
}
