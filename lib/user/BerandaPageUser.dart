import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:perpus_app/page/login.dart';
import 'package:perpus_app/provider/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BerandaPageUser extends StatefulWidget {
  final String role;
  final String name;

  const BerandaPageUser({
    super.key,
    required this.role,
    required this.name,
  });

  @override
  State<BerandaPageUser> createState() => _BerandaPageUserState();
}

class _BerandaPageUserState extends State<BerandaPageUser> {
  int _selectedIndex = 0;
  late Future<List<dynamic>> _barangList;
  List<Map<String, dynamic>> _keranjang = [];

  @override
  void initState() {
    super.initState();
    _barangList = _fetchBarang();
  }

  Future<List<dynamic>> _fetchBarang() async {
    final response = await http
        .get(Uri.parse('https://latihan-json.aksi-pintar.com/api/barang'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['data'] != null) {
        return List<dynamic>.from(data['data']);
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load barang');
    }
  }

  void _tambahKeKeranjang(dynamic item) {
    setState(() {
      _keranjang.add({
        'item': item,
        'jumlah': 1,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${item['nama']} berhasil ditambahkan ke keranjang')),
    );
  }

  void _ubahJumlahPesanan(int index, int jumlah) {
    setState(() {
      _keranjang[index]['jumlah'] = jumlah;
    });
  }

  Future<void> _logout() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final success = await loginProvider.logout();

    if (success) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loginProvider.errorMessage)),
      );
    }
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return FutureBuilder<List<dynamic>>(
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
                    trailing: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      onPressed: () {
                        _tambahKeKeranjang(item);
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      case 1:
        final totalHarga = _keranjang.fold<double>(
          0.0,
          (sum, item) =>
              sum + (double.parse(item['item']['harga']) * item['jumlah']),
        );

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _keranjang.length,
                itemBuilder: (context, index) {
                  final item = _keranjang[index];

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title:
                          Text(item['item']['nama'] ?? 'Nama Tidak Tersedia'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kode Barang: ${item['item']['kd_barang']}'),
                          Text('Merek: ${item['item']['merek']}'),
                          Text('Harga: ${item['item']['harga']}'),
                          Text('Jumlah: ${item['jumlah']}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (item['jumlah'] > 1) {
                                _ubahJumlahPesanan(index, item['jumlah'] - 1);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _ubahJumlahPesanan(index, item['jumlah'] + 1);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Harga: Rp. ${totalHarga.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ],
        );
      case 2:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama: ${widget.name}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        );
      default:
        return const Center(
          child: Text('Invalid page'),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda User'),
      ),
      body: _getPage(_selectedIndex),
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
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
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
