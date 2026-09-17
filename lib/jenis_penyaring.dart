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

  final List<String> jenis = [
    'Semua',
    'Masuk',
    'Keluar',
  ];

  @override
  void initState() {
    super.initState();
    pilihan = widget.pilihanAwal;
  }

  void pilihJenis(String value) {
    setState(() {
      pilihan = value;
    });

    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: jenis.map((item) {
        final bool aktif = pilihan == item;

        return ChoiceChip(
          label: Text(item),
          selected: aktif,
          onSelected: (_) {
            pilihJenis(item);
          },
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            color: aktif ? Colors.white : AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: AppColors.primary,
          ),
        );
      }).toList(),
    );
  }
}