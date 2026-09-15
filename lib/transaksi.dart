class Transaksi {
  final String id;
  final String keterangan;
  final String jenis;
  final String kategori;
  final int jumlah;
  final DateTime tanggal;
  final String fotoUrl;

  Transaksi({
    required this.id,
    required this.keterangan,
    required this.jenis,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.fotoUrl,
  });

  bool get isMasuk => jenis == 'Masuk';
}