import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> _todos = [];
  final _controller = TextEditingController();
  final _uuid = Uuid();

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'todos',
      jsonEncode(_todos.map((todo) => todo.toJson()).toList()),
    );
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString('todos');
    if (todosString != null) {
      final jsonList = jsonDecode(todosString) as List<dynamic>;
      setState(() {
        _todos = jsonList
            .map((json) => Todo.fromJson(json as Map<String, dynamic>))
            .toList();
      });
    }
  }

  void _showAddDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Todo'),
        content: TextField(
          controller: _controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _todos.add(
                  Todo(
                    id: _uuid.v4(),
                    text: _controller.text,
                  ),
                );
              });
              saveTodos();
              Navigator.of(context).pop();
              _controller.clear();
            },
            child: const Text('Add Todo'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            key: ValueKey(todo.id),
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (value) {
                setState(() {
                  _todos[index] = todo.copyWith(isDone: value ?? false);
                });
              },
            ),
            title: Text(todo.text),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
