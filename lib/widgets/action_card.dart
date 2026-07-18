import 'package:flutter/material.dart';
import '../presentation/widgets/app_card.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }
}
