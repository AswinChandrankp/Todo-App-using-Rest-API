import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateTodoeditpage;
  final Function(String) deleteByid;
  const TodoCard({super.key, required this.index, required this.item, required this.navigateTodoeditpage, required this.deleteByid});

  @override
  Widget build(BuildContext context) {
     final id = item["_id"] as String;
    return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index+1}")),
                  title: Text(item["title"]),
                  subtitle: Text(item["description"]),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == "Edit") {
                        // edit todo page
                        navigateTodoeditpage(item);
                      }
                      else if (value == "delete") {
                        deleteByid(id);
                      }
                    },
                    itemBuilder: (context){
                    return [
                      PopupMenuItem(child: Text("Edit"),
                      value: "Edit",
                      ),
                       PopupMenuItem(child: Text("delete"),
                       value: "delete",),
                    ];
                  }),
                ),
              );;
  }
}