import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/screens/todo_services.dart';
import 'package:todoapp/util/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key,this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  bool isEdit = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
  /*   if(widget.todo!=null){
      isEdit=true;
    } */
    final todo =widget.todo;
    if(todo!=null){
     isEdit=true;
     final title=todo['title'];
     final description=todo['description'];
     titleController.text=title;
     descriptionController.text=description;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isEdit?Text('Edit Todo'):   Text('Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed:isEdit?updateData:  submitData, 
            child: Text( isEdit?'Update': 'Submit'))
        ],
      ),
    );
  }
Future<void> updateData()async{
  final todo=widget.todo;
  if(todo==null){
    print("You can not call updated without todo data");
    return;
  }
  final id=todo['_id'];
  /* final isCompleted=todo['is_completed'];
  final title = titleController.text;
    final descrption = descriptionController.text;
    final body = {
      "title": title,
      "description": descrption,
      "is_completed": isCompleted,
    }; */
    // Submit updated data to the server 
    /* final url = "https://api.nstack.in/v1/todos/$id";
    final uri =Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: { 
        'Content-Type': 'application/json'
       }); */
       final isSuccess=await TodoService.updateTodo(id, body); 
      //  if(response.statusCode==200){
       if(isSuccess){

      titleController.text = '';
      descriptionController.text = '';
      //  print(response.body);
      //  print("Creation Success");
       showSuccessMessage(context,message: 'Updation Success....');
    }else{
      // print("error failed");
      showErrorMessage(context,message: "Updation Failed");
      //  print(response.statusCode);
    }
  

}



  Future<void> submitData() async{
    // Get the data from form
   /*  final title = titleController.text;
    final descrption = descriptionController.text;
    final body = {
      "title": title,
      "description": descrption,
      "is_completed": false,
    }; */
  /*   final url = "https://api.nstack.in/v1/todos";
    final uri =Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json'
       }
         ); */
    // Submit data to the server 
    final isSuccess=await TodoService.addTodo(body);
    // Show success or fail message based on status
    // if(response.statusCode==201){
    if(isSuccess){

      titleController.text = '';
      descriptionController.text = '';
      //  print(response.body);
      //  print("Creation Success");
       showSuccessMessage(context,message: 'Creation Success....');
    }else{
      // print("error failed");
      showErrorMessage(context,message:"Creation Failed");
      //  print(response.statusCode);
    }
  
    // print(response.body);
  }
/*   void showSuccessMessage(String message){
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  void showErrorMessage(String message){
    final snackbar = SnackBar(
      content: Text(message,
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
      );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } */
  Map get body{
       final title = titleController.text;
    final descrption = descriptionController.text;
 return{
      "title": title,
      "description": descrption,  
      "is_completed": false,
    };
  }
}
