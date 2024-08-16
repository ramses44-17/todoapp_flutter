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
  String filter = 'all';
  var mybox = Hive.box('MyBox');

  List todos = [];

  TextEditingController todoText = TextEditingController();

  void addTodos() async {
    if (todoText.text.trim().isEmpty) {
      return;
    }

    if (todos.any((todo) => todo['title'] == todoText.text)) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('the todo already exist'),
              content: Text('the todo ${todoText.text} already exist'),
              actions: [
                InkWell(
                  child: Text('close'),
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
    });
  }

  @override
  void initState() {
    loadItem();
    super.initState();
  }

  void onAddButtonClick() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: todoText,
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'write your todo here'),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    addTodos();
                  },
                  child: Text('add'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onAddButtonClick();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.indigo,
        ),
        drawer: Drawer(),
        appBar: AppBar(
          title: Text('Todo App'),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                    onPressed: () {
                      setState(() {
                        filter = 'all';
                      });
                    },
                    child: Text('all')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                    onPressed: () {
                      setState(() {
                        filter = 'completed';
                      });
                    },
                    child: Text('completed')),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder()),
                    onPressed: () {
                      setState(() {
                        filter = 'uncompleted';
                      });
                    },
                    child: Text('uncompleted'))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceAround,
            ),
            Expanded(
                child: ListViewBuilder(
              todos: todos,
              loadTodo: loadItem,
              mybox: mybox,
            )),
          ],
        ));
  }
}
