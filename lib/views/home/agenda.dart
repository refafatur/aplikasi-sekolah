import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  Future<List<dynamic>> fetchAgenda() async {
    final response = await http.get(Uri.parse('https://hayy.my.id/API-Refa/agenda.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load agenda data');
    }
  }

  Future<void> addAgenda(String judul, String isi, DateTime tgl, String status, String petugas) async {
    final response = await http.post(
      Uri.parse('https://hayy.my.id/API-Refa/agenda.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'judul_agenda': judul,
        'isi_agenda': isi,
        'tgl_agenda': tgl.toIso8601String(),
        'status_agenda': status,
        'kd_petugas': petugas,
        'tgl_post_agenda': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add agenda');
    }
  }

  Future<void> editAgenda(String id, String judul, String isi, DateTime tgl, String status, String petugas) async {
    final response = await http.put(
      Uri.parse('https://hayy.my.id/API-Refa/agenda.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'kd_agenda': id,
        'judul_agenda': judul,
        'isi_agenda': isi,
        'tgl_agenda': tgl.toIso8601String(),
        'status_agenda': status,
        'kd_petugas': petugas,
        'tgl_post_agenda': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit agenda');
    }
  }

  Future<void> deleteAgenda(String id) async {
    final response = await http.delete(
      Uri.parse('https://hayy.my.id/API-Refa/agenda.php?kd_agenda=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete agenda');
    }
  }

  DateTime? selectedFilterDate; // Variable to hold the selected filter date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Display selected date
                      Expanded(
                        child: Text(
                          selectedFilterDate == null
                              ? 'Pilih Tanggal Agenda'
                              : 'Tanggal Agenda: ${selectedFilterDate!.toLocal()}'.split(' ')[0],
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Button to pick date
                      TextButton.icon(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              selectedFilterDate = pickedDate;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: const Text('Pilih Tanggal'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Agenda List
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchAgenda(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Apply filter if a date is selected
                  List<dynamic> agendasToDisplay = snapshot.data!;
                  if (selectedFilterDate != null) {
                    agendasToDisplay = agendasToDisplay.where((agenda) {
                      DateTime agendaDate = DateTime.parse(agenda['tgl_agenda']);
                      return agendaDate.year == selectedFilterDate!.year &&
                          agendaDate.month == selectedFilterDate!.month &&
                          agendaDate.day == selectedFilterDate!.day;
                    }).toList();
                  }

                  if (agendasToDisplay.isEmpty) {
                    return const Center(child: Text('Tidak ada agenda tersedia saat ini'));
                  }

                  return ListView.builder(
                    itemCount: agendasToDisplay.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      var agenda = agendasToDisplay[index];

                      return Dismissible(
                        key: Key(agenda['kd_agenda']),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text('Apakah Anda yakin ingin menghapus agenda ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Ya'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) async {
                          await deleteAgenda(agenda['kd_agenda']);
                          setState(() {});
                        },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.event,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        agenda['judul_agenda'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  agenda['isi_agenda'],
                                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tanggal: ${agenda['tgl_agenda']}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    ),
                                    Text(
                                      'Status: ${agenda['status_agenda']}',
                                      style: TextStyle(
                                          color: agenda['status_agenda'] == 'Berjalan' ? Colors.green : Colors.red,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditAgendaScreen(
                                              editAgenda: editAgenda,
                                              data: agenda,
                                            ),
                                          ),
                                        ).then((_) {
                                          setState(() {});
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahAgendaScreen(addAgenda: addAgenda),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TambahAgendaScreen extends StatelessWidget {
  final Future<void> Function(String, String, DateTime, String, String) addAgenda;

  const TambahAgendaScreen({super.key, required this.addAgenda});

  @override
  Widget build(BuildContext context) {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController isiController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    final TextEditingController petugasController = TextEditingController();
    DateTime? selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Agenda', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Agenda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: isiController,
                decoration: InputDecoration(
                  labelText: 'Isi Agenda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                  labelText: 'Status Agenda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: petugasController,
                decoration: InputDecoration(
                  labelText: 'Petugas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(selectedDate == null ? 'Pilih Tanggal Agenda' : 'Tanggal Agenda: ${selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDate != null) {
                    await addAgenda(
                      judulController.text,
                      isiController.text,
                      selectedDate!,
                      statusController.text,
                      petugasController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agenda berhasil ditambahkan')));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih tanggal')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Tambah Agenda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditAgendaScreen extends StatelessWidget {
  final Future<void> Function(String, String, String, DateTime, String, String) editAgenda;
  final Map<String, dynamic> data;

  const EditAgendaScreen({super.key, required this.editAgenda, required this.data});

  @override
  Widget build(BuildContext context) {
    final TextEditingController judulController = TextEditingController(text: data['judul_agenda']);
    final TextEditingController isiController = TextEditingController(text: data['isi_agenda']);
    final TextEditingController statusController = TextEditingController(text: data['status_agenda']);
    final TextEditingController petugasController = TextEditingController(text: data['kd_petugas']);
    DateTime? selectedDate = DateTime.parse(data['tgl_agenda']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Agenda', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Agenda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: isiController,
                decoration: InputDecoration(
                  labelText: 'Isi Agenda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: statusController,
                decoration: InputDecoration(
                  labelText: 'Status Agenda',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: petugasController,
                decoration: InputDecoration(
                  labelText: 'Petugas',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(selectedDate == null ? 'Pilih Tanggal Agenda' : 'Tanggal Agenda: ${selectedDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != selectedDate) {
                    selectedDate = picked;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDate != null) {
                    await editAgenda(
                      data['kd_agenda'],
                      judulController.text,
                      isiController.text,
                      selectedDate!,
                      statusController.text,
                      petugasController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agenda berhasil diubah')));
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih tanggal')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Edit Agenda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
