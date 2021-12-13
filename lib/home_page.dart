import 'package:flutter/material.dart';
import 'package:reordereable_list_view/exercise_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Exercise>? _items;
  List<Map<String, dynamic>> exercises = [
    {"id": 1, "order": 1, "order_prefix": ""},
    {"id": 2, "order": 2, "order_prefix": "a"},
    {"id": 3, "order": 2, "order_prefix": "b"},
    {"id": 4, "order": 2, "order_prefix": "c"},
    {"id": 5, "order": 3, "order_prefix": ""},
    {"id": 6, "order": 4, "order_prefix": ""},
    {"id": 7, "order": 5, "order_prefix": "a"},
    {"id": 8, "order": 5, "order_prefix": "b"},
    {"id": 9, "order": 6, "order_prefix": ""},
    {"id": 10, "order": 7, "order_prefix": ""}
  ];
  @override
  void initState() {
    super.initState();
    _items = exercises.map((e) => Exercise.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
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
      body: ReorderableListView.builder(
        itemCount: _items!.length,
        itemBuilder: (context, index) => Padding(
          key: Key('${_items![index].id}'),
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          child: ListTile(
            tileColor: Colors.grey,
            title: Text(
              '${_items![index].order}: ${_items![index].order_prefix}',
              style: const TextStyle(fontSize: 30.0),
            ),
            subtitle: Text(
              'id: ${_items![index].id}',
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
        ),
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final Exercise item = _items!.removeAt(oldIndex);
            _items!.insert(newIndex, item);
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          "Post",
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          setState(() {
            fakePostToApi(_items!);
          });
        },
      ),
    );
  }

  fakePostToApi(List<Exercise> items) {
    int _order = 1;

    // Step 1. For sorting two-tier tree structure
    for (int i = 1; i < items.length; i++) {
      if (i < items.length - 1) {
        if (items[i - 1].order == items[i + 1].order) {
          items[i].order = items[i - 1].order;
        }
      }
    }

    // Step 2. For spelling order_prefix
    for (int i = 1; i < items.length; i++) {
      if (i < items.length - 1) {
        if (items[i].order == items[i + 1].order) {
          items[i].order_prefix = "a";
        }
        if (items[i].order == items[i - 1].order &&
            items[i - 1].order_prefix!.isNotEmpty) {
          items[i].order_prefix =
              String.fromCharCode(items[i - 1].order_prefix!.codeUnitAt(0) + 1);
        } else if(items[i].order != items[i - 1].order && items[i].order != items[i + 1].order) {
          items[i].order_prefix = "";
        }
      }
      else  {
        if (items[i].order == items[i - 1].order &&
            items[i - 1].order_prefix!.isNotEmpty) {
          items[i].order_prefix =
              String.fromCharCode(items[i - 1].order_prefix!.codeUnitAt(0) + 1);
        }
        else if(items[i].order != items[i - 1].order) {
          items[i].order_prefix = "";
        }
      }
    }

    // Step 3. For numbering as order
    for (int i = 0; i < items.length; i++, _order++) {
      if (i < items.length - 1) {
        if (items[i].order == items[i + 1].order) {
          for (int j = i; j < items.length - 1; ++j) {
            if (items[j].order != items[j + 1].order) {
              items[j].order = _order;
              i = j;
              break;
            }
            items[j].order = _order;
            i = j;
          }
        } else {
          items[i].order = _order;
        }
      } else {
        items[i].order = _order;
      }
    }
  }
}
