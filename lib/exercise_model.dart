class Exercise {
  Exercise({
    this.id,
    this.order,
    this.order_prefix,
  });

  int? id;
  int? order;
  String? order_prefix;

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json["id"],
        order: json["order"],
        order_prefix: json["order_prefix"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "order_prefix": order_prefix,
      };
}
