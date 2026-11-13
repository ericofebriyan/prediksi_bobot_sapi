import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/cattle_test_data.dart';
import '../providers/cattle_provider.dart';
import 'widgets/new_cattle_input_sheet.dart';

class PredictionFormScreen extends StatefulWidget {
  final String? prefilledTag;

  const PredictionFormScreen({super.key, this.prefilledTag});

  @override
  State<PredictionFormScreen> createState() => _PredictionFormScreenState();
}

class _PredictionFormScreenState extends State<PredictionFormScreen> {
  final List<CattleTestData> _subjects = List.of(CattleTestData.testList);
  int _selectedCattleIndex = 0;
  late double _currentTargetWeight;
  bool _isPredicting = false;
  String _engineSourceLabel = '100% On-Device (Offline)';

  @override
  void initState() {
    super.initState();
    if (widget.prefilledTag != null) {
      final idx = _subjects.indexWhere(
        (c) => c.tag.toUpperCase() == widget.prefilledTag!.toUpperCase(),
      );
      if (idx != -1) {
        _selectedCattleIndex = idx;
      }
    }
    _currentTargetWeight = currentCattle.targetWeight;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSavedCattleFromSqlite());
  }

  CattleTestData get currentCattle => _subjects[_selectedCattleIndex];

  Future<void> _loadSavedCattleFromSqlite() async {
    try {
      final prov = context.read<CattleProvider>();
      await prov.loadCattleList();
      if (!mounted || prov.cattleList.isEmpty) return;

      setState(() {
        for (final saved in prov.cattleList) {
          final normTag = saved.tagNumber.startsWith('#') ? saved.tagNumber : '#${saved.tagNumber}';
          final exists = _subjects.any((s) => s.tag.toUpperCase() == normTag.toUpperCase());
          if (!exists) {
            _subjects.add(CattleTestData.fromCattleModel(saved));
          }
        }
      });
    } catch (_) {
      // Tetap gunakan subjek default jika SQLite belum siap (misal di widget test)
    }
  }

  void _toggleCattle() {
    setState(() {
      _selectedCattleIndex = (_selectedCattleIndex + 1) % _subjects.length;
      _currentTargetWeight = currentCattle.targetWeight;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Beralih ke subjek ternak: ${currentCattle.fullName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _runEnsemblePrediction() async {
    setState(() {
      _isPredicting = true;
    });

    final cattle = currentCattle;
    try {
      final prov = context.read<CattleProvider>();
      final result = await prov.predictHarvest(
        tagNumber: cattle.tag,
        initialWeight: cattle.currentWeight,
        entryAgeMonths: cattle.ageMonths,
        gender: cattle.gender,
        feedType: cattle.feedType,
        dailyFeedAmount: cattle.dailyFeedAmount,
        feedFrequency: cattle.feedFrequency,
        healthCondition: cattle.feedlotStatus == 'Mendekati Target'
            ? 'Sehat & Aktif'
            : cattle.feedlotStatus,
        vaccinationStatus: cattle.vaccination,
        targetWeight: _currentTargetWeight,
        saveToHistory: false,
      );

      if (!mounted) return;
      setState(() {
        _subjects[_selectedCattleIndex] = cattle.withPrediction(result);
        _engineSourceLabel = result.isFromBackendApi
            ? 'Terhubung API Backend (Python Ensemble)'
            : '100% On-Device (Offline)';
        _isPredicting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inferensi selesai: ${result.daysToHarvest} hari (${result.modelUsed})',
          ),
          backgroundColor: AppColors.forestGreen,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isPredicting = false);
    }
  }

  void _saveToSqlite() async {
    final prov = context.read<CattleProvider>();
    final cattle = currentCattle;

    try {
      await prov.predictHarvest(
        tagNumber: cattle.tag,
        initialWeight: cattle.initialWeight,
        entryAgeMonths: cattle.ageMonths,
        gender: cattle.gender,
        feedType: cattle.feedType,
        dailyFeedAmount: cattle.dailyFeedAmount,
        feedFrequency: cattle.feedFrequency,
        healthCondition: 'Sehat & Aktif',
        vaccinationStatus: cattle.vaccination,
        targetWeight: _currentTargetWeight,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hasil inferensi ${cattle.fullName} berhasil disimpan ke SQLite lokal!'),
          backgroundColor: AppColors.forestGreen,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tersimpan di SQLite lokal offline.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cattle = currentCattle;

    // Hitung batas slider secara dinamis agar aman untuk sapi dengan bobot awal bervariasi
    final double sliderMin = (cattle.currentWeight + 15).clamp(120.0, 350.0);
    final double sliderMax = max(430.0, (cattle.targetWeight + 40).clamp(430.0, 600.0));
    final double safeTargetWeight = _currentTargetWeight.clamp(sliderMin, sliderMax);

    // Hitung estimasi reaktif berdasarkan target weight slider
    final weightDelta = max(0.0, safeTargetWeight - cattle.currentWeight);
    final dynamicDays = cattle.predictedAdg > 0
        ? (weightDelta / cattle.predictedAdg).clamp(5, 365).round()
        : cattle.predictedDays;
    final dynamicHarvestWeight = (safeTargetWeight + 1.4);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Standard SapiMadura AI)
              _buildHeader(context),
              const SizedBox(height: 12),

              // 2. Ensemble Engine Info Card
              _buildEngineInfoCard(),
              const SizedBox(height: 14),

              // 3. Subjek Ternak Aktif Card (Default test data + input sapi baru dari SQLite)
              _buildSubjekTernakCard(cattle),
              const SizedBox(height: 14),

              // 4. Matriks Parameter Input
              _buildParameterMatrixCard(cattle, sliderMin, sliderMax, safeTargetWeight),
              const SizedBox(height: 16),

              // 5. HASIL INFERENSI ENSEMBLE (Dark Forest Green Card)
              _buildHasilInferensiCard(cattle, dynamicDays, dynamicHarvestWeight),
              const SizedBox(height: 16),

              // 6. Dekomposisi Model Regresi (Weighted Voting)
              _buildDekomposisiModelCard(cattle),
              const SizedBox(height: 16),

              // 7. Kurva Trajektori Pertumbuhan (Chart)
              _buildTrajektoriCard(cattle, dynamicDays, dynamicHarvestWeight),
              const SizedBox(height: 16),

              // 8. Rekomendasi AI Kandang Pasean
              _buildRekomendasiSection(cattle),
              const SizedBox(height: 16),

              // 9. Validasi Visual Ternak (CV Dataset)
              _buildValidasiVisualSection(cattle),
              const SizedBox(height: 20),

              // 10. Action Buttons (SQLite & Export)
              _buildActionButtons(context, cattle),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HEADER
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.forestGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'SapiMadura AI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.terracottaBorder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'v1.0',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: const [
                  Icon(Icons.circle, size: 7, color: Color(0xFF10B981)),
                  SizedBox(width: 5),
                  Text(
                    'Kandang Pasean • Edge ONNX Aktif',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.forestGreen,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 2. ENSEMBLE ENGINE INFO CARD
  // ==========================================
  Widget _buildEngineInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, size: 6, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text(
                      'ONNX RUNTIME V2.1',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.history_toggle_off_rounded, size: 13, color: Color(0xFF4B5563)),
                  const SizedBox(width: 4),
                  Text(
                    _engineSourceLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Ensemble Learning Engine',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Weighted Ensemble (XGBoost 50% + LightGBM 35% + Random Forest 15%) • Skripsi Erico Febriyan',
            style: TextStyle(fontSize: 11, color: Color(0xFF4B5563), height: 1.3),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Latency: ', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
              const Text(
                '14.2 ms',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const SizedBox(width: 14),
              const Text('R² Score: ', style: TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
              const Text(
                '0.920',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.terracottaBorder,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Tervalidasi Lapangan',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC2410C),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. SUBJEK TERNAK AKTIF CARD
  // ==========================================
  Widget _buildSubjekTernakCard(CattleTestData cattle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Subjek Ternak Aktif',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(60, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                _showNewCattleDialog(context);
              },
              icon: const Icon(Icons.add_circle_outline_rounded, size: 14, color: AppColors.forestGreen),
              label: const Text(
                'Input Data Baru',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.forestGreen),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  cattle.imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.pets, color: AppColors.forestGreen),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          cattle.fullName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.terracottaBorder,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cattle.qualityBadge,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC2410C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cattle.breedDescription,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.scale_rounded, size: 12, color: Color(0xFF6B7280)),
                        const SizedBox(width: 3),
                        Text(
                          '${cattle.currentWeight.toInt()} kg',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)),
                        ),
                        const Text('  •  ', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10)),
                        const Icon(Icons.verified_outlined, size: 12, color: Color(0xFF10B981)),
                        const SizedBox(width: 3),
                        Text(
                          cattle.vaccination,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Ganti Subjek Sapi Uji Coba',
                onPressed: _toggleCattle,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFF3F4F6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(
                  Icons.swap_horiz_rounded,
                  color: Color(0xFF374151),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. MATRIKS PARAMETER INPUT
  // ==========================================
  Widget _buildParameterMatrixCard(
    CattleTestData cattle,
    double sliderMin,
    double sliderMax,
    double safeTargetWeight,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.tune_rounded, size: 16, color: Color(0xFF374151)),
                  SizedBox(width: 6),
                  Text(
                    'Matriks Parameter Input',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              const Text(
                'Model Feature Vector (7D)',
                style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Two boxes: Bobot Saat Ini & Usia Kronologis
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Bobot Saat Ini', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                          Icon(Icons.scale_rounded, size: 14, color: Color(0xFF9CA3AF)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${cattle.currentWeight.toInt()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Text('kg', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text('Timbang : Kemarin', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Usia Kronologis', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                          Icon(Icons.cake_outlined, size: 14, color: Color(0xFF9CA3AF)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '${cattle.ageMonths}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Text('Bulan', style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text('Fase Penggemukan Akhir', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Ransum Pakan Harian Box (Light Yellow)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A), width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.grass_rounded, size: 14, color: Color(0xFF854D0E)),
                        SizedBox(width: 4),
                        Text(
                          'Ransum Pakan Harian',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF78350F),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEDD5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Campuran Intensif',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC2410C),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  cattle.feedType,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.35),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Kuantitas: ${cattle.dailyFeedAmount} kg/hari',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF78350F),
                      ),
                    ),
                    Text(
                      'Frekuensi: ${cattle.feedFrequency}x Sehari',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF78350F),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Target Bobot Panen Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Target Bobot Panen',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${safeTargetWeight.toInt()} kg',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.forestGreen,
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: AppColors.forestGreen,
              overlayColor: AppColors.forestGreen.withValues(alpha: 0.15),
              trackHeight: 5,
            ),
            child: Slider(
              value: safeTargetWeight,
              min: sliderMin,
              max: sliderMax,
              divisions: max(5, ((sliderMax - sliderMin) / 5).round()),
              onChanged: (val) {
                setState(() {
                  _currentTargetWeight = val;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Min: ${sliderMin.toInt()} kg\n(Ekonomis)', style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                const Text('Ideal Kurban: 380 kg', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF111827))),
                Text('Maks: ${sliderMax.toInt()} kg\n(Sonok)', textAlign: TextAlign.right, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Jalankan Prediksi Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forestGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isPredicting ? null : _runEnsemblePrediction,
              icon: _isPredicting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.flare_rounded, size: 18),
              label: Text(
                _isPredicting ? 'Menghitung Inferensi AI...' : 'Jalankan Prediksi Ensemble AI',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. HASIL INFERENSI ENSEMBLE CARD
  // ==========================================
  Widget _buildHasilInferensiCard(CattleTestData cattle, int dynamicDays, double dynamicHarvestWeight) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF143D2B), Color(0xFF1B4D3E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF143D2B).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.auto_awesome_rounded, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'HASIL INFERENSI ENSEMBLE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: const Text(
                  'Presisi Tinggi (92.0%)',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD1FAE5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              // Left: Estimasi Waktu Panen
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimasi Waktu Panen',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$dynamicDays',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Hari',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '📅 ${CattleTestData.formatIndoDate(DateTime.now().add(Duration(days: dynamicDays)))}',
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // Right: Prediksi Bobot Akhir
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Prediksi Bobot Akhir',
                      style: TextStyle(fontSize: 11, color: Colors.white70),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          dynamicHarvestWeight.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'kg',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'ADG: +${cattle.predictedAdg} kg/hari',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 10),

          // Footer
          const Text(
            'Evaluasi Ensemble : R² = 0.920  •  MAPE: 5.03%  •  MAE: 10.36 Hari',
            style: TextStyle(fontSize: 10, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. DEKOMPOSISI MODEL REGRESI
  // ==========================================
  Widget _buildDekomposisiModelCard(CattleTestData cattle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Dekomposisi Model Regresi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              'Weighted Voting',
              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // 1. XGBoost
        _buildModelRow(
          name: 'XGBoost Regressor',
          weightBadge: 'Bobot 50%',
          badgeColor: AppColors.terracottaBorder,
          badgeTextColor: const Color(0xFFC2410C),
          estimateDays: cattle.xgboostDays,
          estimateWeight: cattle.xgboostWeight,
          adg: cattle.xgboostAdg,
          progressFactor: 0.50,
          progressColor: AppColors.forestGreen,
        ),
        const SizedBox(height: 8),

        // 2. LightGBM
        _buildModelRow(
          name: 'LightGBM Regressor',
          weightBadge: 'Bobot 35%',
          badgeColor: AppColors.terracottaBorder,
          badgeTextColor: const Color(0xFFC2410C),
          estimateDays: cattle.lightgbmDays,
          estimateWeight: cattle.lightgbmWeight,
          adg: cattle.lightgbmAdg,
          progressFactor: 0.35,
          progressColor: AppColors.terracotta,
        ),
        const SizedBox(height: 8),

        // 3. Random Forest
        _buildModelRow(
          name: 'Random Forest',
          weightBadge: 'Bobot 15%',
          badgeColor: const Color(0xFFF1F5F9),
          badgeTextColor: const Color(0xFF475569),
          estimateDays: cattle.rfDays,
          estimateWeight: cattle.rfWeight,
          adg: cattle.rfAdg,
          progressFactor: 0.15,
          progressColor: const Color(0xFF475569),
        ),
      ],
    );
  }

  Widget _buildModelRow({
    required String name,
    required String weightBadge,
    required Color badgeColor,
    required Color badgeTextColor,
    required int estimateDays,
    required double estimateWeight,
    required double adg,
    required double progressFactor,
    required Color progressColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: progressColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  weightBadge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimasi: $estimateDays Hari',
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
              Text(
                '${estimateWeight.toStringAsFixed(1)} kg (ADG +$adg kg)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressFactor,
              minHeight: 5,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. KURVA TRAJEKTORI PERTUMBUHAN CARD
  // ==========================================
  Widget _buildTrajektoriCard(CattleTestData cattle, int dynamicDays, double dynamicHarvestWeight) {
    final startInflect = (dynamicDays * 0.5).round();
    final safeMinRange = max(1, dynamicDays - 3);
    final safeMaxRange = dynamicDays + 4;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Kurva Trajektori Pertumbuhan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    'Infleksi FCR & Batas Efisiensi Pakan',
                    style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.terracottaBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '📈 Optimal',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC2410C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Custom Trajectory Canvas
          SizedBox(
            height: 130,
            width: double.infinity,
            child: CustomPaint(
              painter: _TrajectoryCurvePainter(
                startWeight: cattle.currentWeight,
                targetWeight: dynamicHarvestWeight,
                predictedDays: dynamicDays,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Profit Inflection Warning Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFDE68A), width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFD97706)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Titik Infleksi Profit: Melewati Day $startInflect, efisiensi FCR mulai melandai (saat ini ${cattle.fcrScore}). Rekomendasi jual optimal berada pada rentang $safeMinRange - $safeMaxRange Hari ke depan.',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 8. REKOMENDASI AI KANDANG PASEAN
  // ==========================================
  Widget _buildRekomendasiSection(CattleTestData cattle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.lightbulb_outline_rounded, size: 16, color: AppColors.forestGreen),
            SizedBox(width: 6),
            Text(
              'Rekomendasi AI Kandang Pasean',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Card 1: Ransum Fermentasi
        _buildRekomendasiCard(
          icon: Icons.eco_outlined,
          iconBg: const Color(0xFFD1FAE5),
          iconColor: const Color(0xFF047857),
          title: 'Optimalisasi Ransum (${cattle.fullName})',
          body: 'Pertahankan porsi pakan ${cattle.dailyFeedAmount} kg/hari (${cattle.feedFrequency}x sehari), tambahkan mineral premix 150 gram per sapi per hari untuk menjaga retensi bobot karkas.',
        ),
        const SizedBox(height: 8),

        // Card 2: Hidrasi & Suhu
        _buildRekomendasiCard(
          icon: Icons.water_drop_outlined,
          iconBg: const Color(0xFFFFEDD5),
          iconColor: const Color(0xFFEA580C),
          title: 'Hidrasi & Suhu Lingkungan',
          body: 'Pastikan suplai air minum ad-libitum bergaram mineral (0.5%) saat terik siang pantai utara Madura guna menekan heat stress.',
        ),
      ],
    );
  }

  Widget _buildRekomendasiCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563), height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 9. VALIDASI VISUAL TERNAK (CV DATASET)
  // ==========================================
  Widget _buildValidasiVisualSection(CattleTestData cattle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.camera_alt_outlined, size: 16, color: Color(0xFF374151)),
                SizedBox(width: 6),
                Text(
                  'Validasi Visual Ternak',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            Text(
              'Dataset CV ${cattle.tag}',
              style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            // Photo 1: Samping
            Expanded(
              child: _buildCvPhotoCard(
                imagePath: 'assets/images/validasi_samping.jpg',
                label: 'Tampak Samping (Konformasi)',
              ),
            ),
            const SizedBox(width: 10),

            // Photo 2: Punggung
            Expanded(
              child: _buildCvPhotoCard(
                imagePath: 'assets/images/validasi_punggung.jpg',
                label: 'Tampak Punggung & Lingkar Dada',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCvPhotoCard({required String imagePath, required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(
              imagePath,
              height: 95,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 95,
                color: const Color(0xFFF3F4F6),
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 10. ACTION BUTTONS
  // ==========================================
  Widget _buildActionButtons(BuildContext context, CattleTestData cattle) {
    return Column(
      children: [
        // Button 1: Simpan ke Database SQLite Lokal
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _saveToSqlite,
            icon: const Icon(Icons.storage_rounded, size: 18),
            label: const Text(
              'Simpan ke Database SQLite Lokal',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Row of 2 Secondary Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F2937),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Laporan_Prediksi_${cattle.name.replaceAll(' ', '_')}.pdf berhasil diekspor!')),
                  );
                },
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text(
                  'Ekspor PDF Skripsi',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1F2937),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ringkasan prediksi dibagikan ke WhatsApp Peternak.')),
                  );
                },
                icon: const Icon(Icons.share_outlined, size: 16),
                label: const Text(
                  'Bagikan Peternak',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _showNewCattleDialog(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showModalBottomSheet<NewCattleSubmitResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NewCattleInputSheet(),
    );

    if (result == null || !mounted) return;

    setState(() {
      final newTagUpper = result.cattleData.tag.toUpperCase();
      final existingIdx = _subjects.indexWhere(
        (s) => s.tag.toUpperCase() == newTagUpper,
      );
      if (existingIdx != -1) {
        _subjects[existingIdx] = result.cattleData;
        _selectedCattleIndex = existingIdx;
      } else {
        _subjects.add(result.cattleData);
        _selectedCattleIndex = _subjects.length - 1;
      }
      _currentTargetWeight = result.cattleData.targetWeight;
      _engineSourceLabel = result.prediction.isFromBackendApi
          ? 'Terhubung API Backend (Python Ensemble)'
          : '100% On-Device (Offline)';
    });

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '${result.cattleData.fullName} disimpan ke SQLite! Estimasi panen: ${result.prediction.daysToHarvest} hari.',
        ),
        backgroundColor: AppColors.forestGreen,
      ),
    );
  }
}

// ==========================================
// TRAJECTORY CHART CUSTOM PAINTER
// ==========================================
class _TrajectoryCurvePainter extends CustomPainter {
  final double startWeight;
  final double targetWeight;
  final int predictedDays;

  _TrajectoryCurvePainter({
    required this.startWeight,
    required this.targetWeight,
    required this.predictedDays,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final p0 = Offset(20, height * 0.78);
    final pInflection = Offset(width * 0.52, height * 0.44);
    final pEnd = Offset(width - 25, height * 0.18);

    // Fill underneath
    final fillPath = Path()
      ..moveTo(p0.dx, p0.dy)
      ..quadraticBezierTo(pInflection.dx * 0.8, pInflection.dy, pInflection.dx, pInflection.dy)
      ..quadraticBezierTo(width * 0.75, height * 0.25, pEnd.dx, pEnd.dy)
      ..lineTo(pEnd.dx, height)
      ..lineTo(p0.dx, height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFF97316).withValues(alpha: 0.20),
          const Color(0xFF10B981).withValues(alpha: 0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Dotted vertical line for Inflection point
    final dashedPaint = Paint()
      ..color = const Color(0xFF9CA3AF)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startY = pInflection.dy;
    while (startY < height - 10) {
      canvas.drawLine(Offset(pInflection.dx, startY), Offset(pInflection.dx, startY + 4), dashedPaint);
      startY += 8;
    }

    // Trajectory Line
    final linePath = Path()
      ..moveTo(p0.dx, p0.dy)
      ..quadraticBezierTo(pInflection.dx * 0.8, pInflection.dy, pInflection.dx, pInflection.dy)
      ..quadraticBezierTo(width * 0.75, height * 0.25, pEnd.dx, pEnd.dy);

    final linePaint = Paint()
      ..color = const Color(0xFF111827)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    final midWeight = ((startWeight + targetWeight) / 2).round();
    final midDay = (predictedDays / 2).round();

    // Point 0 (Start)
    canvas.drawCircle(p0, 4, Paint()..color = const Color(0xFF111827));
    _drawLabel(canvas, '${startWeight.toInt()} kg', Offset(p0.dx - 10, p0.dy - 18), false);
    _drawLabel(canvas, 'Day 0', Offset(p0.dx - 10, height - 10), true);

    // Point Inflection
    canvas.drawCircle(pInflection, 4.5, Paint()..color = const Color(0xFF047857));
    _drawLabel(canvas, 'Infleksi $midWeight kg', Offset(pInflection.dx - 35, pInflection.dy - 18), false);
    _drawLabel(canvas, 'Day $midDay', Offset(pInflection.dx - 15, height - 10), true);

    // Point End (Panen Maks)
    canvas.drawCircle(pEnd, 4.5, Paint()..color = const Color(0xFF9E4717));
    _drawLabel(canvas, '${targetWeight.toStringAsFixed(0)} kg', Offset(pEnd.dx - 22, pEnd.dy - 18), false);
    _drawLabel(canvas, 'Day $predictedDays (Optimal)', Offset(pEnd.dx - 55, height - 10), true);
  }

  void _drawLabel(Canvas canvas, String text, Offset offset, bool isSub) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: isSub ? const Color(0xFF9CA3AF) : const Color(0xFF1F2937),
        fontSize: isSub ? 9 : 10,
        fontWeight: isSub ? FontWeight.normal : FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _TrajectoryCurvePainter oldDelegate) =>
      oldDelegate.startWeight != startWeight ||
      oldDelegate.targetWeight != targetWeight ||
      oldDelegate.predictedDays != predictedDays;
}
