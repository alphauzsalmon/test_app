import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reordereable_list_view/BloC/Orders_Repository/orders_repository.dart';
import 'package:reordereable_list_view/BloC/Orders_State/orders_state.dart';
import 'package:reordereable_list_view/models/orders_model.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepository _ordersRepository;
  OrdersCubit(this._ordersRepository) : super(const OrdersLoading(),);

  Future<void> getOrders() async {
    try {
      emit(const OrdersLoading());
      final response = await _ordersRepository.getOrdersFromApi();
      emit(OrdersCompleted(response),);
    } catch (e) {
      emit(OrdersError("No Orders"),);
    }
  }

  void postOrders(List<Order> items) async {
    try {
      _ordersRepository.postOrdersToApi(items);
    } catch (err) {
      emit(OrdersError("Error in post to API"),);
    }
  }

  onReorder(int oldIndex, int newIndex, List<Order> _items) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Order item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    emit(OrdersCompleted(_items));
  }
}