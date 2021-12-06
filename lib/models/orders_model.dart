
class Order {
  Order({
    this.orderId,
    this.order,
    this.orderPrefix,
  });

  int? orderId;
  int? order;
  String? orderPrefix;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["id"],
    order: json["order"],
    orderPrefix: json["order_prefix"],
  );

  Map<String, dynamic> toJson() => {
    "id": orderId,
    "order": order,
    "order_prefix": orderPrefix,
  };
}
