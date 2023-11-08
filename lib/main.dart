import 'package:flutter/material.dart';
import 'package:sqlite/tambah_saham.dart';
import 'package:sqlite/update_saham.dart';
import 'sqlite_service.dart';
import 'package:sqlite/models/saham.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saham',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Saham'),
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
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();

    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      await addSaham();
      setState(() {});
    });
  }

  Future<int> addSaham() async {
    List<Saham> listOfUsers = [
      Saham(ticker: "TLKM", open: 3380, high: 3500, last: 3490, change: "2,05"),
      Saham(ticker: "AMMN", open: 6750, high: 6750, last: 6500, change: "-3,7"),
      Saham(ticker: "BREN", open: 4500, high: 4610, last: 4580, change: "1,78"),
      Saham(ticker: "CUAN", open: 5200, high: 5525, last: 5400, change: "3,85"),
    ];

    return await handler.insertSaham(listOfUsers);
  }

  void loadUlang() {
    print('tes');
    setState(() {});
  }

  bool cekChange(String change) {
    change = change.replaceAll(",", ".");
    double changeDouble = double.parse(change);

    if (changeDouble > 0) {
      return true;
    } else {
      return false;
    }
  }

  void editData(Saham sahamEdit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UpdateSaham(saham: sahamEdit, onPressed: loadUlang),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: handler.retrieveSaham(),
        builder: (BuildContext context, AsyncSnapshot<List<Saham>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].tickerid!),
                  child: Card(
                    child: ListTile(
                        onTap: () => editData(snapshot.data![index]),
                        contentPadding: const EdgeInsets.all(8.0),
                        title: Text(snapshot.data![index].ticker,
                            style: TextStyle(
                                color: cekChange(snapshot.data![index].change)
                                    ? Colors.green
                                    : Colors.red)),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Open: "),
                                Text(snapshot.data![index].open.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("High: "),
                                Text(snapshot.data![index].high.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Last: "),
                                Text(snapshot.data![index].last.toString()),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Change: "),
                                Text(snapshot.data![index].change),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TambahSaham(onPressed: loadUlang)),
          );
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
