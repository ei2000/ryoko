import 'package:flutter/material.dart';
import 'package:my_app/serch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = TextEditingController();
  List results = [];
  bool loading = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _doSearch() async {
    setState(() => loading = true);
    try {
      final data = await searchTavily(controller.text);
      setState(() {
        results = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('検索エラー: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 300),
          child: Column(
            children: [
              const Text('検索したいことを記入してください'),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ここに入力',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _doSearch, child: const Text('検索する')),
              const SizedBox(height: 16),
              if (loading) const CircularProgressIndicator(),
              if (!loading)
                Expanded(
                  child: ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return ListTile(
                        title: Text(item['title'] ?? 'No title'),
                        subtitle: Text(item['url'] ?? ''),
                        onTap: () {},
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
