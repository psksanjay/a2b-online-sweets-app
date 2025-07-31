import 'sweet.dart';

class CartItem {
  final Sweet sweet;
  final int gram;
  final double price;
  int quantity;

  CartItem({
    required this.sweet,
    required this.gram,
    required this.price,
    this.quantity = 1,
  });
}
