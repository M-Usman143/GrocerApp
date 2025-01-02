import 'package:flutter/material.dart';
import '../Models/Cart Model.dart';
import 'CheckoutScreen.dart';
import 'package:GrocerApp/pages/Dashboard.dart';
import '../Common/SetupProgressWidget.dart';
import 'package:provider/provider.dart';
import '../Common/Cart Provider.dart';

class MyCartScreen extends StatefulWidget {

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: CartProviders(),
    );
  }

  Consumer<CartProvider> CartProviders() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {

        final mainCartItems = cartProvider.mainCartItems;
        final listViewCartItems = cartProvider.listViewCartItems;


        return mainCartItems.isEmpty && listViewCartItems.isEmpty
            ? buildEmptyCartView(context)
            : Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StepProgressWidget(currentStep: 1),
                    buildProductMainListView(cartProvider),
                    buildProductListViews(cartProvider),
                    buildFinalCartSummary(cartProvider), // Final summary for both carts
                  //  buildCartSummaryListview(cartProvider),
                  ],
                ),
              ),
            ),
            buildCheckoutButton(context),
          ],
        );
      },
    );
  }

  double calculateSubtotalForMainCart(CartProvider cartProvider) {
    double subtotal = 0;
    cartProvider.mainCartItems.forEach((item) {
      subtotal += (double.parse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) * item.quantity);
    });
    return subtotal;
  }

  double calculateSubtotalForListViewCart(CartProvider cartProvider) {
    double subtotal = 0;
    cartProvider.listViewCartItems.forEach((item) {
      subtotal += (double.parse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) * item.quantity);
    });
    return subtotal;
  }

  Widget buildFinalCartSummary(CartProvider cartProvider) {
    double mainCartSubtotal = calculateSubtotalForMainCart(cartProvider);
    double listViewCartSubtotal = calculateSubtotalForListViewCart(cartProvider);
    double totalSubtotal = mainCartSubtotal + listViewCartSubtotal;

    double promoDiscount = 50; // Adjust as necessary
    double finalTotal = totalSubtotal - promoDiscount;

    return Column(
      children: [
        buildSummaryRow("Delivery Charges", "Calculated at next step"),
        buildDivider(),
        buildSummaryRow("Main Cart Subtotal", "Rs: ${mainCartSubtotal.toStringAsFixed(2)}"),
        buildSummaryRow("List View Cart Subtotal", "Rs: ${listViewCartSubtotal.toStringAsFixed(2)}"),
        buildDivider(),
        buildSummaryRow("Promo Code", "- Rs: $promoDiscount"),
        buildDivider(),
        buildOrangeContainer(),
        buildDivider(),
        buildSummaryRow("Final Total", "Rs: ${finalTotal.toStringAsFixed(2)}"),
      ],
    );
  }

  Widget buildCartSummaryMain(CartProvider cartProvider) {
    double subtotal = 0;
    cartProvider.mainCartItems.forEach((item) {
      subtotal += (double.parse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) * item.quantity);
    });
    double promoDiscount = 50; // You can modify this based on the applied promo
    double total = subtotal - promoDiscount;

    return Column(
      children: [
        buildSummaryRow("Delivery Charges", "Calculated at next step"),
        buildDivider(),
        buildSummaryRow("Sub Total", "Rs: ${subtotal.toStringAsFixed(2)}"),
        buildDivider(),
        buildSummaryRow("Promo Code", "- Rs: $promoDiscount"),
        buildDivider(),
        buildOrangeContainer(),
        buildDivider(),
        buildSummaryRow("Total", "Rs: ${total.toStringAsFixed(2)}"),

      ],
    );
  }

  Widget buildCartSummaryListview(CartProvider cartProvider) {
    double subtotal = 0;
    cartProvider.listViewCartItems.forEach((item) {
      subtotal += (double.parse(item.variant.curr_price.replaceAll(RegExp(r'[^0-9.]'), '')) * item.quantity);
    });
    double promoDiscount = 50; // You can modify this based on the applied promo
    double total = subtotal - promoDiscount;

    return Column(
      children: [
        buildSummaryRow("Delivery Charges", "Calculated at next step"),
        buildDivider(),
        buildSummaryRow("Sub Total", "Rs: ${subtotal.toStringAsFixed(2)}"),
        buildDivider(),
        buildSummaryRow("Promo Code", "- Rs: $promoDiscount"),
        buildDivider(),
        buildOrangeContainer(),
        buildDivider(),
        buildSummaryRow("Total", "Rs: ${total.toStringAsFixed(2)}"),

      ],
    );
  }

  Widget buildProductMainListView(CartProvider cartProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartProvider.mainCartItems.length,
      itemBuilder: (context, index) {
        final item = cartProvider.mainCartItems[index];
        return buildProductItem(item, cartProvider, index, true);
      },
    );
  }

  Widget buildProductListViews(CartProvider cartProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cartProvider.listViewCartItems.length,
      itemBuilder: (context, index) {
        final item = cartProvider.listViewCartItems[index];
        return buildProductItem(item, cartProvider, index, false);
      },
    );
  }

  Widget buildProductItem(CartItem item, CartProvider cartProvider, int index, bool isMainCart) {
    final variant = item.variant;

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      variant.image,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(variant.name),
                        Text(variant.weight),
                        Text("₹${variant.curr_price}"),
                        Row(
                          children: [
                            Text(variant.curr_price.toString()),
                            SizedBox(width: 8),
                            Text(
                              variant.pre_price.toString(),
                              style: TextStyle(decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: isMainCart
                    ? buildQuantityCounterMain(index, item.quantity, cartProvider)
                    : buildQuantityCounterListview(index, item.quantity, cartProvider),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildQuantityCounterMain(int index, int quantity, CartProvider cartProvider) {
    return buildQuantityCounter(index, quantity, cartProvider, true);
  }

  Widget buildQuantityCounterListview(int index, int quantity, CartProvider cartProvider) {
    return buildQuantityCounter(index, quantity, cartProvider, false);
  }


  // Common Quantity Counter Widget
  Widget buildQuantityCounter(int index, int quantity, CartProvider cartProvider, bool isMainCart) {
    return Container(
      margin: EdgeInsets.only(left: 5),
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isMainCart) {
                  if (quantity > 1) {
                    cartProvider.updateMainCartQuantity(cartProvider.mainCartItems[index].variant.var_id, quantity - 1);
                  } else {
                    cartProvider.removeFromMainCart(cartProvider.mainCartItems[index].variant.var_id);
                  }
                } else {
                  if (quantity > 1) {
                    cartProvider.updateListViewCartQuantity(cartProvider.listViewCartItems[index].variant.var_id, quantity - 1);
                  } else {
                    cartProvider.removeFromListViewCart(cartProvider.listViewCartItems[index].variant.var_id);
                  }
                }
              });
            },
            icon: Icon(Icons.remove),
          ),
          Text(quantity.toString()),
          IconButton(
            onPressed: () {
              setState(() {
                if (isMainCart) {
                  cartProvider.updateMainCartQuantity(cartProvider.mainCartItems[index].variant.var_id, quantity + 1);
                } else {
                  cartProvider.updateListViewCartQuantity(cartProvider.listViewCartItems[index].variant.var_id, quantity + 1);
                }
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }


  Widget buildCartActionButtonListview(int index, int quantity) {
    if (quantity > 0) {
      return buildQuantityCounterListview(index, quantity, Provider.of<CartProvider>(context, listen: false));
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 150),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
          ),
          onPressed: () {
            setState(() {
              // productQuantities[index] = 1;
            });
          },
          child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }



  Widget buildCartActionButtonMain(int index, int quantity) {
    if (quantity > 0) {
      return buildQuantityCounterMain(index, quantity, Provider.of<CartProvider>(context, listen: false));
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 150),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
          ),
          onPressed: () {
            setState(() {
              // productQuantities[index] = 1;
            });
          },
          child: const Text("Add to Cart", style: TextStyle(color: Colors.white)),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text("My Cart"),
    );
  }

  Stack BottomManager(BuildContext context) {
    return Stack(
      children: [
        // Main content with the scrollable list of products
        Column(
          children: [
            StepProgressWidget(currentStep: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
//                  buildProductListView(cartItems),
                    Container(
                      height: 70,
                      width: 400,
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Delivery Charged",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Calculated at next step",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      height: 70,
                      width: 400,
                      color: Colors.white,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Sub Total",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Rs: 255",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      height: 70,
                      width: 400,
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Promo Code",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Rs: 326",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      height: 180,
                      width: 400,
                      color: Colors.orange,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: const [
                                  Text(
                                    "Ultimate Free Deliveries",
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 100,
                              width: 400,
                              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      height: 70,
                      width: 400,
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Total:",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Rs: 326",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80,),

                  ],
                ),
              ),

            ),
          ],
        ),

        // Fixed button at the bottom of the screen
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 70,
            color: Colors.white,
            child: Center(
              child: Container(
                width: 350,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Set background color to orange
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    // Handle your button action here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
                    );
                  },
                  child: const Text(
                    "Proceed to Checkout",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSummaryRow(String label, String value) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      height: 1,
      color: Colors.grey, // Grey line divider
    );
  }

  Widget buildOrangeContainer() {
    return Container(
        height: 200,
        width: 410,
        color: Colors.orange,
        child:Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 7 , right: 200),
              child: Text(
                "Additional Information", // You can add custom content here
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              height: 130,
              width: 350,
            )
          ],
        )

    );
  }

  Widget buildEmptyCartView(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.grey[200]),
        StepProgressWidget(currentStep: 1),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 400,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your Cart is empty",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const Text(
                  "Lets fill it up by adding some items!",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 350,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CheckoutScreen()),
                      );
                    },
                    child: const Text(
                      "Start Shopping",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCheckoutButton(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashbaord()),
          );
        },
        child: const Text(
          "Proceed to Checkout",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

}
