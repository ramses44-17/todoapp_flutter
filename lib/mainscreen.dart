import 'package:flutter/material.dart';


class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  List<String> todos = ['sleep', 'learn english'];

  TextEditingController todoText = TextEditingController();

  void addTodos() {
    setState(() {
      todos.insert(0, todoText.text);
    });
    Navigator.pop(context);
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
                  decoration: InputDecoration(hintText: 'entrez votre todo ici'),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    addTodos();
                  },
                  child: Text('ajouter'))
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
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                todos[index],
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              leading: Icon(Icons.keyboard_double_arrow_right_sharp),
            );
          }),
    );
  }
}
