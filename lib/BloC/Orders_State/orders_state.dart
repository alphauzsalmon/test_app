import 'package:reordereable_list_view/models/orders_model.dart';

abstract class OrdersState {
  const OrdersState();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersCompleted extends OrdersState {
  final List<Order> response;
  const OrdersCompleted(this.response);
}

class OrdersError extends OrdersState {
  final String message;
  OrdersError(this.message);
}