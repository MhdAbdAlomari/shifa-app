import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Centered progress indicator used by every screen while its Bloc is
/// in a loading state. Kept as a single widget so screens don't each
/// invent their own spinner styling.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}
