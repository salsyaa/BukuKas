import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'transaksi.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({super.key});

  @override
  State<TambahTransaksi> createState() =>
      _TambahTransaksiState();
}

class _TambahTransaksiState
    extends State<TambahTransaksi> {
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();

  final TextEditingController keteranganController =
      TextEditingController();

  final TextEditingController jumlahController =
      TextEditingController();

  String jenis = 'Masuk';
  String kategori = 'Lainnya';

  final List<String> kategoriList = [
    'Lainnya',
    'Penjualan',
    'Gaji',
    'Makanan',
    'Transportasi',
    'Belanja',
    'Tagihan',
  ];

  @override
  void dispose() {
    keteranganController.dispose();
    jumlahController.dispose();
    super.dispose();
  }

  void simpan() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final int jumlah =
        int.tryParse(
              jumlahController.text
                  .replaceAll('.', '')
                  .replaceAll(',', ''),
            ) ??
            0;

    if (jumlah <= 0) {
      return;
    }

    final Transaksi transaksiBaru = Transaksi(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(),
      keterangan:
          keteranganController.text.trim(),
      jenis: jenis,
      kategori: kategori,
      jumlah: jumlah,
      tanggal: DateTime.now(),
      fotoUrl: '',
    );

    Navigator.pop(
      context,
      transaksiBaru,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Jenis Transaksi',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _jenisButton(
                      'Masuk',
                      Icons.arrow_downward,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _jenisButton(
                      'Keluar',
                      Icons.arrow_upward,
                      Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              const Text(
                'Keterangan',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: keteranganController,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Keterangan wajib diisi';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText:
                      'Contoh: Penjualan hari ini',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Jumlah',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              TextFormField(
                controller: jumlahController,
                keyboardType:
                    TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Jumlah wajib diisi';
                  }

                  final int? angka = int.tryParse(
                    value
                        .replaceAll('.', '')
                        .replaceAll(',', ''),
                  );

                  if (angka == null || angka <= 0) {
                    return 'Masukkan jumlah yang valid';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Contoh: 50000',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Kategori',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                initialValue: kategori,
                items: kategoriList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      kategori = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Simpan Transaksi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _jenisButton(
    String value,
    IconData icon,
    MaterialColor color,
  ) {
    final bool aktif = jenis == value;

    return InkWell(
      onTap: () {
        setState(() {
          jenis = value;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: aktif
              ? color.shade50
              : Colors.white,
          borderRadius:
              BorderRadius.circular(14),
          border: Border.all(
            color: aktif
                ? color.shade400
                : Colors.grey.shade200,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color.shade600,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: aktif
                    ? color.shade700
                    : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}