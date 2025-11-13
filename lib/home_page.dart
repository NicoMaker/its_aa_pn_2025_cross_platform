import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("esercitazioni di gruppo - correzioni"),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: 40,
          vertical: 16,
        ),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            Card(
              margin: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () async {
                  await context.push("/counter");
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Center(
                    child: Text("Esercitazione 1.1"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
