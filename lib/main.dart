import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudweb/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter CRUD WEB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jenkelController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _laporanController = TextEditingController();
  final TextEditingController _statusNikahController = TextEditingController();

  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('laporan');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan'),
      ),
      drawer: Drawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _jenkelController,
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _noHpController,
                  decoration: InputDecoration(
                    labelText: 'No HP',
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _laporanController,
                  decoration: InputDecoration(
                    labelText: 'Laporan',
                  ))),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: _statusNikahController,
                  decoration: InputDecoration(
                    labelText: 'Status Nikah',
                  ))),
          StreamBuilder<QuerySnapshot>(
            stream: _todosCollection.snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('Nama'),
                        ),
                        DataColumn(
                          label: Text('Jenis Kelamin'),
                        ),
                        DataColumn(
                          label: Text('Alamat'),
                        ),
                        DataColumn(
                          label: Text('No HP'),
                        ),
                        DataColumn(
                          label: Text('Laporan'),
                        ),
                        DataColumn(
                          label: Text('Status Nikah'),
                        ),
                        DataColumn(
                          label: Text('Status'),
                        ),
                        DataColumn(
                          label: Text('Delete'),
                        ),
                        DataColumn(
                          label: Text('Edit'),
                        ),
                      ],
                      rows: documents.map((doc) => _buildDataRow(doc)).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_namaController.text.isEmpty ||
              _jenkelController.text.isEmpty ||
              _alamatController.text.isEmpty ||
              _noHpController.text.isEmpty ||
              _laporanController.text.isEmpty ||
              _statusNikahController.text.isEmpty) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Alert'),
                  content: Text('Tolong Diisi'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            return;
          }

          _todosCollection.add({
            'nama': _namaController.text.isEmpty
                ? 'Belum Diisi'
                : _namaController.text,
            'status': false,
            'alamat': _alamatController.text.isEmpty
                ? 'Belum Diisi'
                : _alamatController.text,
            'laporan': _laporanController.text.isEmpty
                ? 'Belum Diisi'
                : _laporanController.text,
            'no_hp': _noHpController.text.isEmpty
                ? 'Belum Diisi'
                : _noHpController.text,
            'jenkel': _jenkelController.text.isEmpty
                ? 'Belum Diisi'
                : _jenkelController.text,
            'status_nikah': _statusNikahController.text.isEmpty
                ? 'Belum Diisi'
                : _statusNikahController.text,
            'created_at': DateTime.now(),
          });
          _namaController.text = '';
          _alamatController.text = '';
          _noHpController.text = '';
          _laporanController.text = '';
          _jenkelController.text = '';
          _statusNikahController.text = '';
        },
        child: Icon(Icons.add),
      ),
    );
  }

  DataRow _buildDataRow(DocumentSnapshot doc) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(doc['nama'] == null ? 'Belum Diisi' : doc['nama'])),
        DataCell(Text(doc['jenkel'] ?? 'Belum Diisi')),
        DataCell(Text(doc['alamat'] ?? 'Belum Diisi')),
        DataCell(Text(doc['no_hp'] ?? 'Belum Diisi')),
        DataCell(Text(doc['laporan'] ?? 'Belum Diisi')),
        DataCell(Text(doc['status_nikah'] ?? 'Belum Diisi')),
        DataCell(DropdownButton<bool>(
          value: doc['status'],
          items: <DropdownMenuItem<bool>>[
            DropdownMenuItem<bool>(
              value: true,
              child: Text('Done'),
            ),
            DropdownMenuItem<bool>(
              value: false,
              child: Text('Not Done'),
            ),
          ],
          onChanged: (bool? newValue) {
            doc.reference.update({'status': newValue});
          },
        )),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              doc.reference.delete();
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              final namaController = TextEditingController(text: doc['nama']);
              final alamatController =
                  TextEditingController(text: doc['alamat']);
              final noHpController = TextEditingController(text: doc['no_hp']);
              final laporanController =
                  TextEditingController(text: doc['laporan']);
              final jenkelController =
                  TextEditingController(text: doc['jenkel']);
              final statusNikahController =
                  TextEditingController(text: doc['status_nikah']);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Edit Document'),
                    content: Column(
                      children: <Widget>[
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                          ),
                        ),
                        TextField(
                          controller: alamatController,
                          decoration: InputDecoration(
                            labelText: 'Alamat',
                          ),
                        ),
                        TextField(
                          controller: noHpController,
                          decoration: InputDecoration(
                            labelText: 'No HP',
                          ),
                        ),
                        TextField(
                          controller: laporanController,
                          decoration: InputDecoration(
                            labelText: 'Laporan',
                          ),
                        ),
                        TextField(
                          controller: jenkelController,
                          decoration: InputDecoration(
                            labelText: 'Jenis Kelamin',
                          ),
                        ),
                        TextField(
                          controller: statusNikahController,
                          decoration: InputDecoration(
                            labelText: 'Status Nikah',
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          doc.reference.update({
                            'nama': _namaController.text,
                            'alamat': _alamatController.text,
                            'no_hp': _noHpController.text,
                            'laporan': _laporanController.text,
                            'jenkel': _jenkelController.text,
                            'status_nikah': _statusNikahController.text,
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
