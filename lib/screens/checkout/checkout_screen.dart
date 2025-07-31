import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'; // Razorpay import
import '../../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Color _primaryOrange = Color(0xFFFF7F50);
  final Color _lightOrange = Color(0xFFFFF3E0);

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Successful! Payment ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );
    // TODO: Clear cart or redirect to success page
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed: ${response.message}"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Wallet Selected: ${response.walletName}"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // TODO: Replace with your Razorpay test key
      'amount': (amount * 100).toInt(), // amount in paise
      'name': 'A2B Sweets',
      'description': 'Sweet Order Payment',
      'prefill': {
        'contact': '9123456789',
        'email': 'customer@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      backgroundColor: _lightOrange,
      appBar: AppBar(
        title: Text('Checkout', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: _primaryOrange,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: cartItems.length,
                      separatorBuilder: (context, index) => Divider(color: Colors.orange[100], height: 1),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(item.sweet.image, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            title: Text(item.sweet.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.gram}g - ₹${item.price}', style: TextStyle(color: Colors.grey[600])),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline, color: Colors.grey[400]),
                              onPressed: () {
                                // Optional: Add remove item functionality
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, -2)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Subtotal:', style: TextStyle(color: Colors.grey[600])),
                            Text('₹$total', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Delivery:', style: TextStyle(color: Colors.grey[600])),
                            Text('₹0', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(color: Colors.orange[100]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryOrange)),
                            Text('₹$total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryOrange)),
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
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            onPressed: () => _openCheckout(total),
                            child: Text('PAY ₹$total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
