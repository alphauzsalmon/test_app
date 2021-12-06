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
      Response response = await Dio().get(Constants.myLocalHost2);
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
        if (reOrders[i - 1].order == reOrders[i + 1].order) {
          reOrders[i].order = reOrders[i - 1].order;
        }
        if (reOrders[i].order == reOrders[i - 1].order &&
            reOrders[i - 1].orderPrefix!.isNotEmpty) {
          reOrders[i].orderPrefix = String.fromCharCode(
              reOrders[i - 1].orderPrefix!.codeUnitAt(0) + 1);
        }
      }
      if (i == reOrders.length - 1) {
        if (reOrders[i].order == reOrders[i - 1].order &&
            reOrders[i - 1].orderPrefix!.isNotEmpty) {
          reOrders[i].orderPrefix = String.fromCharCode(
              reOrders[i - 1].orderPrefix!.codeUnitAt(0) + 1);
        }
      }
    }

    // Step 2. For enumeration as order
    for (int i = 0; i < reOrders.length; i++, _order++) {
      if (i < reOrders.length - 1) {
        if (reOrders[i].order == reOrders[i + 1].order) {
          for (int j = i; j < reOrders.length - 1; ++j) {
            if (reOrders[j].order != reOrders[j + 1].order) {
              reOrders[j].order = _order;
              i = j;
              break;
            }
            reOrders[j].order = _order;
            i = j;
          }
        } else {
          reOrders[i].order = _order;
        }
      } else {
       reOrders[i].order = _order;
      }
    }

    // Post to API
    reOrders.forEach((element) async {
      try {
        await Dio()
            .post(Constants.myLocalHost2, data: element);
      } catch (err) {
        throw NetworkError(err);
      }
    });
  }
  }

class NetworkError implements Exception {
  final message;
  NetworkError(this.message);
}
