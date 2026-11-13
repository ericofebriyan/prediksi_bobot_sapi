import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/cattle_test_data.dart';
import '../../models/cattle_model.dart';
import '../../models/prediction_result_model.dart';
import '../../providers/cattle_provider.dart';

class NewCattleSubmitResult {
  final CattleTestData cattleData;
  final PredictionResultModel prediction;

  NewCattleSubmitResult({
    required this.cattleData,
    required this.prediction,
  });
}

class NewCattleInputSheet extends StatefulWidget {
  const NewCattleInputSheet({super.key});

  @override
  State<NewCattleInputSheet> createState() => _NewCattleInputSheetState();
}

class _NewCattleInputSheetState extends State<NewCattleInputSheet> {
  final _formKey = GlobalKey<FormState>();

  final _tagCtrl = TextEditingController(text: 'MD-055');
  final _nameCtrl = TextEditingController(text: 'Sapi Sakera');
  final _chestGirthCtrl = TextEditingController();
  final _initialWeightCtrl = TextEditingController(text: '265');
  final _targetWeightCtrl = TextEditingController(text: '380');
  final _ageCtrl = TextEditingController(text: '18');
  final _feedAmountCtrl = TextEditingController(text: '19.5');

  String _gender = AppConstants.genders.first;
  String _feedType = AppConstants.feedTypes.first;
  int _feedFrequency = 3;
  String _healthCondition = AppConstants.healthConditions.first;
  String _vaccinationStatus = AppConstants.vaccinationStatus.first;
  bool _isSaving = false;

  @override
  void dispose() {
    _tagCtrl.dispose();
    _nameCtrl.dispose();
    _chestGirthCtrl.dispose();
    _initialWeightCtrl.dispose();
    _targetWeightCtrl.dispose();
    _ageCtrl.dispose();
    _feedAmountCtrl.dispose();
    super.dispose();
  }

