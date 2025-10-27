import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:its_aa_pn_2025_cross_platform/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const MyHomePage(title: 'TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _list = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _list.clear();
              });
            },
            label: const Text('Reset All'),
          ),
          SizedBox(width: 8),
          ElevatedButton.icon(
            icon: Icon(Icons.invert_colors),
            onPressed: () {
              setState(() {
                for (var i = 0; i < _list.length; i++) {
                  _list[i].isDone = !_list[i].isDone;
                }
              });
            },
            label: const Text('Invert All'),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            if (_list.isEmpty) //
              Text("non c'è niente"),
            for (final (i, todo) in _list.indexed)
              CheckboxListTile(
                value: todo.isDone,
                title: Text(todo.title),
                subtitle: Text(todo.description),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _list[i].isDone = value;
                  });
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTodo,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _createTodo() async {
    final result = await showDialog<Todo>(
      context: context,
      builder: (context) {
        return AddTodoFormDialog();
      },
    );

    if (result == null) return; // significa che il dialog è stato annullato

    setState(() {
      _list.add(result);
    });
  }
}

class AddTodoFormDialog extends StatefulWidget {
  const AddTodoFormDialog({super.key});

  @override
  State<AddTodoFormDialog> createState() => _AddTodoFormDialogState();
}

class _AddTodoFormDialogState extends State<AddTodoFormDialog> {
  final _key = GlobalKey<FormState>();

  String? _title;
  String? _description;
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("nuovo todo!", style: theme.textTheme.headlineSmall),
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(hintText: "titolo..."),
                validator: (value) {
                  if (value == null) return "campo obbligatorio!";
                  if (value.isEmpty) return "campo obbligatorio!";
                  if (value.length < 3) return "inserisci almeno 3 caratteri";
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "descrizione..."),
                validator: (value) {
                  if (value == null) return "campo obbligatorio";
                  if (value.isEmpty) return "campo obbligatorio!";
                  if (value.length < 20) return "inserisci almeno 20 caratteri";
                  return null;
                },
                onChanged: (value) {
                  _description = value;
                },
              ),
              SizedBox(height: 20),
              FormField<bool>(
                initialValue: false,
                validator: (value) {
                  if (value == true) return null;
                  return "devi accettare i termini e condizioni";
                },
                errorBuilder: (context, errorText) {
                  print(errorText);
                  return Text(errorText);
                },
                builder: (field) {
                  return CheckboxListTile(
                    value: field.value,
                    contentPadding: EdgeInsets.zero,
                    title: Text("accetto i t&c"),
                    onChanged: (value) {
                      if (value == null) return;
                      field.didChange(value);
                      _isDone = value;
                    },
                  );
                },
              ),
              SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  final state = _key.currentState?.validate();
                  if (state == true) {
                    // è valido!
                    final todo = Todo(
                      createdAt: DateTime.now(),
                      title: _title!,
                      description: _description!,
                      isDone: _isDone,
                    );

                    Navigator.pop(context, todo);
                  }
                  if (_title == null) return;
                  if (_title!.isEmpty) return;
                  if (_title!.length < 3) return;

                  if (_description == null) return;
                  if (_description!.isEmpty) return;
                  if (_description!.length < 20) return;
                },
                child: Text("salva!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
