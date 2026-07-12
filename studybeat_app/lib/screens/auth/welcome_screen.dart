import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.sbColors;

    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: colors.accent,
                      fontSize: 48,
                    ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.textSecondary,
                    ),
              ).animate().fadeIn(delay: 150.ms, duration: 500.ms),
              const SizedBox(height: 40),
              _FeatureRow(
                icon: Icons.headphones_rounded,
                title: 'Adaptive soundscapes',
                subtitle: 'Music that evolves with your focus and stress',
              ).animate().fadeIn(delay: 250.ms).slideX(begin: -0.05),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.timer_rounded,
                title: 'Pomodoro + Focus Mode',
                subtitle: 'Timers, breaks, and minimal distraction UI',
              ).animate().fadeIn(delay: 350.ms).slideX(begin: -0.05),
              const SizedBox(height: 14),
              _FeatureRow(
                icon: Icons.auto_awesome_rounded,
                title: 'AI study coach',
                subtitle: 'Insights that learn how you study best',
              ).animate().fadeIn(delay: 450.ms).slideX(begin: -0.05),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Get Started',
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.go('/onboarding'),
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  await ref.read(studyRepositoryProvider).seedDemo();
                  await ref.read(userProfileProvider.notifier).reload();
                  await ref.read(sessionsProvider.notifier).reload();
                  if (context.mounted) context.go('/dashboard');
                },
                child: const Text('Explore Demo'),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colors.accent),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
