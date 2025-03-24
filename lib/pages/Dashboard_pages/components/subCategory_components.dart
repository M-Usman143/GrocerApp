import 'package:flutter/material.dart';
import '../../../../Models/model.dart';
import '../../../../theme/app_theme.dart';

// Widget for displaying a subcategory item in a grid
class SubCategoryItem extends StatelessWidget {
  final Products product;
  final Color categoryColor;
  final Categories parentCategory;
  
  SubCategoryItem({
    required this.product, 
    required this.categoryColor, 
    required this.parentCategory
  });
  
  @override
  Widget build(BuildContext context) {
    int variantCount = product.variants.length;
    
    return InkWell(
      onTap: () {
        // Navigate to the variants screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryDetailPage(
              product: product, 
              parentCategory: parentCategory
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: categoryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: categoryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.category, color: categoryColor, size: 20),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    '$variantCount ${variantCount == 1 ? 'variant' : 'variants'}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Page to display all variants for a selected subcategory
class SubCategoryDetailPage extends StatelessWidget {
  final Products product;
  final Categories parentCategory;

  SubCategoryDetailPage({required this.product, required this.parentCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: product.variants.isEmpty
        ? Center(child: Text('No variants available'))
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: product.variants.length,
            itemBuilder: (context, index) {
              final variant = product.variants[index];
              return VariantCard(variant: variant);
            },
          ),
    );
  }
}

// Widget for displaying a variant card
class VariantCard extends StatelessWidget {
  final Variant variant;
  
  VariantCard({required this.variant});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.asset(
                      variant.image,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                        Icon(Icons.image, size: 40, color: Colors.grey[400]),
                    ),
                  ),
                ),
                if (variant.discount != '')
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        variant.discount,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (variant.isTrending)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Trending',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    variant.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Weight: ${variant.weight}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        variant.curr_price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        variant.pre_price,
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
  