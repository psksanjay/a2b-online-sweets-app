import 'package:flutter/material.dart';
import '../../models/sweet.dart';
import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class SweetDetailScreen extends StatefulWidget {
  final Sweet sweet;

  SweetDetailScreen({required this.sweet});

  @override
  _SweetDetailScreenState createState() => _SweetDetailScreenState();
}

class _SweetDetailScreenState extends State<SweetDetailScreen> {
  String? selectedGram;
  final Color _primaryOrange = Color(0xFFFF7F50);
  final Color _darkOrange = Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.sweet.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: _primaryOrange,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sweet Image (unchanged)
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
                border: Border.all(color: Colors.orange[100]!, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.sweet.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Sweet Name (unchanged)
            Text(
              widget.sweet.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _darkOrange,
              ),
            ),

            // Sweet Description (newly added)
            SizedBox(height: 8),
            Text(
              widget.sweet.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            SizedBox(height: 16),

            // Divider (unchanged)
            Divider(color: Colors.orange[200], thickness: 1),
            SizedBox(height: 16),

            // Quantity Selection (unchanged)
            Text(
              'Select Quantity:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),

            // Gram Selection Chips (unchanged)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: widget.sweet.gramPrices.entries.map((entry) {
                return ChoiceChip(
                  label: Text(
                    '${entry.key}g - ₹${entry.value}',
                    style: TextStyle(
                      color: selectedGram == entry.key 
                          ? Colors.white 
                          : _darkOrange,
                    ),
                  ),
                  selected: selectedGram == entry.key,
                  selectedColor: _primaryOrange,
                  backgroundColor: Colors.orange[50],
                  shape: StadiumBorder(
                    side: BorderSide(color: Colors.orange[200]!),
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedGram = entry.key;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 32),

            // Add to Cart Button (unchanged)
            Center(
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryOrange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedGram == null 
                        ? Colors.grey[300] 
                        : _primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: selectedGram == null
                      ? null
                      : () {
                          double price = widget.sweet.gramPrices[selectedGram]!.toDouble();
                          cartItems.add(CartItem(
                            sweet: widget.sweet,
                            gram: int.parse(selectedGram!),
                            price: price,
                          ));

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${widget.sweet.name} (${selectedGram}g) added to cart',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: _primaryOrange,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                textColor: Colors.white,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart');
                                },
                              ),
                            ),
                          );
                        },
                  child: Text(
                    'ADD TO CART',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedGram == null 
                          ? Colors.grey[600] 
                          : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
