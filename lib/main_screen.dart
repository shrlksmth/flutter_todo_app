import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/add_todo.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainPageState();
}

class _MainPageState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder(
              future: getTodo(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data;
                  return ListView.builder(
                      itemCount: data['items'].length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading: CircleAvatar(
                              child: Text("${index + 1}"),
                            ),
                            title: Text("${data['items'][index]['title']}"),
                            subtitle: Text(data['items'][index]['description']),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: Text("Edit"),
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => AddTodo(
                                                  isEdit: true,
                                                  todo: data['items'][index])));
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    onTap: () {
                                      deleteTodo(data['items'][index]['_id']);
                                    },
                                  ),
                                ];
                              },
                            ));
                      });
                }
                return CircularProgressIndicator();
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddTodo(
                      isEdit: false,
                      todo: {},
                    )));
          },
          label: Text("Add Todo"),
        ));
  }

  Future getTodo() async {
    final response = await http
        .get(Uri.parse('https://api.nstack.in/v1/todos?page=1&limit=10'));

    final body = jsonDecode(response.body);

    return body;
  }

  Future deleteTodo(String id) async {
    final response =
        await http.delete(Uri.parse('https://api.nstack.in/v1/todos/$id'));

    showSnackBarSuccess("Success");

    setState(() {});
  }

  void showSnackBarSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    ));
  }
}
