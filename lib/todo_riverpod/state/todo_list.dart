import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:its_aa_pn_2025_cross_platform/todo_riverpod/models/todo.dart";

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(String title, String description) {
    final todo = Todo(
      title: title,
      description: description,
    );
    state.add(todo);
    ref.notifyListeners();
  }
}
