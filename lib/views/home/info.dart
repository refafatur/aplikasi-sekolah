import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<dynamic> infoList = [];
  List<dynamic> filteredInfoList = [];
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    final response =
        await http.get(Uri.parse('https://hayy.my.id/API-Refa/info.php'));
    if (response.statusCode == 200) {
      setState(() {
        infoList = json.decode(response.body);
        filteredInfoList = infoList;
      });
    } else {
      throw Exception('Gagal memuat data informasi');
    }
  }

  void _searchInfo(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredInfoList = infoList;
      } else {
        filteredInfoList = infoList
            .where((info) =>
                info['judul_info'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> addInfo() async {
    final response = await http.post(
      Uri.parse('https://hayy.my.id/API-Refa/info.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'judul_info': _judulController.text,
        'isi_info': _isiController.text,
        'tgl_post_info': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      fetchInfo();
      _judulController.clear();
      _isiController.clear();
    } else {
      throw Exception('Gagal menambahkan informasi');
    }
  }

  void _showAddInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Informasi Baru'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _judulController,
                  decoration: const InputDecoration(hintText: "Judul Informasi"),
                ),
                TextField(
                  controller: _isiController,
                  decoration: const InputDecoration(hintText: "Isi Informasi"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Tambah'),
              onPressed: () {
                addInfo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Cari informasi...",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.blue),
                    onPressed: () {
                      _searchController.clear();
                      _searchInfo('');
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: _searchInfo,
              ),
            ),
            Expanded(
              child: filteredInfoList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredInfoList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade100, Colors.white],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              expandedCrossAxisAlignment:
                                  CrossAxisAlignment.start,
                              childrenPadding: const EdgeInsets.all(20),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade300,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade100,
                                      blurRadius: 5,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.info_outline,
                                    color: Colors.white, size: 30),
                              ),
                              title: Text(
                                filteredInfoList[index]['judul_info'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Diposting pada: ${filteredInfoList[index]['tgl_post_info']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blue.shade600),
                                    onPressed: () {
                                      // Logika edit info dapat ditambahkan di sini
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.red.shade400),
                                    onPressed: () {
                                      // Logika hapus info dapat ditambahkan di sini
                                    },
                                  ),
                                ],
                              ),
                              children: [
                                Divider(
                                    color: Colors.blue.shade200,
                                    thickness: 1.5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Text(
                                    filteredInfoList[index]['isi_info'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[800],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInfoDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
