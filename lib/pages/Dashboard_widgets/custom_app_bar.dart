import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onBackPressed;
  final bool showBackButton;
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.onMenuPressed,
    required this.onBackPressed,
    this.showBackButton = false,
    this.title = 'GrocerApp',
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Back button or menu button
            showBackButton
                ? IconButton(
                    onPressed: onBackPressed,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                : IconButton(
                    onPressed: onMenuPressed,
                    icon: Icon(
                      Icons.menu,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
            const SizedBox(width: 16),
            
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Actions
            if (actions != null) ...actions!,
          ],
        ),
      ),
    );
  }
} 