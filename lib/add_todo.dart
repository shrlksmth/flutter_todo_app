import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/main_screen.dart';

class AddTodo extends StatefulWidget {
  final bool isEdit;
  final Map todo;
  const AddTodo({super.key, required this.isEdit, required this.todo});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit == true) {
      setState(() {
        title.text = widget.todo['title'];
        description.text = widget.todo['description'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(hintText: "Title"),
            ),
            TextField(
              controller: description,
              decoration: InputDecoration(hintText: "Description"),
              minLines: 5,
              maxLines: 8,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  widget.isEdit == false ? addTodo() : updateTodo(widget.todo);
                },
                style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size(200, 40))),
                child: Text(widget.isEdit == false ? "Add" : "Update"))
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.isEdit == false ? "Add Todo" : "Edit Todo"),
      ),
    );
  }

  Future<void> addTodo() async {
    final body = {
      "title": title.text,
      "description": description.text,
      "is_completed": false
    };

    final response = await http.post(
        Uri.parse("https://api.nstack.in/v1/todos"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      showSnackBarSuccess("Creation Success");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      showSnackBarFail("Creation Failed");
    }
  }

  Future updateTodo(Map todo) async {
    final body = {
      "title": title.text,
      "description": description.text,
      "is_completed": false
    };

    final id = todo['_id'].toString();

    final response = await http.put(
        Uri.parse("https://api.nstack.in/v1/todos/$id"),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      showSnackBarSuccess("success");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      showSnackBarFail("failed");
    }
  }

  void showSnackBarSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    ));
  }

  void showSnackBarFail(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    ));
  }
}
