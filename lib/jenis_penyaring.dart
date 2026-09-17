import 'package:flutter/material.dart';
import 'app_colors.dart';

class JenisPenyaring extends StatefulWidget {
  final String pilihanAwal;
  final Function(String) onChanged;

  const JenisPenyaring({
    super.key,
    this.pilihanAwal = 'Semua',
    required this.onChanged,
  });

  @override
  State<JenisPenyaring> createState() => _JenisPenyaringState();
}

class _JenisPenyaringState extends State<JenisPenyaring> {
  late String pilihan;

  final List<String> pilihanList = [
    'Semua',
    'Penjualan',
    'Belanja',
    'Operasional',
    'Transportasi',
    'Gaji',
    'Makanan',
    'Tagihan',
  ];

  @override
  void initState() {
    super.initState();
    pilihan = widget.pilihanAwal;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: pilihanList.map((item) {
          final bool aktif = pilihan == item;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(item),
              selected: aktif,
              onSelected: (_) {
                setState(() {
                  pilihan = item;
                });

                widget.onChanged(item);
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: aktif
                    ? Colors.white
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
              side: BorderSide(
                color: aktif
                    ? AppColors.primary
                    : Colors.grey.shade300,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}