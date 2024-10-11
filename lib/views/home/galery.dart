import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GaleryScreen extends StatefulWidget {
  const GaleryScreen({super.key});

  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  List<dynamic> _galeryData = [];
  List<dynamic> _filteredGaleryData = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchGalery();
  }

  Future<void> fetchGalery() async {
    final response =
        await http.get(Uri.parse('https://hayy.my.id/API-Refa/galery.php'));
    if (response.statusCode == 200) {
      setState(() {
        _galeryData = json.decode(response.body);
        _filteredGaleryData = _galeryData;
      });
    } else {
      throw Exception('Gagal memuat data galeri');
    }
  }

  void _filterGalery(String query) {
    setState(() {
      _filteredGaleryData = _galeryData
          .where((item) =>
              item['judul_galery'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> addGalery(String judul, String isi, String imageUrl,
      String status, String kdPetugas) async {
    final response = await http.post(
      Uri.parse('https://hayy.my.id/API-Refa/galery.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'judul_galery': judul,
        'isi_galery': isi,
        'image_url': imageUrl,
        'tgl_post_galery': DateTime.now().toIso8601String(),
        'status_galery': status,
        'kd_petugas': kdPetugas,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menambahkan galeri');
    } else {
      await fetchGalery();
    }
  }

  Future<void> editGalery(String id, String judul, String isi, String imageUrl,
      String status, String kdPetugas) async {
    final response = await http.put(
      Uri.parse('https://hayy.my.id/API-Refa/galery.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'kd_galery': id,
        'judul_galery': judul,
        'isi_galery': isi,
        'image_url': imageUrl,
        'tgl_post_galery': DateTime.now().toIso8601String(),
        'status_galery': status,
        'kd_petugas': kdPetugas,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengedit galeri');
    } else {
      await fetchGalery();
    }
  }

  Future<void> deleteGalery(String id) async {
    final response = await http.delete(
      Uri.parse('https://hayy.my.id/API-Refa/galery.php?kd_galery=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus galeri');
    } else {
      await fetchGalery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white70],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Galeri',
                  prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.blueAccent),
                    onPressed: () {
                      _searchController.clear();
                      _filterGalery('');
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                onChanged: _filterGalery,
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                padding: const EdgeInsets.all(10.0),
                itemCount: _filteredGaleryData.length,
                itemBuilder: (context, index) {
                  var data = _filteredGaleryData[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text(data['judul_galery'] ?? 'Tidak ada judul'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  data['image_url'] ??
                                      'https://creazilla-store.fra1.digitaloceanspaces.com/icons/3251108/person-icon-md.png',
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Text(data['isi_galery'] ??
                                    'Tidak ada deskripsi'),
                                Text(data['tgl_post_galery'] ??
                                    'Tidak ada tanggal'),
                                Text(data['status_galery'] ??
                                    'Tidak ada status'),
                                Text(data['kd_petugas'] ??
                                    'Tidak ada kode petugas'),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Tutup'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final judulController =
                                          TextEditingController(
                                              text: data['judul_galery']);
                                      final isiController =
                                          TextEditingController(
                                              text: data['isi_galery']);
                                      final imageUrlController =
                                          TextEditingController(
                                              text: data['image_url']);
                                      final statusController =
                                          TextEditingController(
                                              text: data['status_galery']);
                                      final kdPetugasController =
                                          TextEditingController(
                                              text: data['kd_petugas']);

                                      return AlertDialog(
                                        title: const Text('Edit Galeri'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: judulController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Judul'),
                                            ),
                                            TextField(
                                              controller: isiController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Isi'),
                                            ),
                                            TextField(
                                              controller: imageUrlController,
                                              decoration: const InputDecoration(
                                                  labelText: 'URL Gambar'),
                                            ),
                                            TextField(
                                              controller: statusController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Status'),
                                            ),
                                            TextField(
                                              controller: kdPetugasController,
                                              decoration: const InputDecoration(
                                                  labelText: 'Kode Petugas'),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                await editGalery(
                                                  data['kd_galery'],
                                                  judulController.text,
                                                  isiController.text,
                                                  imageUrlController.text,
                                                  statusController.text,
                                                  kdPetugasController.text,
                                                );
                                                Navigator.of(context).pop();
                                              } catch (e) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Error'),
                                                      content: Text(
                                                          'Gagal mengedit galeri: $e'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Text('Tutup'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            child: const Text('Simpan'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  try {
                                    await deleteGalery(data['kd_galery']);
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(
                                              'Gagal menghapus galeri: $e'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Tutup'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              child: Image.network(
                                data['image_url'] ??
                                    'https://creazilla-store.fra1.digitaloceanspaces.com/icons/3251108/person-icon-md.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              data['judul_galery'] ?? 'Tidak ada judul',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              data['tgl_post_galery'] ?? 'Tidak ada tanggal',
                              style: const TextStyle(color: Colors.grey),
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
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final judulController = TextEditingController();
              final isiController = TextEditingController();
              final imageUrlController = TextEditingController();
              final statusController = TextEditingController();
              final kdPetugasController = TextEditingController();

              return AlertDialog(
                title: const Text('Tambah Galeri'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(labelText: 'Judul'),
                    ),
                    TextField(
                      controller: isiController,
                      decoration: const InputDecoration(labelText: 'Isi'),
                    ),
                    TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(labelText: 'URL Gambar'),
                    ),
                    TextField(
                      controller: statusController,
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    TextField(
                      controller: kdPetugasController,
                      decoration: const InputDecoration(labelText: 'Kode Petugas'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await addGalery(
                        judulController.text,
                        isiController.text,
                        imageUrlController.text,
                        statusController.text,
                        kdPetugasController.text,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
