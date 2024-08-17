import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/listviewbuilder.dart';

class Mainscreen extends StatefulWidget {
  Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  var mybox = Hive.box('MyBox');

  List todos = [];

  TextEditingController todoText = TextEditingController();

  void addTodos() async {
    if (todoText.text.trim().isEmpty) {
      return;
    }

    if (todos.any((todo) => todo['title'] == todoText.text.trim())) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('the todo already exist'),
              content: Text('the todo ${todoText.text} already exist'),
              actions: [
                InkWell(
                  child: const Text('close'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
      return;
    }
    await mybox.add({'title': todoText.text, 'isDone': false});
    loadItem();
    Navigator.pop(context);
    todoText.text = '';
  }

  void loadItem() {
    setState(() {
      todos = mybox.keys.map((key) {
        var todo = mybox.get(key);

        return {'key': key, 'title': todo['title'], 'isDone': todo['isDone']};
      }).toList();
      filterTodo = todos;
    });
  }

  @override
  void initState() {
    loadItem();
    super.initState();
  }

  List filterTodo = [];

  void onAddButtonClick() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  onSubmitted: (value) {
                    addTodos();
                  },
                  controller: todoText,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'write your todo here'),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    addTodos();
                  },
                  child: const Text('add'))
            ],
          );
        });
  }

  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onAddButtonClick();
          },
          backgroundColor: Colors.indigo,
          child: const Icon(Icons.add),
        ),
        drawer: const Drawer(
          child: Column(children: [
            
          ],),
        ),
        appBar: AppBar(
          title: const Text('Todo App'),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            filter == 'all' ? Colors.red[800] : null,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () {
                      setState(() {
                        filterTodo = todos;
                        filter = 'all';
                      });
                    },
                    child: Text(
                      'all',
                      style: TextStyle(
                          color: filter == 'all' ? Colors.white : null),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            filter == 'completed' ? Colors.red[800] : null,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () {
                      setState(() {
                        filterTodo =
                            todos.where((todo) => todo['isDone']).toList();
                        filter = 'completed';
                      });
                    },
                    child: const Text('completed')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            filter == 'uncompleted' ? Colors.red[800] : null,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () {
                      setState(() {
                        filterTodo =
                            todos.where((todo) => !todo['isDone']).toList();
                        filter = 'uncompleted';
                      });
                    },
                    child: const Text('uncompleted'))
              ],
            ),
            Expanded(
                child: !todos.isEmpty
                    ? ListViewBuilder(
                        todos: filterTodo,
                        loadTodo: loadItem,
                        mybox: mybox,
                      )
                    : const Center(child: Text('you have no todo'))),
          ],
        ));
  }
}
