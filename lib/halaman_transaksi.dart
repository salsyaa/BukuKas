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

  // Mengecek apakah transaksi keluar
  // melebihi saldo yang tersedia sebelumnya.
  bool transaksiMelebihiSaldo(Transaksi target) {
    int saldo = 0;

    final List<Transaksi> semuaTransaksi =
        [...widget.transaksi]
          ..sort(
            (a, b) => a.tanggal.compareTo(b.tanggal),
          );

    for (final item in semuaTransaksi) {
      // Cek transaksi sebelum saldo diubah
      if (item.id == target.id) {
        if (!item.isMasuk &&
            item.jumlah > saldo) {
          return true;
        }

        return false;
      }

      // Perhitungan saldo menggunakan perulangan
      if (item.isMasuk) {
        saldo += item.jumlah;
      } else {
        saldo -= item.jumlah;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    // =========================
    // F2 - PENYARING KATEGORI
    // =========================
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

    // =========================
    // SALDO BERJALAN
    // =========================
    int saldoBerjalan = 0;

    for (final item in hasil) {
      if (item.isMasuk) {
        saldoBerjalan += item.jumlah;
      } else {
        saldoBerjalan -= item.jumlah;
      }
    }

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

                  const SizedBox(height: 15),

                  // =========================
                  // SALDO BERJALAN
                  // =========================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saldo Berjalan',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Rp ${_formatRupiah(saldoBerjalan)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // =========================
                  // PENCARIAN
                  // =========================
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

                      suffixIcon:
                          pencarian.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                  ),
                                  onPressed: () {
                                    pencarianController
                                        .clear();

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

                  // =========================
                  // PENYARING KATEGORI
                  // =========================
                  JenisPenyaring(
                    pilihanAwal: pilihan,
                    onChanged: (value) {
                      setState(() {
                        pilihan = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // =========================
            // DAFTAR TRANSAKSI
            // =========================
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
                              color:
                                  Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )

                  // =========================
                  // LAYOUT BUILDER
                  // =========================
                  : LayoutBuilder(
                      builder:
                          (context, constraints) {
                        int jumlahKolom;
                        double tinggiKartu;

                        // HP
                        if (constraints.maxWidth < 600) {
                          jumlahKolom = 1;
                          tinggiKartu = 210;
                        }

                        // Tablet / layar sedang
                        else if (
                            constraints.maxWidth <
                                900) {
                          jumlahKolom = 2;
                          tinggiKartu = 220;
                        }

                        // Laptop / layar besar
                        else {
                          jumlahKolom = 3;
                          tinggiKartu = 220;
                        }

                        return GridView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(
                            20,
                            8,
                            20,
                            100,
                          ),

                          // =========================
                          // GRID VIEW BUILDER
                          // =========================
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                jumlahKolom,

                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,

                            mainAxisExtent:
                                tinggiKartu,
                          ),

                          itemCount: hasil.length,

                          itemBuilder:
                              (context, index) {
                            final Transaksi item =
                                hasil[index];

                            return TransaksiCard(
                              transaksi: item,

                              // Menampilkan tulisan
                              // "Melebihi saldo"
                              // jika memang saldo tidak cukup.
                              melebihiSaldo:
                                  transaksiMelebihiSaldo(
                                item,
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
    );
  }

  // =========================
  // FORMAT RUPIAH
  // =========================
  String _formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}