import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'transaksi.dart';
import 'beranda.dart';
import 'halaman_transaksi.dart';
import 'halaman_saldo.dart';
import 'halaman_profil.dart';
import 'tambah_transaksi.dart';

void main() {
  runApp(const BukuKasApp());
}

class BukuKasApp extends StatelessWidget {
  const BukuKasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buku Kas',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const MainKasScreen(),
    );
  }
}

class MainKasScreen extends StatefulWidget {
  const MainKasScreen({super.key});

  @override
  State<MainKasScreen> createState() => _MainKasScreenState();
}

class _MainKasScreenState extends State<MainKasScreen> {
  int halamanAktif = 0;

  final List<Transaksi> daftarTransaksi = [
    Transaksi(
      id: '1',
      keterangan: 'Penjualan Produk',
      jenis: 'Masuk',
      kategori: 'Penjualan',
      jumlah: 250000,
      tanggal: DateTime(2026, 8, 14),
      fotoUrl: '',
    ),
    Transaksi(
      id: '2',
      keterangan: 'Belanja Bahan',
      jenis: 'Keluar',
      kategori: 'Belanja',
      jumlah: 75000,
      tanggal: DateTime(2026, 8, 13),
      fotoUrl: '',
    ),
    Transaksi(
      id: '3',
      keterangan: 'Penjualan Hari Ini',
      jenis: 'Masuk',
      kategori: 'Penjualan',
      jumlah: 350000,
      tanggal: DateTime(2026, 8, 12),
      fotoUrl: '',
    ),
    Transaksi(
      id: '4',
      keterangan: 'Biaya Transportasi',
      jenis: 'Keluar',
      kategori: 'Transportasi',
      jumlah: 50000,
      tanggal: DateTime(2026, 8, 11),
      fotoUrl: '',
    ),
    Transaksi(
      id: '5',
      keterangan: 'Pembayaran Pesanan',
      jenis: 'Masuk',
      kategori: 'Penjualan',
      jumlah: 175000,
      tanggal: DateTime(2026, 8, 10),
      fotoUrl: '',
    ),
    Transaksi(
      id: '6',
      keterangan: 'Pembayaran Listrik',
      jenis: 'Keluar',
      kategori: 'Tagihan',
      jumlah: 100000,
      tanggal: DateTime(2026, 8, 9),
      fotoUrl: '',
    ),
    Transaksi(
      id: '7',
      keterangan: 'Pembayaran Gaji',
      jenis: 'Keluar',
      kategori: 'Gaji',
      jumlah: 150000,
      tanggal: DateTime(2026, 8, 8),
      fotoUrl: '',
    ),
    Transaksi(
      id: '8',
      keterangan: 'Penjualan Minuman',
      jenis: 'Masuk',
      kategori: 'Penjualan',
      jumlah: 125000,
      tanggal: DateTime(2026, 8, 7),
      fotoUrl: '',
    ),
  ];

  Future<void> tambahTransaksi() async {
    final Transaksi? hasil = await Navigator.push<Transaksi>(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahTransaksi(),
      ),
    );

    if (hasil != null) {
      setState(() {
        daftarTransaksi.insert(0, hasil);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: halamanAktif,
        children: [
          Beranda(
            transaksi: daftarTransaksi,
          ),
          HalamanTransaksi(
            transaksi: daftarTransaksi,
          ),
          HalamanSaldo(
            transaksi: daftarTransaksi,
          ),
          const HalamanProfil(),
        ],
      ),

      floatingActionButton: halamanAktif == 0 || halamanAktif == 1
          ? FloatingActionButton(
              onPressed: tambahTransaksi,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: NavigationBar(
        selectedIndex: halamanAktif,
        onDestinationSelected: (index) {
          setState(() {
            halamanAktif = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primarySoft,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Saldo',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}