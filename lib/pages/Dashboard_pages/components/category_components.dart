import 'package:flutter/material.dart';
import '../../../../Models/model.dart';
import '../../../../theme/app_theme.dart';
import 'subCategory_components.dart';

class CategoryComponent extends StatelessWidget {
  final Categories category;
  
  CategoryComponent({required this.category});
  
  @override
  Widget build(BuildContext context) {
    // Get icon based on category name
    IconData categoryIcon = _getCategoryIcon(category.name);
    Color categoryColor = _getCategoryColor(category.name);
    
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with gradient background
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  categoryColor.withOpacity(0.7),
                  categoryColor.withOpacity(0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    categoryIcon,
                    color: categoryColor,
                    size: 24,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: Offset(0, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${category.products.length} Products',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Category Description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              category.subheading,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Divider
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          
          // Products Grid
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                _buildProductPreview(category.image),
                SizedBox(width: 12),
                if (category.products.length > 1)
                  _buildProductPreview(category.products[0].image),
                SizedBox(width: 12),
                if (category.products.length > 2)
                  _buildProductPreview(category.products[1].image),
                if (category.products.length > 3)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          '+${category.products.length - 3}',
                          style: TextStyle(
                            color: categoryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductPreview(String image) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[100],
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey[400],
              size: 24,
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    
    if (name.contains('breakfast')) {
      return Icons.free_breakfast;
    } else if (name.contains('meat') || name.contains('fish')) {
      return Icons.set_meal;
    } else if (name.contains('vegetable') || name.contains('veg')) {
      return Icons.eco;
    } else if (name.contains('fruit')) {
      return Icons.apple;
    } else if (name.contains('dairy')) {
      return Icons.egg;
    } else if (name.contains('bakery') || name.contains('bread')) {
      return Icons.bakery_dining;
    } else if (name.contains('snack')) {
      return Icons.fastfood;
    } else if (name.contains('beverage') || name.contains('drink')) {
      return Icons.local_drink;
    } else if (name.contains('household')) {
      return Icons.cleaning_services;
    } else if (name.contains('personal')) {
      return Icons.spa;
    }
    
    return Icons.shopping_bag;
  }
  
  Color _getCategoryColor(String categoryName) {
    final name = categoryName.toLowerCase();
    
    if (name.contains('breakfast')) {
      return Colors.orange;
    } else if (name.contains('meat') || name.contains('fish')) {
      return Colors.redAccent;
    } else if (name.contains('vegetable') || name.contains('veg')) {
      return Colors.green;
    } else if (name.contains('fruit')) {
      return Colors.deepOrange;
    } else if (name.contains('dairy')) {
      return Colors.lightBlue;
    } else if (name.contains('bakery') || name.contains('bread')) {
      return Colors.brown;
    } else if (name.contains('snack')) {
      return Colors.amber;
    } else if (name.contains('beverage') || name.contains('drink')) {
      return Colors.teal;
    } else if (name.contains('household')) {
      return Colors.indigo;
    } else if (name.contains('personal')) {
      return Colors.purple;
    }
    
    return AppTheme.primaryColor;
  }
}