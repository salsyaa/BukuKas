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
  State<HalamanTransaksi> createState() => _HalamanTransaksiState();
}

class _HalamanTransaksiState extends State<HalamanTransaksi> {
  final TextEditingController pencarianController =
      TextEditingController();

  String pencarian = '';
  String pilihan = 'Semua';

  @override
  void dispose() {
    pencarianController.dispose();
    super.dispose();
  }

  // ==========================================================
  // CEK TRANSAKSI YANG MELEBIHI SALDO
  // ==========================================================
  bool transaksiMelebihiSaldo(Transaksi target) {
    int saldo = 0;

    // Salin data agar tidak mengubah urutan data asli
    final List<Transaksi> semuaTransaksi = [...widget.transaksi];

    // Urutkan berdasarkan tanggal
    semuaTransaksi.sort(
      (a, b) => a.tanggal.compareTo(b.tanggal),
    );

    for (final item in semuaTransaksi) {
      // Saat sampai pada transaksi yang sedang diperiksa
      if (item.id == target.id) {
        // Jika transaksi keluar lebih besar
        // daripada saldo yang tersedia
        if (!item.isMasuk && item.jumlah > saldo) {
          return true;
        }

        return false;
      }

      // Hitung saldo sebelum transaksi target
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
    // ==========================================================
    // FILTER PENCARIAN DAN JENIS
    // ==========================================================
    final List<Transaksi> hasil = widget.transaksi.where((item) {
      final String teksCari = pencarian.toLowerCase().trim();

      // Cari berdasarkan keterangan atau kategori
      final bool cocokPencarian =
          item.keterangan.toLowerCase().contains(teksCari) ||
          item.kategori.toLowerCase().contains(teksCari);

      // Filter berdasarkan jenis transaksi
      final bool cocokJenis =
          pilihan == 'Semua' ||
          (pilihan == 'Masuk' && item.isMasuk) ||
          (pilihan == 'Keluar' && !item.isMasuk);

      return cocokPencarian && cocokJenis;
    }).toList();

    // ==========================================================
    // HITUNG SALDO BERJALAN
    // Saldo dihitung dari transaksi yang sedang ditampilkan
    // ==========================================================
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

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        title: const Text(
          'Transaksi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // JUDUL
              // ==================================================
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  0,
                ),
                child: Text(
                  'Catat dan kelola semua transaksi',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),

              // ==================================================
              // SALDO BERJALAN
              // ==================================================
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  12,
                ),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo Berjalan',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatRupiah(saldoBerjalan),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // SEARCH
              // ==================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextField(
                  controller: pencarianController,
                  onChanged: (value) {
                    setState(() {
                      pencarian = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari transaksi...',
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    suffixIcon: pencarian.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                            ),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // PENYARING JENIS
              // SEMUA / MASUK / KELUAR
              // ==================================================
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: JenisPenyaring(
                  pilihanAwal: pilihan,
                  onChanged: (value) {
                    setState(() {
                      pilihan = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              // ==================================================
              // DAFTAR TRANSAKSI
              // ==================================================
              hasil.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          'Tidak ada transaksi',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Menentukan jumlah kolom berdasarkan
                        // lebar layar.
                        int jumlahKolom;

                        if (constraints.maxWidth < 600) {
                          // HP portrait
                          jumlahKolom = 1;
                        } else if (constraints.maxWidth < 900) {
                          // HP landscape / tablet kecil
                          jumlahKolom = 2;
                        } else {
                          // Layar besar
                          jumlahKolom = 3;
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            20,
                            8,
                            20,
                            100,
                          ),

                          // Penting agar GridView mengikuti
                          // tinggi seluruh isi.
                          shrinkWrap: true,

                          // Scroll ditangani oleh
                          // SingleChildScrollView.
                          physics:
                              const NeverScrollableScrollPhysics(),

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: jumlahKolom,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,

                            // Tinggi kartu
                            mainAxisExtent: 210,
                          ),

                          itemCount: hasil.length,

                          itemBuilder: (context, index) {
                            final Transaksi item =
                                hasil[index];

                            return TransaksiCard(
                              transaksi: item,

                              // Peringatan jika transaksi
                              // benar-benar melebihi saldo
                              melebihiSaldo:
                                  transaksiMelebihiSaldo(item),
                            );
                          },
                        );
                      },
                    ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// FORMAT RUPIAH
// ============================================================
String formatRupiah(int angka) {
  final bool negatif = angka < 0;
  final String nilai = angka.abs().toString();

  final StringBuffer hasil = StringBuffer();

  for (int i = 0; i < nilai.length; i++) {
    if (i > 0 &&
        (nilai.length - i) % 3 == 0) {
      hasil.write('.');
    }

    hasil.write(nilai[i]);
  }

  return negatif
      ? '-Rp ${hasil.toString()}'
      : 'Rp ${hasil.toString()}';
}