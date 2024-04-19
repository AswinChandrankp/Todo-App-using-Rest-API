

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_todo.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/services/todo_services.dart';
import 'package:todo_app/utils/snakbarhelper.dart';
import 'package:todo_app/widgets/todo_card.dart';


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
              //  final id = item["_id"] as String;
              return  TodoCard(index: index, item: item, navigateTodoeditpage: navigateTodoeditpage, deleteByid: deletebyid,);
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
 final iSsuccess = await todoservices.deleteByid(id);
  if(iSsuccess){

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

   
    final response = await todoservices.fetchtodos();
    if(response != Null){
      
      setState(() {
        items = response!;
        isloading = false;
        
      });
    } else {
      showerrorMessage(context, message: "Something went wrong");
    }

   setState(() {
     isloading = false;
   });
    
  }

   
}
