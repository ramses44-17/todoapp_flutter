import 'package:flutter/material.dart';

class ListViewBuilder extends StatefulWidget {
  List todos;
  void Function() loadTodo;
  var mybox;
  ListViewBuilder(
      {super.key,
      required this.todos,
      required this.loadTodo,
      required this.mybox});

  @override
  State<ListViewBuilder> createState() => _ListViewBuilderState();
}

class _ListViewBuilderState extends State<ListViewBuilder> {
  void deleteTodos(key) async {
    await widget.mybox.delete(key);
    widget.loadTodo();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.todos.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              onDismissed: (direction) {
                deleteTodos(widget.todos[index]['key']);
              },
              key: UniqueKey(),
              secondaryBackground: Container(
                decoration: BoxDecoration(color: Colors.red),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [Icon(Icons.delete)],
                  ),
                ),
              ),
              background: Container(
                decoration: BoxDecoration(color: Colors.red),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Icon(Icons.delete)],
                  ),
                ),
              ),
              child: ListTile(
                onTap: () {
                  bool value = !widget.todos[index]['isDone'];
                  setState(() {
                    widget.todos[index]['isDone'] = value;
                  });
                  final todo = widget.todos[index];
                  widget.mybox
                      .putAt(index, {'title': todo['title'], 'isDone': value});
                },
                leading: Checkbox(
                    value: widget.todos[index]['isDone'],
                    onChanged: (value) {
                      setState(() {
                        widget.todos[index]['isDone'] = value;
                      });
                      final todo = widget.todos[index];
                      widget.mybox.putAt(
                          index, {'title': todo['title'], 'isDone': value});
                    }),
                title: Text(
                  widget.todos[index]['title'].toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      decoration: widget.todos[index]['isDone']
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ));
        });
  }
}
