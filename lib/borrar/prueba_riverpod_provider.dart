import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  Todo(this.description, this.isCompleted);
  final bool isCompleted;
  final String description;
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  int value = 0;

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(Todo todo) {
    state.remove(todo);
  }
}

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // Obtenemos la lista de tareas (todos) del `todosProvider`
  final todos = ref.watch(todosProvider);

  // Devolvemos solo los `todos` completados
  return todos;
});
