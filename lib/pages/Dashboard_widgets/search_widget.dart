import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SearchWidget extends StatelessWidget {
  final VoidCallback onTap;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const SearchWidget({
    Key? key,
    required this.onTap,
    this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Search for products',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                style: const TextStyle(
                  fontSize: 14,
                ),
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
            IconButton(
              onPressed: () {
                if (controller != null) {
                  controller!.clear();
                  if (onChanged != null) {
                    onChanged!('');
                  }
                }
              },
              icon: Icon(
                Icons.close,
                color: Colors.grey[600],
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
} 