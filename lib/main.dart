import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reordereable_list_view/screens/reorderable_list_view_page.dart';
import 'BloC/Orders_Cubit/orders_cubit.dart';
import 'BloC/Orders_Repository/orders_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrdersCubit(
        SampleOrdersRepository(),
      ),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: OrdersView(),
      ),
    );
  }
}
