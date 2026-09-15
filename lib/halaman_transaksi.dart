import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'transaksi.dart';
import 'transaksi_card.dart';
import 'jenis_penyaring.dart';

class HalamanTransaksi extends StatefulWidget {
  final List<Transaksi> transaksi;

  const HalamanTransaksi({
    super.key,
    required this.transaksi,
  });

  @override
  State<HalamanTransaksi> createState() =>
      _HalamanTransaksiState();
}

class _HalamanTransaksiState
    extends State<HalamanTransaksi> {
  final TextEditingController pencarianController =
      TextEditingController();

  String pencarian = '';
  String pilihan = 'Semua';

  @override
  void dispose() {
    pencarianController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // F2 - Saring kategori
    final List<Transaksi> hasil =
        widget.transaksi.where((item) {
      final String teksCari =
          pencarian.toLowerCase().trim();

      final bool cocokCari =
          item.keterangan
              .toLowerCase()
              .contains(teksCari) ||
          item.kategori
              .toLowerCase()
              .contains(teksCari);

      final bool cocokKategori =
          pilihan == 'Semua' ||
          item.kategori == pilihan;

      return cocokCari && cocokKategori;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                10,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaksi',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Catat dan kelola semua transaksi',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 18),

                  TextField(
                    controller: pencarianController,
                    onChanged: (value) {
                      setState(() {
                        pencarian = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari transaksi...',
                      prefixIcon:
                          const Icon(Icons.search),
                      suffixIcon: pencarian.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                pencarianController.clear();

                                setState(() {
                                  pencarian = '';
                                });
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  JenisPenyaring(
                    pilihan: pilihan,
                    onChanged: (value) {
                      setState(() {
                        pilihan = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: hasil.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 50,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Transaksi tidak ditemukan',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        100,
                      ),
                      itemCount: hasil.length,
                      itemBuilder: (context, index) {
                        return TransaksiCard(
                          transaksi: hasil[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}