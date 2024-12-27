import 'package:flutter/material.dart';
import 'package:perpus_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BerandaPage extends StatefulWidget {
  final String role;
  final String name;

  const BerandaPage({
    super.key,
    required this.role,
    required this.name,
  });

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _selectedIndex = 0;
  late Future<List<dynamic>> _barangList;

  @override
  void initState() {
    super.initState();
    _barangList = _fetchBarang();
  }

// Fungsi untuk mengambil data barang dari API
  Future<List<dynamic>> _fetchBarang() async {
    final response = await http
        .get(Uri.parse('https://latihan-json.aksi-pintar.com/api/barang'));

    if (response.statusCode == 200) {
      // Mengakses kunci "data" yang berisi list barang
      final Map<String, dynamic> data = json.decode(response.body);

      // Memeriksa apakah kunci 'data' tidak null dan memiliki data
      if (data['data'] != null) {
        return List<dynamic>.from(data['data']);
      } else {
        return []; // Kembalikan list kosong jika 'data' null
      }
    } else {
      throw Exception('Failed to load barang');
    }
  }

  // Fungsi untuk menambah barang

  // Fungsi untuk mengedit barang

  Future<void> _hapusBarang(String idBarang) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://latihan-json.aksi-pintar.com/api/hapus-barang/$idBarang'),
      );

      if (response.statusCode == 200) {
        print('Barang berhasil dihapus');
        setState(() {
          _barangList = _fetchBarang();
        });
      } else {
        throw Exception('Gagal menghapus barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus barang')));
    }
  }

  // Menampilkan dialog konfirmasi penghapusan
  Future<bool?> _showDeleteDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus barang ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _tambahBarang(
      String nama, String kodeBarang, String merek, int harga, int stok) async {
    try {
      final response = await http.post(
        Uri.parse('https://latihan-json.aksi-pintar.com/api/tambah-barang'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'kd_barang': kodeBarang,
          'merek': merek,
          'harga': harga.toString(),
          'stok': stok.toString(),
          'image': 'no-image.jpg', // Tambahkan image jika diperlukan
          'kd_user': '3', // Tambahkan kd_user jika diperlukan
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Barang berhasil ditambahkan')));
        setState(() {
          _barangList = _fetchBarang();
        });
      } else {
        print('Gagal menambah barang: ${response.body}');
        throw Exception('Gagal menambah barang: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showAddBarangForm() {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _namaController = TextEditingController();
    final TextEditingController _kodeBarangController = TextEditingController();
    final TextEditingController _merekController = TextEditingController();
    final TextEditingController _hargaController = TextEditingController();
    final TextEditingController _stokController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tambah Barang',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(labelText: 'Nama Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Nama barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _kodeBarangController,
                    decoration: InputDecoration(labelText: 'Kode Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Kode barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _merekController,
                    decoration: InputDecoration(labelText: 'Merek Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Merek barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Harga Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Harga barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Stok Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Stok barang tidak boleh kosong'
                        : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _tambahBarang(
                          _namaController.text,
                          _kodeBarangController.text,
                          _merekController.text,
                          int.parse(_hargaController.text),
                          int.parse(_stokController.text),
                        ).then((_) {
                          Navigator.pop(
                              context); // Tutup bottom sheet setelah menambah barang
                        });
                      }
                    },
                    child: Text('Tambah Barang'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _namaController.dispose();
      _kodeBarangController.dispose();
      _merekController.dispose();
      _hargaController.dispose();
      _stokController.dispose();
    });
  }

// Menampilkan halaman form untuk mengedit barang
  Future<void> _editBarang(String id, String nama, String kodeBarang,
      String merek, int harga, int stok) async {
    try {
      final response = await http.put(
        Uri.parse('https://latihan-json.aksi-pintar.com/api/edit-barang/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': nama,
          'kd_barang': kodeBarang,
          'merek': merek,
          'harga': harga.toString(),
          'stok': stok.toString(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Barang berhasil diperbarui')));
        setState(() {
          _barangList = _fetchBarang();
        });
      } else {
        print('Gagal memperbarui barang: ${response.body}');
        throw Exception('Gagal memperbarui barang: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _updateBarang(String idBarang, String nama, String kodeBarang,
      String merek, int harga, int stok) async {
    try {
      final response = await http.put(
        Uri.parse('https://latihan-json.aksi-pintar.com/api/update-barang'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': idBarang,
          'nama': nama,
          'kd_barang': kodeBarang,
          'merek': merek,
          'harga': harga.toString(),
          'stok': stok.toString(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Barang berhasil diperbarui')));
        setState(() {
          _barangList = _fetchBarang();
        });
      } else {
        print('Gagal memperbarui barang: ${response.body}');
        throw Exception('Gagal memperbarui barang: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showEditBarangForm(String idBarang, String nama, String kodeBarang,
      String merek, int harga, int stok) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _namaController =
        TextEditingController(text: nama);
    final TextEditingController _kodeBarangController =
        TextEditingController(text: kodeBarang);
    final TextEditingController _merekController =
        TextEditingController(text: merek);
    final TextEditingController _hargaController =
        TextEditingController(text: harga.toString());
    final TextEditingController _stokController =
        TextEditingController(text: stok.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Barang',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextFormField(
                    controller: _namaController,
                    decoration: InputDecoration(labelText: 'Nama Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Nama barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _kodeBarangController,
                    decoration: InputDecoration(labelText: 'Kode Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Kode barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _merekController,
                    decoration: InputDecoration(labelText: 'Merek Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Merek barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Harga Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Harga barang tidak boleh kosong'
                        : null,
                  ),
                  TextFormField(
                    controller: _stokController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Stok Barang'),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Stok barang tidak boleh kosong'
                        : null,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _updateBarang(
                          idBarang,
                          _namaController.text,
                          _kodeBarangController.text,
                          _merekController.text,
                          int.parse(_hargaController.text),
                          int.parse(_stokController.text),
                        ).then((_) {
                          if (mounted) {
                            Navigator.pop(
                                context); // Tutup bottom sheet setelah edit barang
                          }
                        });
                      }
                    },
                    child: Text('Update Barang'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _namaController.dispose();
      _kodeBarangController.dispose();
      _merekController.dispose();
      _hargaController.dispose();
      _stokController.dispose();
    });
  }

  // Fungsi logout
  Future<void> _logout() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final success = await loginProvider.logout();

    if (success) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginProvider.errorMessage)),
      );
    }
  }

  // Fungsi untuk konten setiap tab
  Widget _getPage(int index) {
    switch (index) {
      // Halaman beranda

      case 0:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4, // Memberikan efek bayangan pada card
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12), // Membuat sudut card membulat
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Inner padding untuk card
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar header atau ilustrasi (opsional)
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 226, 226, 226),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 60,
                      color: const Color.fromARGB(255, 0, 2, 5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Teks ucapan selamat datang
                  Text(
                    'Selamat datang di Beranda Admin, ${widget.name}!',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Informasi tambahan atau deskripsi
                  const Text(
                    'Kelola aplikasi dengan mudah menggunakan fitur yang tersedia di panel ini.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Tombol tindakan (opsional)
                  ElevatedButton.icon(
                    onPressed: _showAddBarangForm,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Barang'),
                  ),
                ],
              ),
            ),
          ),
        );

// Tampilkan daftar barang

      case 1:
        return Scaffold(
          body: FutureBuilder<List<dynamic>>(
            future: _barangList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada barang ditemukan'));
              }

              final barang = snapshot.data!;

              return ListView.builder(
                itemCount: barang.length,
                itemBuilder: (context, index) {
                  final item = barang[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(item['nama'] ?? 'Nama Tidak Tersedia'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kode Barang: ${item['kd_barang']}'),
                          Text('Merek: ${item['merek']}'),
                          Text('Harga: ${item['harga']}'),
                          Text('Stok: ${item['stok']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showEditBarangForm(
                                item['id'].toString(),
                                item['nama'],
                                item['kd_barang'],
                                item['merek'],
                                int.parse(item['harga']), // Konversi ke int
                                int.parse(item['stok']), // Konversi ke int
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final String idBarang = item['id'].toString();
                              bool? confirmDelete =
                                  await _showDeleteDialog(context);
                              if (confirmDelete == true) {
                                await _hapusBarang(idBarang);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddBarangForm,
            child: const Icon(Icons.add),
          ),
        );

      // Halaman profil

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama: ${widget.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'Role: ${widget.role}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        );
      default:
        return const Center(
          child: Text('Invalid page'),
        );
    }
  }

// Membuat tampilan beranda

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda Admin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _getPage(
            _selectedIndex), // Menampilkan konten sesuai dengan tab yang dipilih
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Barang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
