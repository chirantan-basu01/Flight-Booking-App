import 'package:flutter/material.dart';
import 'package:flight_booking_app/core/constants/app_colors.dart';
import 'package:flight_booking_app/core/theme/app_typography.dart';
import 'package:flight_booking_app/shared/widgets/primary_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.subtitle,
    this.onRetry,
    this.icon = Icons.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.mediumGray,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Retry',
                onPressed: onRetry,
                isExpanded: false,
                width: 120,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.search_off,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.mediumGray,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: AppTypography.body,
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: actionText!,
                onPressed: onAction,
                isExpanded: false,
                width: 150,
              ),
            ],
          ],
        ),
      ),
    );
  }
}