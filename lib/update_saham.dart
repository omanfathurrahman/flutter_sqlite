import 'package:flutter/material.dart';
import 'package:sqlite/models/saham.dart';
import 'package:sqlite/sqlite_service.dart';

class UpdateSaham extends StatefulWidget {
  const UpdateSaham({super.key, required this.saham, required this.onPressed});
  final Saham saham;

  final void Function() onPressed;

  @override
  State<UpdateSaham> createState() => _UpdateSahamState();
}

class _UpdateSahamState extends State<UpdateSaham> {
  late final DatabaseHandler handler;

  late final tickerSementara = widget.saham.ticker.toString();

  final TextEditingController tickerController = TextEditingController();
  final TextEditingController openController = TextEditingController();
  final TextEditingController highController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController changeController = TextEditingController();

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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tickerController.text = widget.saham.ticker;
    openController.text = widget.saham.open.toString();
    highController.text = widget.saham.high.toString();
    lastController.text = widget.saham.last.toString();
    changeController.text = widget.saham.change;
  }

  void editData() {
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await editSaham();
      setState(() {});
    });
  }

  Future<int> editSaham() async {
    Saham sahamDiEdit = Saham(
      ticker: tickerController.text,
      open: int.parse(openController.text),
      high: int.parse(highController.text),
      last: int.parse(lastController.text),
      change: changeController.text,
    );

    return await handler.updateSaham(sahamDiEdit);
    // print(sahamDiEdit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit data saham : ${widget.saham.ticker}'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 6.0),
              child: TextFormField(
                controller: tickerController,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: TextFormField(
                controller: openController,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: TextFormField(
                controller: highController,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: TextFormField(
                controller: lastController,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 12.0),
              child: TextFormField(
                controller: changeController,
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.normal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text('Processing Data')),
                    // );
                    editData();
                    widget.onPressed;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data saham berhasil diupdate')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
      //bottomNavigationBar:  BottomNavigationMenu(),
    );
  }
}
