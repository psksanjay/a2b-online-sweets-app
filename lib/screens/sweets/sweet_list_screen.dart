import 'package:flutter/material.dart';
import '../../services/mock_sweets.dart';
import '../../models/sweet.dart';
import '../../services/cart_service.dart';
import 'sweet_detail_screen.dart';

class SweetListScreen extends StatefulWidget {
  @override
  _SweetListScreenState createState() => _SweetListScreenState();
}

class _SweetListScreenState extends State<SweetListScreen> {
  final Color _primaryOrange = Color(0xFFFF5722);
  final Color _lightOrange = Color(0xFFFFF3E0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('AAB Sweets', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: GridView.builder(
          itemCount: mockSweets.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.74,
          ),
          itemBuilder: (context, index) {
            Sweet sweet = mockSweets[index];
            return _buildSweetCard(sweet, context);
          },
        ),
      ),
      floatingActionButton: cartItems.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/checkout'),
              backgroundColor: _primaryOrange,
              child: Stack(
                children: [
                  Align(alignment: Alignment.center, child: Icon(Icons.shopping_bag)),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          cartItems.length.toString(),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSweetCard(Sweet sweet, BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SweetDetailScreen(sweet: sweet),
          ),
        );
        setState(() {});
      },
      borderRadius: BorderRadius.circular(14),
      splashColor: _primaryOrange.withOpacity(0.15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(1, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(
                sweet.image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sweet.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '₹${sweet.gramPrices.values.first} • ${sweet.gramPrices.keys.first}g',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SweetDetailScreen(sweet: sweet),
                          ),
                        );
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                      child: Text('Order Now'),
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