  /// Menghitung estimasi bobot awal dengan Rumus Schoorl jika peternak mengukur Lingkar Dada
  void _estimateWeightFromChestGirth() {
    final girth = double.tryParse(_chestGirthCtrl.text.trim());
    if (girth == null || girth < 80 || girth > 250) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan lingkar dada wajar (80 - 250 cm) terlebih dahulu.'),
        ),
      );
      return;
    }
    final estimatedKg = pow(girth + 22, 2) / 100.0;
    setState(() {
      _initialWeightCtrl.text = estimatedKg.toStringAsFixed(1);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final tag = _tagCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final initialWeight = double.parse(_initialWeightCtrl.text.trim());
    final targetWeight = double.parse(_targetWeightCtrl.text.trim());
    final ageMonths = int.parse(_ageCtrl.text.trim());
    final feedAmount = double.parse(_feedAmountCtrl.text.trim());

    setState(() => _isSaving = true);

    try {
      final provider = context.read<CattleProvider>();
      final cattleModel = CattleModel(
        tagNumber: tag.startsWith('#') ? tag : '#$tag',
        name: name,
        initialWeight: initialWeight,
        entryAgeMonths: ageMonths,
        gender: _gender,
        feedType: _feedType,
        dailyFeedAmount: feedAmount,
        feedFrequency: _feedFrequency,
        healthCondition: _healthCondition,
        vaccinationStatus: _vaccinationStatus,
        targetWeight: targetWeight,
      );

      final insertedId = await provider.addCattle(cattleModel);
      final savedModel = CattleModel(
        id: insertedId,
        tagNumber: cattleModel.tagNumber,
        name: cattleModel.name,
        initialWeight: cattleModel.initialWeight,
        entryAgeMonths: cattleModel.entryAgeMonths,
        gender: cattleModel.gender,
        feedType: cattleModel.feedType,
        dailyFeedAmount: cattleModel.dailyFeedAmount,
        feedFrequency: cattleModel.feedFrequency,
        healthCondition: cattleModel.healthCondition,
        vaccinationStatus: cattleModel.vaccinationStatus,
        targetWeight: cattleModel.targetWeight,
      );

      final prediction = await provider.predictHarvest(
        tagNumber: savedModel.tagNumber,
        initialWeight: savedModel.initialWeight,
        entryAgeMonths: savedModel.entryAgeMonths,
        gender: savedModel.gender,
        feedType: savedModel.feedType,
        dailyFeedAmount: savedModel.dailyFeedAmount,
        feedFrequency: savedModel.feedFrequency,
        healthCondition: savedModel.healthCondition,
        vaccinationStatus: savedModel.vaccinationStatus,
        targetWeight: savedModel.targetWeight,
        saveToHistory: true,
      );

      final subjectData = CattleTestData.fromCattleModel(
        savedModel,
        prediction: prediction,
      );

      if (!mounted) return;
      Navigator.pop(
        context,
        NewCattleSubmitResult(cattleData: subjectData, prediction: prediction),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data sapi baru: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.mintLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_chart_rounded,
                        color: AppColors.forestGreen,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Input Data Sapi Baru (7D)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            'Simpan ke SQLite & langsung jalankan Ensemble AI',
                            style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Baris 1: Ear Tag & Nama Sapi
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _tagCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Ear Tag',
                          hintText: 'MD-055',
                          isDense: true,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nama Sapi',
                          hintText: 'Sapi Sakera',
                          isDense: true,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Helper opsional: Konversi Lingkar Dada ke Bobot Awal
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Opsional: Tidak punya timbangan? Hitung dari Lingkar Dada',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mintDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _chestGirthCtrl,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Lingkar Dada (cm)',
                                hintText: 'Misal: 145',
                                isDense: true,
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.forestGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            onPressed: _estimateWeightFromChestGirth,
                            child: const Text('Hitung', style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Baris 2: Bobot Awal & Target Panen
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _initialWeightCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Bobot Awal (kg)',
                          isDense: true,
                        ),
                        validator: (v) {
                          final val = double.tryParse(v?.trim() ?? '');
                          if (val == null || val < 60 || val > 550) {
                            return '60 - 550 kg';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _targetWeightCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Target Panen (kg)',
                          isDense: true,
                        ),
                        validator: (v) {
                          final target = double.tryParse(v?.trim() ?? '');
                          final initW = double.tryParse(_initialWeightCtrl.text.trim()) ?? 0;
                          if (target == null || target > 650) {
                            return 'Maks 650 kg';
                          }
                          if (target <= initW + 10) {
                            return '> Bobot Awal + 10';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Baris 3: Usia Masuk & Jenis Kelamin
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ageCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Usia (Bulan)',
                          isDense: true,
                        ),
                        validator: (v) {
                          final age = int.tryParse(v?.trim() ?? '');
                          if (age == null || age < 6 || age > 60) {
                            return '6 - 60 bln';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _gender,
                        isDense: true,
                        decoration: const InputDecoration(labelText: 'Kelamin', isDense: true),
                        items: AppConstants.genders
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _gender = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Baris 4: Jenis Pakan Dominan
                DropdownButtonFormField<String>(
                  initialValue: _feedType,
                  isExpanded: true,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Jenis Pakan Dominan', isDense: true),
                  items: AppConstants.feedTypes
                      .map((f) => DropdownMenuItem(
                            value: f,
                            child: Text(f, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _feedType = val);
                  },
                ),
                const SizedBox(height: 12),

                // Baris 5: Jumlah Pakan & Frekuensi Makan
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _feedAmountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Porsi Pakan (kg/hari)',
                          isDense: true,
                        ),
                        validator: (v) {
                          final amt = double.tryParse(v?.trim() ?? '');
                          if (amt == null || amt < 5 || amt > 55) {
                            return '5 - 55 kg/hari';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _feedFrequency,
                        isDense: true,
                        decoration: const InputDecoration(labelText: 'Frekuensi /Hari', isDense: true),
                        items: [2, 3, 4]
                            .map((n) => DropdownMenuItem(value: n, child: Text('${n}x Sehari')))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _feedFrequency = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Baris 6: Kondisi Kesehatan & Vaksinasi
                DropdownButtonFormField<String>(
                  initialValue: _healthCondition,
                  isExpanded: true,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Kondisi Kesehatan', isDense: true),
                  items: AppConstants.healthConditions
                      .map((h) => DropdownMenuItem(value: h, child: Text(h, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _healthCondition = val);
                  },
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  initialValue: _vaccinationStatus,
                  isExpanded: true,
                  isDense: true,
                  decoration: const InputDecoration(labelText: 'Status Vaksinasi', isDense: true),
                  items: AppConstants.vaccinationStatus
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _vaccinationStatus = val);
                  },
                ),
                const SizedBox(height: 18),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isSaving ? null : _submitForm,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: Text(
                      _isSaving ? 'Menyimpan & Memprediksi...' : 'Simpan & Prediksi Sapi Baru',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
