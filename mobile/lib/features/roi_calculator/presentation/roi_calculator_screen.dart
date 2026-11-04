import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/cattle_test_data.dart';
import '../../../core/utils/formatters.dart';

class RoiCalculatorScreen extends StatefulWidget {
  final String? initialTag;
  final double? initialWeight;
  final double? targetWeight;
  final int? daysToHarvest;

  const RoiCalculatorScreen({
    super.key,
    this.initialTag,
    this.initialWeight,
    this.targetWeight,
    this.daysToHarvest,
  });

  @override
  State<RoiCalculatorScreen> createState() => _RoiCalculatorScreenState();
}

class _RoiCalculatorScreenState extends State<RoiCalculatorScreen> {
  int _selectedCattleIndex = 0;

  // Custom simulation overrides (null by default; uses test cattle values)
  double? _customSellingPricePerKg;
  double? _customDailyFeedCost;

  @override
  void initState() {
    super.initState();
    if (widget.initialTag != null) {
      final idx = CattleTestData.testList.indexWhere(
        (c) => c.tag.toUpperCase() == widget.initialTag!.toUpperCase(),
      );
      if (idx != -1) {
        _selectedCattleIndex = idx;
      }
    }
  }

  CattleTestData get currentCattle => CattleTestData.testList[_selectedCattleIndex];

