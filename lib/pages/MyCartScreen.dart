import 'package:flutter/material.dart';
import '../Models/Cart Model.dart';
import 'package:GrocerApp/pages/CheckoutScreen.dart';
import '../Common/SetupProgressWidget.dart';
import 'package:provider/provider.dart';
import '../Common/Cart Provider.dart';
import '../theme/app_theme.dart';
import '../utils/cart_animations.dart';

class MyCartScreen extends StatefulWidget {
  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // Clear cart button
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              if (cartProvider.mainCartItems.isEmpty && 
                  cartProvider.listViewCartItems.isEmpty) {
                return SizedBox.shrink();
              }
              return IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Clear Cart'),
                      content: Text('Are you sure you want to clear your cart?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            cartProvider.clearMainCart();
                            cartProvider.clearListViewCart();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                          ),
                          child: Text('Clear'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final mainCartItems = cartProvider.mainCartItems;
          final listViewCartItems = cartProvider.listViewCartItems;

          bool isCartEmpty = mainCartItems.isEmpty && listViewCartItems.isEmpty;

          return isCartEmpty
              ? _buildEmptyCartView()
              : Column(
                  children: [
                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: StepProgressWidget(currentStep: 1),
                    ),
                    
                    // Cart items
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          // Main cart items section
                          if (mainCartItems.isNotEmpty) 
                            _buildSectionHeader('My Cart'),
                          if (mainCartItems.isNotEmpty)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return _buildCartItem(
                                    cartProvider,
                                    mainCartItems[index],
                                    true,
                                  );
                                },
                                childCount: mainCartItems.length,
                              ),
                            ),
                            
                          // List view cart items section
                          if (listViewCartItems.isNotEmpty)
                            _buildSectionHeader('List View Cart'),
                          if (listViewCartItems.isNotEmpty)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  return _buildCartItem(
                                    cartProvider,
                                    listViewCartItems[index],
                                    false,
                                  );
                                },
                                childCount: listViewCartItems.length,
                              ),
                            ),
                            
                          // Promo code section
                          SliverToBoxAdapter(
                            child: _buildPromoCodeSection(),
                          ),
                          
                          // Order summary
                          SliverToBoxAdapter(
                            child: _buildOrderSummary(cartProvider),
                          ),
                          
                          // Bottom padding
                          SliverToBoxAdapter(
                            child: SizedBox(height: 100),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
      bottomSheet: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final isCartEmpty = cartProvider.mainCartItems.isEmpty && 
                             cartProvider.listViewCartItems.isEmpty;
          
          if (isCartEmpty) return SizedBox.shrink();
          
          return _buildCheckoutButton(cartProvider);
        },
      ),
    );
  }
  
  SliverToBoxAdapter _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCartItem(CartProvider cartProvider, CartItem item, bool isMainCart) {
    final productImageKey = GlobalKey();
    
    return Dismissible(
      key: Key(item.variant.var_id + (isMainCart ? '_main' : '_list')),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      onDismissed: (direction) {
        if (isMainCart) {
          cartProvider.removeFromMainCart(item.variant.var_id);
        } else {
          cartProvider.removeFromListViewCart(item.variant.var_id);
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.variant.name} removed from cart'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                if (isMainCart) {
                  cartProvider.addToMainCart(item.variant);
                  cartProvider.updateMainCartQuantity(
                    item.variant.var_id, 
                    item.quantity
                  );
                } else {
                  cartProvider.addToListViewCart(item.variant);
                  cartProvider.updateListViewCartQuantity(
                    item.variant.var_id, 
                    item.quantity
                  );
                }
              },
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: 100,
              height: 100,
              key: productImageKey,
              child: ClipRRect(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.asset(
                  item.variant.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variant.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.variant.weight,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.variant.pre_price != item.variant.curr_price)
                              Text(
                                item.variant.pre_price,
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            Text(
                              item.variant.curr_price,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        
                        // Quantity counter
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              // Decrease button
                              InkWell(
                                onTap: () {
                                  if (item.quantity > 1) {
                                    if (isMainCart) {
                                      cartProvider.updateMainCartQuantity(
                                        item.variant.var_id, 
                                        item.quantity - 1
                                      );
                                    } else {
                                      cartProvider.updateListViewCartQuantity(
                                        item.variant.var_id, 
                                        item.quantity - 1
                                      );
                                    }
                                  } else {
                                    if (isMainCart) {
                                      cartProvider.removeFromMainCart(item.variant.var_id);
                                    } else {
                                      cartProvider.removeFromListViewCart(item.variant.var_id);
                                    }
                                  }
                                },
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(7),
                                      bottomLeft: Radius.circular(7),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              
                              // Quantity
                              Container(
                                height: 36,
                                width: 36,
                                alignment: Alignment.center,
                                child: Text(
                                  item.quantity.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              
                              // Increase button
                              InkWell(
                                onTap: () {
                                  if (isMainCart) {
                                    cartProvider.updateMainCartQuantity(
                                      item.variant.var_id, 
                                      item.quantity + 1
                                    );
                                  } else {
                                    cartProvider.updateListViewCartQuantity(
                                      item.variant.var_id, 
                                      item.quantity + 1
                                    );
                                  }
                                  
                                  CartAnimations.flyToCart(
                                    context,
                                    productImageKey,
                                    item.variant.image,
                                    cartIconPos: Offset(
                                      MediaQuery.of(context).size.width - 30,
                                      MediaQuery.of(context).padding.top + 20,
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(7),
                                      bottomRight: Radius.circular(7),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPromoCodeSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer_outlined,
            color: AppTheme.primaryColor,
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Apply promo code',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderSummary(CartProvider cartProvider) {
    // Calculate main cart subtotal
    double mainCartSubtotal = cartProvider.mainCartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      return sum + (price * item.quantity);
    });
    
    // Calculate list view cart subtotal
    double listViewCartSubtotal = cartProvider.listViewCartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      return sum + (price * item.quantity);
    });
    
    double subtotal = mainCartSubtotal + listViewCartSubtotal;
    double deliveryFee = 50.0; // Example delivery fee
    double discount = 0.0; // Apply discount if promo code is used
    double total = subtotal + deliveryFee - discount;
    
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 16),
          _buildSummaryRow('Subtotal', 'Rs. ${subtotal.toStringAsFixed(2)}'),
          SizedBox(height: 8),
          _buildSummaryRow('Delivery Fee', 'Rs. ${deliveryFee.toStringAsFixed(2)}'),
          SizedBox(height: 8),
          if (discount > 0) ...[
            _buildSummaryRow(
              'Discount',
              '- Rs. ${discount.toStringAsFixed(2)}',
              discountColor: Colors.green,
            ),
            SizedBox(height: 8),
          ],
          Divider(),
          SizedBox(height: 8),
          _buildSummaryRow(
            'Total',
            'Rs. ${total.toStringAsFixed(2)}',
            isBold: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? discountColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: discountColor ?? (isBold ? AppTheme.primaryColor : Colors.black87),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCheckoutButton(CartProvider cartProvider) {
    // Calculate total price
    double mainCartSubtotal = cartProvider.mainCartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      return sum + (price * item.quantity);
    });
    
    double listViewCartSubtotal = cartProvider.listViewCartItems.fold(0.0, (sum, item) {
      final price = double.tryParse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      return sum + (price * item.quantity);
    });
    
    double total = mainCartSubtotal + listViewCartSubtotal + 50.0; // Adding delivery fee
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '(Rs. ${total.toStringAsFixed(2)})',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_cart.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.shopping_cart_outlined,
              size: 100,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Looks like you haven\'t added\nanything to your cart yet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Start Shopping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
