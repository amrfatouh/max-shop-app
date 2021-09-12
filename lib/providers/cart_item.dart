class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem({
    this.id,
    this.title,
    this.quantity,
    this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
