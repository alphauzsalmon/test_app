import 'package:dio/dio.dart';
import 'package:reordereable_list_view/consts/consts.dart';
import 'package:reordereable_list_view/models/orders_model.dart';

abstract class OrdersRepository {
  Future<List<Order>> getOrdersFromApi();
  void postOrdersToApi(List<Order> reOrders);
}

class SampleOrdersRepository extends OrdersRepository {
  @override
  Future<List<Order>> getOrdersFromApi() async {
    try {
      Response response = await Dio().get(Constants.myApi);
      return (response.data as List)
          .map(
            (e) => Order.fromJson(e),
      )
          .toList();
    } catch (err) {
      return throw NetworkError(err);
    }
  }

  @override
  void postOrdersToApi(List<Order> reOrders) async {
    int _order = 1;

    // Step 1. For sorting SuperSets
    for (int i = 1; i < reOrders.length; i++) {
      if (i < reOrders.length - 1) {
        if (reOrders[i - 1].userId == reOrders[i + 1].userId) {
          reOrders[i].userId = reOrders[i - 1].userId;
        }
      }
    }

    // Step 2. For enumeration as order
    for (int i = 0; i < reOrders.length; i++, _order++) {
      if (i < reOrders.length - 1) {
        if (reOrders[i].userId == reOrders[i + 1].userId) {
          for (int j = i; j < reOrders.length - 1; ++j) {
            if (reOrders[j].userId != reOrders[j + 1].userId) {
              reOrders[j].userId = _order;
              i = j;
              break;
            }
            reOrders[j].userId = _order;
            i = j;
          }
        } else {
          reOrders[i].userId = _order;
        }
      }
    }

    // Post to API
    for (int i = 0; i < reOrders.length; i++) {
      try {
        await Dio()
            .post(Constants.myLocalHost, data: reOrders[i]);
      } catch (err) {
        throw NetworkError(err);
      }
    }
  }
  }

class NetworkError implements Exception {
  final message;
  NetworkError(this.message);
}
