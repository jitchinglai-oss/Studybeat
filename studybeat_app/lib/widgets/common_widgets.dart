import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../core/theme/app_theme.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return Scaffold(
      extendBodyBehindAppBar: appBar != null,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colors.gradientTop, colors.gradientBottom],
          ),
        ),
        child: child,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class SoftPanel extends StatelessWidget {
  const SoftPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    final content = Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.border.withValues(alpha: 0.55)),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: content,
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    required this.name,
    this.subtitle,
  });

  final String name;
  final String? subtitle;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_greeting()}, $name',
          style: Theme.of(context).textTheme.displayMedium,
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.15, end: 0),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyMedium,
          ).animate().fadeIn(delay: 120.ms, duration: 450.ms),
        ],
      ],
    );
  }
}

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.emoji,
    this.icon,
  });

  final String label;
  final String value;
  final String? emoji;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (emoji != null)
                Text(emoji!, style: const TextStyle(fontSize: 18))
              else if (icon != null)
                Icon(icon, size: 18, color: colors.accent),
              const SizedBox(width: 6),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
