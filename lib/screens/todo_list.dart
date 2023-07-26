import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/screens/todo_services.dart';
import 'package:todoapp/util/snackbar_helper.dart';
import 'package:todoapp/widgets/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo App '),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child: Text("No Todo Item",style: Theme.of(context).textTheme.headlineMedium,),),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return TodoCard(
                   index: index,
                   item: item, 
                   navigateEdit: navigateToEditPage, 
                   deleteById: deleteById
                   );
                 /*  return Card(
                    child: ListTile(
                      // title: Text('Sample Text'),
                      // title: Text(item.toString()),
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(item['title']),
                      subtitle: Text(item['description']),
                      trailing: PopupMenuButton(onSelected: (value) {
                        if (value == 'edit') {
                          //  Open edit page
                          navigateToEditPage(item);
                        } else if (value == 'delete') {
                          // Delete and remove the item
                          deleteById(id);
                        }
                      }, itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text('Edit'),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text('Delete'),
                            value: 'delete',
                          )
                        ];
                      }),
                    ),
                  ); */
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
         shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onPressed: navigateToPage,
          // tooltip: 'Add Todo', 
          label: Text('Add Todo'),
          //  child: Text('Add Todo')
           ),
    );
  }
 Future <void> navigateToEditPage(Map item)async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage(todo:item));
     await Navigator.push(context, route);
      setState(() {
     isLoading=true;
   });
   fetchTodo();
  }

 Future<void>navigateToPage()async {
    final route = MaterialPageRoute(builder: (context) => AddTodoPage());
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
   fetchTodo();
  }

  Future<void> deleteById(String id) async {
// Delete the item
/* final url='https://api.nstack.in/v1/todos/$id';
final uri=Uri.parse(url); 
final response = await http.delete(uri);*/
final isSuccess = await TodoService.deleteById(id);
// if(response.statusCode==200){
if(isSuccess){
  // Remove the item from the list
final filtereditem=items.where((element) => element['_id']!=id).toList();
setState(() {
  items=filtereditem;
});
showSuccessMessage("Successfully Deleted...");
}else{
  // Show error
  showErrorMessage(context,message: "Deletion Failed...");
}

  }

  Future<void> fetchTodo() async {
  
   /*  final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri); */
    final response=await TodoService.fetchTodos();
    // if (response.statusCode == 200) {  
    if (response!=null) {  
      /* final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List; */
      setState(() {
        // items = result;
        items = response;
      });
      //  print(response.statusCode);
      //   print(response.body);
    } else {
      // Show error 
      showErrorMessage(context,message:"Something went wrong...");
    }
    setState(() {
      isLoading = false;
    });
  }

    void showSuccessMessage(String message){
    final snackbar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
/*   void showErrorMessage(String message){
    final snackbar = SnackBar(
      content: Text(message,
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
      );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } */
}
