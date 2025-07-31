import 'package:flutter/material.dart';
import '../../services/cart_service.dart';
import '../../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Color _primaryOrange = Color(0xFFFF7F50);
  final Color _lightOrange = Color(0xFFFFF3E0);

  @override
  Widget build(BuildContext context) {
    double subtotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      backgroundColor: _lightOrange,
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: _primaryOrange,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart feels lonely...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some sweets!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(12),
                    separatorBuilder: (context, index) => SizedBox(height: 8),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      double totalPrice = item.price * item.quantity;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              // Product Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  item.sweet.image,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 12),
                              
                              // Product Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.sweet.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${item.gram}g • ₹${item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '₹${totalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _primaryOrange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Quantity Controls
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove_circle_outline, 
                                            color: _primaryOrange),
                                        onPressed: () {
                                          setState(() {
                                            if (item.quantity > 1) {
                                              item.quantity--;
                                            } else {
                                              cartItems.removeAt(index);
                                            }
                                          });
                                        },
                                      ),
                                      Container(
                                        width: 24,
                                        alignment: Alignment.center,
                                        child: Text(item.quantity.toString()),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add_circle_outline, 
                                            color: _primaryOrange),
                                        onPressed: () {
                                          setState(() {
                                            item.quantity++;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, 
                                        color: Colors.grey[400]),
                                    onPressed: () {
                                      setState(() {
                                        cartItems.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Order Summary
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal:', style: TextStyle(color: Colors.grey[600])),
                          Text(
                            '₹${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery:', style: TextStyle(color: Colors.grey[600])),
                          Text('FREE', style: TextStyle(color: _primaryOrange)),
                        ],
                      ),
                      Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${subtotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _primaryOrange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/checkout');
                          },
                          child: Text(
                            'PROCEED TO CHECKOUT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
}