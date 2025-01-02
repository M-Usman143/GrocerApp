// import 'package:flutter/material.dart';
//
// class FlyToCartAnimation {
//   final BuildContext context;
//   final GlobalKey fromKey;
//   final GlobalKey toKey;
//   final String imagePath;
//   final VoidCallback onComplete;
//
//   FlyToCartAnimation({
//     required this.context,
//     required this.fromKey,
//     required this.toKey,
//     required this.imagePath,
//     required this.onComplete,
//   });
//
//   void startAnimation() {
//     // Get positions of fromKey (product) and toKey (cart)
//     final fromRenderBox = fromKey.currentContext!.findRenderObject() as RenderBox;
//     final toRenderBox = toKey.currentContext!.findRenderObject() as RenderBox;
//
//     final startOffset = fromRenderBox.localToGlobal(Offset.zero);
//
//
//     final endOffset = toRenderBox.localToGlobal(Offset.zero);
//     // Adjust the endOffset to make the animation fly to the right
//     final adjustedEndOffset = endOffset;
//
//     // Declare the OverlayEntry
//     late OverlayEntry overlayEntry;
//
//     // Initialize the OverlayEntry with the builder
//     overlayEntry = OverlayEntry(
//       builder: (context) {
//         return _FlyingImage(
//           startOffset: startOffset,
//           endOffset: adjustedEndOffset,
//           imagePath: imagePath,
//           onComplete: () {
//             overlayEntry.remove();
//             onComplete();
//           },
//         );
//       },
//     );
//
//     // Insert the OverlayEntry
//     Overlay.of(context)!.insert(overlayEntry);
//   }
// }
//
// class _FlyingImage extends StatefulWidget {
//   final Offset startOffset;
//   final Offset endOffset;
//   final String imagePath;
//   final VoidCallback onComplete;
//
//   _FlyingImage({
//     required this.startOffset,
//     required this.endOffset,
//     required this.imagePath,
//     required this.onComplete,
//   });
//
//   @override
//   State<_FlyingImage> createState() => _FlyingImageState();
// }
//
// class _FlyingImageState extends State<_FlyingImage> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<Offset> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );
//
//     _animation = Tween<Offset>(
//       begin: widget.startOffset,
//       end: widget.endOffset,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _controller.forward().then((value) {
//       widget.onComplete();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final topMargin = 20.0; // Additional margin from the top (you can adjust this value)
//
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return Positioned(
//           top: _animation.value.dy+topMargin,
//           right: _animation.value.dx,
//           child: Image.asset(
//             widget.imagePath,
//             width: 50, // Adjust size as needed
//             height: 50,
//           ),
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';

class FlyToCartAnimation {
  final BuildContext context;
  final GlobalKey fromKey;
  final GlobalKey toKey;
  final String imagePath;
  final VoidCallback onComplete;
  final Offset? endOffsetAdjustment; // Optional adjustment for fine-tuning
  final AnimationDirection direction; // Direction of the animation
  final double margin; // Margin to adjust the position of the animation


  FlyToCartAnimation({
    required this.context,
    required this.fromKey,
    required this.toKey,
    required this.imagePath,
    required this.onComplete,
    this.endOffsetAdjustment,
    required this.direction, // Accepting direction parameter
    this.margin = 0.0, // Default margin to 0 if not specified

  });

  void startAnimation() {
    // Get positions of fromKey (product) and toKey (cart) relative to the screen
    final overlayBox = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final fromRenderBox = fromKey.currentContext!.findRenderObject() as RenderBox;
    final toRenderBox = toKey.currentContext!.findRenderObject() as RenderBox;

    // Convert positions to screen space (global coordinates)
    final startOffset = fromRenderBox.localToGlobal(Offset.zero);
    var endOffset = toRenderBox.localToGlobal(Offset.zero);

    // Apply optional adjustment to endOffset if provided
    if (endOffsetAdjustment != null) {
      endOffset = Offset(endOffset.dx + endOffsetAdjustment!.dx, endOffset.dy + endOffsetAdjustment!.dy);
    }

    // Adjust the start and end positions to be relative to the Overlay (screen space)
    final startAdjusted = overlayBox.globalToLocal(startOffset);
    final endAdjusted = overlayBox.globalToLocal(endOffset);

    // Calculate the direction to move the image based on the AnimationDirection
    final directionAdjusted = direction == AnimationDirection.right
        ? Offset(endAdjusted.dx + margin, endAdjusted.dy) // Move right
        : Offset(endAdjusted.dx - margin, endAdjusted.dy); // Move left

    // Declare the OverlayEntry
    late OverlayEntry overlayEntry;

    // Initialize the OverlayEntry with the builder
    overlayEntry = OverlayEntry(
      builder: (context) {
        return _FlyingImage(
          startOffset: startAdjusted,
          endOffset: directionAdjusted, // Apply direction-adjusted endOffset
          imagePath: imagePath,
          onComplete: () {
            overlayEntry.remove();
            onComplete();
          },
        );
      },
    );

    // Insert the OverlayEntry into the screen's Overlay
    Overlay.of(context)!.insert(overlayEntry);
  }
}

// Enum to represent the animation direction
enum AnimationDirection { left, right }

class _FlyingImage extends StatefulWidget {
  final Offset startOffset;
  final Offset endOffset;
  final String imagePath;
  final VoidCallback onComplete;

  _FlyingImage({
    required this.startOffset,
    required this.endOffset,
    required this.imagePath,
    required this.onComplete,
  });

  @override
  State<_FlyingImage> createState() => _FlyingImageState();
}

class _FlyingImageState extends State<_FlyingImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: widget.startOffset,
      end: widget.endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward().then((value) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topMargin = 20.0;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value.dy +topMargin,
          left: _animation.value.dx,
          child: Image.asset(
            widget.imagePath,
            width: 50, // Adjust size as needed
            height: 50,
          ),
        );
      },
    );
  }
}
