import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdb_challenge/borrar/prueba_riverpod_provider.dart';

//onPressed: () => context.goNamed('prueba'),

class PruebaRiverpodPage extends ConsumerWidget {
  const PruebaRiverpodPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    //final completedTodos = ref.watch(completedTodosProvider);
    final todosState = ref.watch(todosProvider);
    final todosController = ref.read(todosProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todosController.value++;
          todosController.addTodo(Todo(todosController.value.toString(), false));
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Center(
              child: Text(
                'TODOS',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 50),
            ListView.builder(
              itemCount: todosState.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                  child: Text(
                    todosState[index].description,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
