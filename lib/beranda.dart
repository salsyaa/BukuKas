import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'transaksi.dart';
import 'transaksi_card.dart';

class Beranda extends StatelessWidget {
  final List<Transaksi> transaksi;

  const Beranda({
    super.key,
    required this.transaksi,
  });

  @override
  Widget build(BuildContext context) {
    int pemasukan = 0;
    int pengeluaran = 0;

    for (final item in transaksi) {
      if (item.isMasuk) {
        pemasukan += item.jumlah;
      } else {
        pengeluaran += item.jumlah;
      }
    }

    final int saldo = pemasukan - pengeluaran;

    final List<Transaksi> transaksiTerbaru =
        transaksi.length > 5
            ? transaksi.sublist(0, 5)
            : transaksi;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool desktop = constraints.maxWidth >= 900;

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                desktop ? 40 : 16,
                desktop ? 30 : 18,
                desktop ? 40 : 16,
                100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),

                  const SizedBox(height: 24),

                  _saldoCard(
                    saldo,
                    pemasukan,
                    pengeluaran,
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    'Ringkasan',
                    '${transaksi.length} transaksi',
                  ),

                  const SizedBox(height: 12),

                  _ringkasan(
                    saldo,
                    transaksi.length,
                  ),

                  const SizedBox(height: 28),

                  _sectionTitle(
                    'Transaksi terbaru',
                    'Lihat semua',
                  ),

                  const SizedBox(height: 12),

                  if (transaksiTerbaru.isEmpty)
                    _emptyState()
                  else
                    ...transaksiTerbaru.map(
                      (item) => TransaksiCard(
                        transaksi: item,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selamat datang 👋',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Buku Kas',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: Colors.white,
            size: 23,
          ),
        ),
      ],
    );
  }

  Widget _saldoCard(
    int saldo,
    int pemasukan,
    int pengeluaran,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: 0.18,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'Saldo saat ini',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Rp ${_formatRupiah(saldo)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _saldoItem(
                  Icons.arrow_downward_rounded,
                  'Pemasukan',
                  pemasukan,
                ),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: _saldoItem(
                  Icons.arrow_upward_rounded,
                  'Pengeluaran',
                  pengeluaran,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _saldoItem(
    IconData icon,
    String title,
    int amount,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.16,
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Rp ${_formatRupiah(amount)}',
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(
    String title,
    String rightText,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Text(
          rightText,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _ringkasan(
    int saldo,
    int jumlahTransaksi,
  ) {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            Icons.account_balance_wallet_outlined,
            'Saldo',
            'Rp ${_formatRupiah(saldo)}',
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: _summaryCard(
            Icons.receipt_long_outlined,
            'Transaksi',
            '$jumlahTransaksi',
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 10),

          Text(
            'Belum ada transaksi',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(int angka) {
    return angka.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
}