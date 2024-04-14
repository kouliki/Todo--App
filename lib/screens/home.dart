import 'package:flutter/material.dart';
import 'package:todo_app/Colors/colors.dart';
import 'package:todo_app/widgets/ToDoItem.dart';
import 'package:todo_app/model/todo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final todosList = Todo.todoList(); /// list of todo items
  List<Todo>_foundTodo = [];         /// for searching purpose
  final _todoController = TextEditingController();  // below dropdown text add

  @override
  void initState() {  /// user will search over here
    // TODO: implement initState
    _foundTodo=todosList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppbar(),
      body: Stack(
        children: [Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBar(),
                Expanded( // all
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 50, bottom: 20),
                        child: const Text('All ToDos',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight
                              .w500),),

                      ),
                      for(Todo todoo in _foundTodo.reversed )  // reversed is basically used to put the addition of item at  the top of the list
    //print('Type of todoo: ${todoo.runtimeType}');
                        ToDoItem(todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteTodoItem,
                        ),

                    ],
                  ),
                )
              ],
            )
        ),
          Align(
            alignment: Alignment.bottomCenter,

            /// bottom box //
            child: Row(children: [
              Expanded(
                child: Container(margin: const EdgeInsets.only(bottom: 20,
                    right: 20,
                    left: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        // error of boxShadow is removed with square brackets//
                        spreadRadius: 0.0,
                      ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: const InputDecoration(
                        hintText: 'Add a new Todo Item',
                        border: InputBorder.none,


                      ),
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20
                    , right: 20),
                child: ElevatedButton(
                  child: const Text('+', style: TextStyle(fontSize: 40,),),
                  onPressed: () {
                    _addTodoItem(_todoController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: const Size(60, 60),
                    elevation: 10,
                  ),
                ),


              )

            ],
            ),
          )
        ],
      ),
    );
  }

  void _handleToDoChange(Todo todo) {
    setState(() {
      // Update the state of the todo item
      todo.isDone = !todo.isDone;
    });
  }

  void _deleteTodoItem(String id){
    setState(() {
      todosList.removeWhere((item) => item.id == id);
    });

  }

  void _addTodoItem(String todo)
  {
    setState(() {
      todosList.add(Todo(id: DateTime.now().millisecondsSinceEpoch.toString(), todoText: todo));

    });
    _todoController.clear();
  }

  void _runfilter(String enteredKEyword)
  {
    List<Todo> results = [];
    if( enteredKEyword.isEmpty)
      {
        results=todosList;
      }
    else
      {
        results = todosList.where((item) => item.todoText!.toLowerCase().contains(enteredKEyword.toLowerCase())).toList();
      }
    setState(() {
      _foundTodo=results;
    });
  }




//////////////////// Search Bar /////////////////////////////////

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child:  TextField(
        onChanged: (value) => _runfilter(value),
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(Icons.search,
              color: tdBlack,
              size: 20),
          prefixIconConstraints: BoxConstraints( // prefixConstraints basically changes in prefix icon
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),

        ),
      ),

    );
  }

////////////////// Appbar //////////////////////////

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          const Icon(
            Icons.menu,
            color: tdBlack,
            size: 30,

          ),
          Container(
            height: 40,
            width: 40,
            child: ClipRect(
              child: Image.asset('images/icon.jpeg'),
            ),
          )


        ],),
    );
  }
}
