import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Add_todo extends StatefulWidget {
  final Map? todo;
  const Add_todo({super.key,  this.todo});

  @override
  State<Add_todo> createState() => _Add_todoState();
}

class _Add_todoState extends State<Add_todo> {


  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  bool isedit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo = widget.todo;
    if (todo !=null) {
      isedit = true;
      final title = todo!["title"];
      final description = todo!["description"];
      titlecontroller.text = title;
      descriptioncontroller.text = description;

    }else{
      isedit = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
         elevation: 1,
         title: Center(child: Text( isedit ? "Edit Todo" :"Add Todo")),),  
         body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20,),
          TextField(
            controller: titlecontroller,
            decoration: InputDecoration(hintText: "Enter title"),
          ),
          SizedBox(height: 20,),
          TextField( 
            controller: descriptioncontroller,
            decoration: InputDecoration(hintText: "Enter description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: isedit ? Updatedata : submitdata, child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(isedit ? "Update": "Submit"),
          ),style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),)
         ],)
    );
  }

  Future<void> submitdata () async{
  //  get data from form
 final title = titlecontroller.text;
  final description = descriptioncontroller.text;
 final body ={
  "title": title,
  "description": description,
  "is_completed": false
};
  //  send data to server
  
  final url = "http://api.nstack.in/v1/todos";
  final uri = Uri.parse(url);
  final response = await http.post(uri,body: jsonEncode(body),headers: {
  'content-type':'application/json'
  }
   );
  // show success or fail message
   if(response.statusCode == 201){
    titlecontroller.clear();
    descriptioncontroller.clear();
     print("added successfully");
     showSuccesMessage("added successfully");
   } else {
     print( "Failed to add ");
     print(response.statusCode);
     showerrorMessage("Failed to add");
   }
 
   
  }

Future<void> Updatedata() async {
  final todo = widget.todo;
  if (todo == null) {
    print("You can't update without todo data");
    return;
  }
  
  final id = todo["_id"];
  final title = titlecontroller.text;
  final description = descriptioncontroller.text;
  
  final body = {
    "title": title,
    "description": description,
    "is_completed": false
  };

  final url = "http://api.nstack.in/v1/todos/$id";
  final uri = Uri.parse(url);
  
  try {
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print("Updated successfully");
      showSuccesMessage("Updated successfully");
    } else {
      print("Failed to update");
      print(response.statusCode);
      showSuccesMessage("Failed to update");
    }
  } catch (e) {
    print("Error updating todo: $e");
    showSuccesMessage("Error updating todo");
  }
}


//   Future<void> Updatedata () async{
//   //  get data from form
//   final todo = widget.todo;
//   if (todo == null) {
//     print("you cant update without todo data");
//     return;
//   }
//   final id =todo["_id"];
//  final title = titlecontroller.text;
//   final description = descriptioncontroller.text;
//  final body ={
//   "title": title,
//   "description": description,
//   "is_completed": false

// };
//   //  send data to server
  
//   final url = "http://api.nstack.in/v1/todos/$id";
//   final uri = Uri.parse(url);
//   final response = await http.put(uri,body: jsonEncode(body),headers: {
//   'content-type':'application/json'
//   }
//    );
//   // show success or fail message
//    if(response.statusCode == 201){
  
//      print("Updated successfully");
//      showSuccesMessage("updated successfully");
//    } else {
//      print( "Failed to update ");
//      print(response.statusCode);
//      showerrorMessage("Failed to update");
//    }
 
   
//   }


  void showSuccesMessage( String message){
    final snackBar = SnackBar(content: Text(message),
    backgroundColor: Colors.green,);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);{
    
  }
}


 void showerrorMessage( String message){
    final snackBar = SnackBar(content: Text(message),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);{
    
  }
}
}