import 'package:flutter/material.dart';

class FullscreenImageViewer extends StatelessWidget {
  const FullscreenImageViewer({
    super.key,
    required this.imageProvider,
    this.heroTag = 'profile_avatar',
  });

  final ImageProvider imageProvider;
  final String heroTag;

  static void show(
    BuildContext context,
    ImageProvider imageProvider, {
    String heroTag = 'profile_avatar',
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.9),
        pageBuilder: (context, animation, secondaryAnimation) => FullscreenImageViewer(
          imageProvider: imageProvider,
          heroTag: heroTag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            // Center Zoomable Image with Double Tap & Pinch
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Hero(
                  tag: heroTag,
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Top Right Close Button
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 22),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
