// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';
import '../theme/theme.dart';

class OneActionCard<T> extends StatelessWidget {
  final T? initialValue;
  final String? Function(T?)? validator;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final String title;
  final String? subtitle;
  final TextStyle? subtitleStyle;
  final bool hideTrailing;

  const OneActionCard({
    required this.leadingIcon,
    required this.title,
    this.initialValue,
    super.key,
    this.validator,
    this.onTap,
    this.subtitle,
    this.subtitleStyle,
    this.hideTrailing = false,
  });

  Widget _buildCard(BuildContext context, FormFieldState<T>? formState) {
    final hasError = formState?.hasError ?? false;
    return WActionCardTheme(
      child: Card.outlined(
        shape: RoundedRectangleBorder(
          borderRadius: $corners.card.asBorderRadius,
          side: BorderSide(
            color: hasError ? context.col.error : context.col.primary,
            width: hasError ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          onTap: () => onTap?.call(),
          leading: leadingIcon != null || hasError
              ? Icon(
                  hasError ? Icons.priority_high : leadingIcon,
                  color: hasError ? context.col.error : context.col.primary,
                )
              : null,
          title: Text(
            title,
            style: context.tt.bodyLarge,
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: subtitleStyle ??
                      TextStyle(
                        color:
                            hasError ? context.col.error : context.col.primary,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : null,
          trailing: hideTrailing
              ? null
              : Icon(
                  Icons.chevron_right,
                  color: hasError ? context.col.error : context.col.primary,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (validator == null) {
      return _buildCard(context, null);
    }
    return FormField<T>(
      key: ValueKey(initialValue),
      validator: validator,
      initialValue: initialValue,
      builder: (formState) => _buildCard(context, formState),
    );
  }
}