  void _toggleCattle() {
    setState(() {
      _selectedCattleIndex = (_selectedCattleIndex + 1) % CattleTestData.testList.length;
      _customSellingPricePerKg = null;
      _customDailyFeedCost = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Beralih ke analisis data: ${currentCattle.fullName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cattle = currentCattle;

    final sellingPricePerKg = _customSellingPricePerKg ?? cattle.sellingPricePerKg;
    final dailyFeedCost = _customDailyFeedCost ?? cattle.dailyFeedCost;

    final totalFeedCost = dailyFeedCost * cattle.cycleDays;
    final totalHpp = cattle.purchasePrice + totalFeedCost + cattle.medicalCost;
    final estimatedRevenue = cattle.estimatedHarvestWeight * sellingPricePerKg;
    final netProfit = estimatedRevenue - totalHpp;
    final roiPercent = totalHpp > 0 ? (netProfit / totalHpp) * 100 : 0.0;

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
              const SizedBox(height: 14),

              // 2. Modul Tagline & Page Title
              _buildPageTitle(),
              const SizedBox(height: 14),

              // 3. Cattle Subject Selector (Switch between 1-2 test data)
              _buildCattleSelectorCard(cattle),
              const SizedBox(height: 14),

              // 4. Proyeksi Laba Bersih Card (Dark Forest Green)
              _buildProyeksiLabaCard(cattle, netProfit, roiPercent),
              const SizedBox(height: 14),

              // 5. Efisiensi Pakan (FCR) Card
              _buildFcrCard(cattle),
              const SizedBox(height: 18),

              // 6. Rincian Arus Kas & Valuasi (HPP & Revenue)
              _buildArusKasSection(cattle, totalFeedCost, totalHpp, estimatedRevenue, sellingPricePerKg, dailyFeedCost),
              const SizedBox(height: 16),

              // 7. Peluang Panen Maksimal (Qurban Timing)
              _buildPeluangPanenCard(),
              const SizedBox(height: 18),

              // 8. Action Buttons (Simulasi & Download PDF)
              _buildActionButtons(context, cattle, sellingPricePerKg, dailyFeedCost),
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
  // 2. PAGE TITLE & TAGLINE
  // ==========================================
  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.trending_up_rounded, size: 15, color: Color(0xFF9A3412)),
            SizedBox(width: 6),
            Text(
              'MODUL FINANSIAL & VALUASI KANDANG',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9A3412),
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Analisis Finansial & Evaluasi FCR\nPenggemukan Sapi Madura',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Kalkulasi proyeksi laba, konversi pakan harian, dan estimasi nilai jual Qurban.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. CATTLE SUBJECT SELECTOR
  // ==========================================
  Widget _buildCattleSelectorCard(CattleTestData cattle) {
    return Container(
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
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 48,
                height: 48,
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
                        color: const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        cattle.gender,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Target ${cattle.targetWeight.toInt()} kg • Siklus ${cattle.cycleDays} Hari',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Ganti Subjek Sapi Uji Coba',
            onPressed: _toggleCattle,
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF3F4F6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(
              Icons.swap_horiz_rounded,
              color: Color(0xFF374151),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. PROYEKSI LABA BERSIH CARD
  // ==========================================
  Widget _buildProyeksiLabaCard(CattleTestData cattle, double netProfit, double roiPercent) {
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
          // Top Row: Label & Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'PROYEKSI LABA BERSIH',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.6,
                  color: Color(0xFFD1FAE5),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.circle, size: 6, color: Color(0xFF6EE7B7)),
                    SizedBox(width: 4),
                    Text(
                      'Siklus Berjalan',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Big Metric: Net Profit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '+Rp ${Formatters.formatNumber(netProfit.toInt())}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '/ ekor',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Setelah dikurangi modal bakalan, pakan & perawatan medis',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
          const SizedBox(height: 16),

          // Two nested cards (Estimasi ROI & BEP)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimasi ROI',
                        style: TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '${roiPercent.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.trending_up_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Tinggi vs rata-rata 19%',
                        style: TextStyle(fontSize: 10, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Titik Impas (BEP)',
                        style: TextStyle(fontSize: 10, color: Colors.white70),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        cattle.bepString,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Bobot aman min ${cattle.bepMinWeight.toInt()} kg',
                        style: const TextStyle(fontSize: 10, color: Colors.white60),
                      ),
                    ],
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
  // 5. EFISIENSI PAKAN (FCR)
  // ==========================================
  Widget _buildFcrCard(CattleTestData cattle) {
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
          // Header Row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.scale_rounded,
                  size: 18,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Efisiensi Pakan (FCR)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      'Rasio konsumsi pakan terhadap ADG',
                      style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Efisien',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Metric Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Skor FCR Saat Ini',
                      style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          cattle.fcrScore.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'kg/kg',
                          style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kategori: ${cattle.fcrCategory}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 90,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E7EB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 0.72,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.forestGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Standar Lokal: 7.0 - 8.5',
                      style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Footer note
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, size: 15, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563)),
                    children: [
                      const TextSpan(text: 'Dibutuhkan '),
                      TextSpan(
                        text: '${cattle.fcrScore} kg pakan kering',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      const TextSpan(text: ' (hijauan + konsentrat) per penambahan 1kg bobot hidup.'),
                    ],
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
  // 6. RINCIAN ARUS KAS & VALUASI
  // ==========================================
  Widget _buildArusKasSection(
    CattleTestData cattle,
    double totalFeedCost,
    double totalHpp,
    double estimatedRevenue,
    double sellingPricePerKg,
    double dailyFeedCost,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Rincian Arus Kas & Valuasi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            Text(
              '4 Komponen Biaya',
              style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Item 1: Modal Bakalan Awal
        _buildCostItemCard(
          icon: Icons.shopping_cart_outlined,
          title: 'Modal Bakalan Awal',
          subtitle: '${cattle.initialLiveWeight.toInt()} kg @ Rp ${Formatters.formatNumber(cattle.initialPricePerKg.toInt())}/kg bobot',
          value: 'Rp ${Formatters.formatNumber(cattle.purchasePrice.toInt())}',
        ),
        const SizedBox(height: 8),

        // Item 2: Estimasi Biaya Pakan
        _buildCostItemCard(
          icon: Icons.grass_rounded,
          title: 'Estimasi Biaya Pakan',
          subtitle: '${cattle.cycleDays} hari @ Rp ${Formatters.formatNumber(dailyFeedCost.toInt())}/hari',
          value: 'Rp ${Formatters.formatNumber(totalFeedCost.toInt())}',
        ),
        const SizedBox(height: 8),

        // Item 3: Vaksin & Medis
        _buildCostItemCard(
          icon: Icons.medical_services_outlined,
          title: 'Vaksin, Obat Cacing & Jamu',
          subtitle: 'Termasuk garam & premiks mineral',
          value: 'Rp ${Formatters.formatNumber(cattle.medicalCost.toInt())}',
        ),
        const SizedBox(height: 10),

        // Total Biaya Produksi (HPP) Summary Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Biaya Produksi (HPP)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              Text(
                'Rp ${Formatters.formatNumber(totalHpp.toInt())}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Item 4: Estimasi Jual Panen (Peach Highlighted Card)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.terracottaLight,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.terracottaBorder, width: 0.9),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront_outlined,
                  size: 20,
                  color: Color(0xFFC2410C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimasi Jual Panen',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${cattle.estimatedHarvestWeight.toInt()} kg @ Rp ${Formatters.formatNumber(sellingPricePerKg.toInt())}/kg (Pasar Qurban)',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF78350F)),
                    ),
                  ],
                ),
              ),
              Text(
                'Rp ${Formatters.formatNumber(estimatedRevenue.toInt())}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9A3412),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostItemCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF4B5563)),
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
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. PELUANG PANEN MAKSIMAL CARD
  // ==========================================
  Widget _buildPeluangPanenCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFED7AA), width: 0.9),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFF9E4717),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Peluang Panen Maksimal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF78350F),
                  ),
                ),
                const SizedBox(height: 3),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.35),
                    children: [
                      TextSpan(text: 'Timing panen optimal bertepatan '),
                      TextSpan(
                        text: '2 minggu sebelum Hari Raya Idul Adha',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: '. Potensi kenaikan harga jual bakalan mencapai '),
                      TextSpan(
                        text: '+10% hingga 15%',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' dibanding pasar reguler.'),
                    ],
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
  // 8. ACTION BUTTONS
  // ==========================================
  Widget _buildActionButtons(
    BuildContext context,
    CattleTestData cattle,
    double currentPrice,
    double currentDailyFeed,
  ) {
    return Column(
      children: [
        // Button 1: Simulasikan Skenario Harga Lain
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forestGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _showSimulationSheet(context, cattle, currentPrice, currentDailyFeed);
            },
            icon: const Icon(Icons.tune_rounded, size: 18),
            label: const Text(
              'Simulasikan Skenario Harga Lain',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Button 2: Download Laporan Keuangan Kandang (PDF)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F2937),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              _showDownloadPdfDialog(context, cattle);
            },
            icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF374151)),
            label: const Text(
              'Download Laporan Keuangan Kandang (PDF)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // MODALS
  // ==========================================
  void _showSimulationSheet(
    BuildContext context,
    CattleTestData cattle,
    double initialPrice,
    double initialDailyFeed,
  ) {
    double tempPrice = initialPrice;
    double tempDailyFeed = initialDailyFeed;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final tempFeedCost = tempDailyFeed * cattle.cycleDays;
            final tempHpp = cattle.purchasePrice + tempFeedCost + cattle.medicalCost;
            final tempRevenue = cattle.estimatedHarvestWeight * tempPrice;
            final tempNetProfit = tempRevenue - tempHpp;
            final tempRoi = tempHpp > 0 ? (tempNetProfit / tempHpp) * 100 : 0.0;

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Simulasi Skenario Harga & Pakan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Uji sensitivitas margin laba untuk ${cattle.fullName}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                  const Divider(height: 24),

                  // Slider 1: Harga Jual per kg
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Harga Jual Pasar (per kg hidup):',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rp ${Formatters.formatNumber(tempPrice.toInt())}/kg',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: tempPrice,
                    min: 45000,
                    max: 75000,
                    divisions: 30,
                    activeColor: AppColors.forestGreen,
                    onChanged: (val) {
                      setModalState(() => tempPrice = val);
                    },
                  ),
                  const SizedBox(height: 10),

                  // Slider 2: Biaya Pakan Harian
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Biaya Pakan Harian:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Rp ${Formatters.formatNumber(tempDailyFeed.toInt())}/hari',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.terracotta,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: tempDailyFeed,
                    min: 15000,
                    max: 40000,
                    divisions: 25,
                    activeColor: AppColors.terracotta,
                    onChanged: (val) {
                      setModalState(() => tempDailyFeed = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Live Simulation Preview
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Proyeksi Laba', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                            const SizedBox(height: 2),
                            Text(
                              'Rp ${Formatters.formatNumber(tempNetProfit.toInt())}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: tempNetProfit >= 0 ? const Color(0xFF047857) : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Estimasi ROI', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                            const SizedBox(height: 2),
                            Text(
                              '${tempRoi.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Omzet Penjualan', style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                            const SizedBox(height: 2),
                            Text(
                              'Rp ${Formatters.formatNumber(tempRevenue.toInt())}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Save & Apply
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forestGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {
                          _customSellingPricePerKg = tempPrice;
                          _customDailyFeedCost = tempDailyFeed;
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Skenario simulasi harga baru berhasil diterapkan!')),
                        );
                      },
                      child: const Text('Terapkan Skenario Harga Ini'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showDownloadPdfDialog(BuildContext context, CattleTestData cattle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Ekspor Laporan Keuangan', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(
          'Laporan keuangan evaluasi FCR dan laba bersih untuk ${cattle.fullName} siap diekspor ke format PDF skripsi / arsip peternakan.',
          style: const TextStyle(fontSize: 12, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.forestGreen),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Laporan_Finansial_${cattle.name.replaceAll(' ', '_')}.pdf berhasil diunduh ke memori internal.'),
                ),
              );
            },
            child: const Text('Unduh PDF'),
          ),
        ],
      ),
    );
  }
}
