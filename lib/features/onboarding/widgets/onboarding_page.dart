import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.data,
  });

  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                data.imageAsset,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            data.title,
            style: AppTextStyles.headline.copyWith(
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            data.subtitle,
            style: AppTextStyles.caption.copyWith(
              fontSize: 14,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
