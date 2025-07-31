import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CartFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) return SizedBox(); // Hide FAB if cart is empty

    return Positioned(
      bottom: 16,
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/checkout');
        },
        icon: Icon(Icons.shopping_cart),
        label: Text('${cartItems.length} item${cartItems.length > 1 ? 's' : ''}'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
