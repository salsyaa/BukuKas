import 'package:flutter/material.dart';
import 'transaksi.dart';

class TransaksiCard extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiCard({
    super.key,
    required this.transaksi,
  });

  @override
  Widget build(BuildContext context) {
    final bool masuk = transaksi.isMasuk;

    final String namaFile =
        _namaFileKategori(transaksi.kategori);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              'assets/images/$namaFile.png',
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: masuk
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius:
                        BorderRadius.circular(13),
                  ),
                  child: Icon(
                    masuk
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: masuk
                        ? Colors.green
                        : Colors.red,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  transaksi.keterangan,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${transaksi.kategori} • ${_formatTanggal(transaksi.tanggal)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '${masuk ? '+' : '-'} Rp ${_formatRupiah(transaksi.jumlah)}',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: masuk
                  ? Colors.green.shade600
                  : Colors.red.shade500,
            ),
          ),
        ],
      ),
    );
  }

  String _namaFileKategori(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'penjualan':
        return 'penjualan';

      case 'belanja':
        return 'belanja';

      case 'operasional':
        return 'operasional';

      case 'transportasi':
        return 'transportasi';

      default:
        return 'lainnya';
    }
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}-'
        '${tanggal.month.toString().padLeft(2, '0')}-'
        '${tanggal.year}';
  }

  String _formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}