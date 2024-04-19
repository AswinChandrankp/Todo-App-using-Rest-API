

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchtodo();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        elevation: 1,
        title: Center(child: Text("Todo app")),
      ),

      body: Visibility(
        visible: isloading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchtodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No items found")),
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: items.length,
              itemBuilder: (context, index) {
               final item = items[index] as Map;
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
                        deletebyid(id);
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
              );
            }),
          ),
        ),
      ),

      floatingActionButton:FloatingActionButton.extended(onPressed: navigateTodoaddpage,label: Text("ADD LEAD") ,) ,
    );
  }

  Future<void> navigateTodoaddpage() async {
    final Route = MaterialPageRoute(builder: (context) => Add_todo());
    await Navigator.push(context, Route);
    setState(() {
      isloading = false;
    });
    fetchtodo();
  }

   Future <void> navigateTodoeditpage( Map item) async {
    final Route = MaterialPageRoute(builder: (context) => Add_todo( todo: item,));
   await  Navigator.push(context, Route);
   setState(() {
     isloading = false;
   });
   fetchtodo();
  }


Future <void> deletebyid(String id) async {

  // delete the item by id
  final url = "http://api.nstack.in/v1/todos/$id";
  final uri = Uri.parse(url);
  final response = await http.delete(uri);
  if(response.statusCode == 200){

    print("deleted successfully");
    // remove from list
    final filterd = items.where((element) => element["_id"] != id).toList();
    setState(() {
      items = filterd;
    });
  } else {
    print("Failed to delete");
   
    
  }
}




  Future <void> fetchtodo() async {

    setState(() {
      isloading = true;
    });

    final url = "http://api.nstack.in/v1/todos?page=1";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final data = json["items"] as List;
      print(response.statusCode);

      setState(() {
        items = data;
        isloading = false;
        
      });
    }

  //  setState(() {
  //    isloading = false;
  //  });
    
  }
}
