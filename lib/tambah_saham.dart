import 'package:flutter/material.dart';
import 'package:sqlite/models/saham.dart';
import 'package:sqlite/sqlite_service.dart';

class TambahSaham extends StatefulWidget {
  const TambahSaham({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  State<TambahSaham> createState() => _TambahSahamState();
}

class _TambahSahamState extends State<TambahSaham> {
  late DatabaseHandler handler;

  final _formKey = GlobalKey<FormState>();

  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final tickerController = TextEditingController();
  final openController = TextEditingController();
  final highController = TextEditingController();
  final lastController = TextEditingController();
  final changeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    tickerController.dispose();
    openController.dispose();
    highController.dispose();
    lastController.dispose();
    changeController.dispose();
    super.dispose();
  }

  void tambahSaham() {
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await addSaham();
      setState(() {});
    });
  }

  Future<int> addSaham() async {
    List<Saham> listSaham = [
      Saham(
          ticker: tickerController.text,
          open: int.parse(openController.text),
          high: int.parse(highController.text),
          last: int.parse(lastController.text),
          change: changeController.text),
    ];

    return await handler.insertSaham(listSaham);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Saham'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Ticker"),
              TextFormField(
                controller: tickerController,
                decoration: const InputDecoration(
                  hintText: 'Ticker',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("Open"),
              TextFormField(
                controller: openController,
                decoration: const InputDecoration(
                  hintText: 'Open',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("High"),
              TextFormField(
                controller: highController,
                decoration: const InputDecoration(
                  hintText: 'High',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("Last"),
              TextFormField(
                controller: lastController,
                decoration: const InputDecoration(
                  hintText: 'Last',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (int.tryParse(value) == null) {
                    return 'Please enter a number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text("Change"),
              TextFormField(
                controller: changeController,
                decoration: const InputDecoration(
                  hintText: 'Change',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else
                    return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    tambahSaham();
                    widget.onPressed();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data saham berhasil disimpan')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
