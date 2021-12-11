import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reordereable_list_view/BloC/Orders_Cubit/orders_cubit.dart';
import 'package:reordereable_list_view/BloC/Orders_State/orders_state.dart';
import 'package:reordereable_list_view/consts/size_config.dart';
import 'package:reordereable_list_view/models/orders_model.dart';
import 'package:reordereable_list_view/consts/consts.dart';

class OrdersView extends StatelessWidget {
  List<Order>? _items;
  OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    context.read<OrdersCubit>().getOrders();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          "Physical Transformation",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrdersError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrdersCompleted) {
            return ReorderableListView.builder(
              itemCount: state.response.length,
              itemBuilder: (context, index) => Padding(
                key: Key('${state.response[index].id}'),
                padding: EdgeInsets.symmetric(
                  vertical: getHeight(10.0),
                  horizontal: getWidth(20.0),
                ),
                child: ListTile(
                  tileColor: Colors.grey,
                  title: Text(
                    '${state.response[index].userId}: ${state.response[index].title}',
                    style: Constants.textStyle(
                      getFont(
                        30.0,
                      ),
                    ),
                  ),
                  subtitle: Text(
                    'id: ${state.response[index].id}',
                    style: Constants.textStyle(
                      getFont(
                        20.0,
                      ),
                    ),
                  ),
                ),
              ),
              onReorder: (int oldIndex, int newIndex) async {
                await context
                    .read<OrdersCubit>()
                    .onReorder(oldIndex, newIndex, state.response);
                _items = state.response;
              },
            );
          } else {
            final error = state as OrdersError;
            return Text(error.message);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Post",
          style: Constants.textStyle(
            getFont(
              20.0,
            ),
          ),
        ),
        onPressed: () {
          context.read<OrdersCubit>().postOrders(_items!);
        },
      ),
    );
  }
}
