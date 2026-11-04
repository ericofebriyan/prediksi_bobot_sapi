import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../prediction/providers/cattle_provider.dart';
import '../../prediction/presentation/prediction_form_screen.dart';
import '../../consultation/presentation/consultation_screen.dart';
import '../../roi_calculator/presentation/roi_calculator_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final cattleProv = context.watch<CattleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F6),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.forestGreen,
          onRefresh: () => cattleProv.init(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Bar / App Header
                _buildHeader(context),
                const SizedBox(height: 12),

                // 2. Greeting Card (Pak Sutrisno)
                _buildGreetingCard(context),
                const SizedBox(height: 12),

                // 3. SQLite Offline Pill Status
                _buildOfflinePill(context),
                const SizedBox(height: 14),

                // 4. Two Metric Cards (Total Ternak & Siap Panen)
                _buildMetricCards(context),
                const SizedBox(height: 14),

                // 5. Growth Rate (ADG) Card with Sparkline Chart
                _buildAdgCard(context),
                const SizedBox(height: 14),

                // 6. AI Inference Simulation Banner (Dark Forest Green)
                _buildAiBanner(context),
                const SizedBox(height: 20),

                // 7. Menu Operasional Kandang
                _buildMenuOperasional(context),
                const SizedBox(height: 22),

                // 8. Penggemukan (Feedlot) Section (1-2 item uji coba figma)
                _buildFeedlotSection(context),
                const SizedBox(height: 16),

                // 9. Backup Kandang Card
                _buildBackupCard(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 1. HEADER SECTION
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // App Icon
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

        // App Title & Status
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

        // Profile Avatar Button
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showFarmInfoSheet(context);
          },
          child: Container(
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
        ),
      ],
    );
  }

  // ==========================================
  // 2. GREETING CARD (Pak Sutrisno)
  // ==========================================
  Widget _buildGreetingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Row(
        children: [
          // Farmer Profile Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/farmer_sutrisno.jpg',
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.forestGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.forestGreen,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.wb_sunny_outlined,
                      size: 13,
                      color: Color(0xFF854D0E),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'SUGENG ENJANG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF78350F),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Text(
                  'Pak Sutrisno',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'Peternakan Sumber Barokah, Bangka...',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Notification Bell
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: IconButton(
              iconSize: 18,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF374151),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tidak ada notifikasi kandang yang mendesak.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. OFFLINE STATUS CAPSULE
  // ==========================================
  Widget _buildOfflinePill(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EE),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFCDE8D8), width: 0.8),
      ),
      child: Row(
        children: const [
          Icon(Icons.circle, size: 7, color: Color(0xFF059669)),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'SQLite Local Active • 12 Sapi Terc...',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF065F46),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.history_toggle_off_rounded, size: 14, color: Color(0xFF065F46)),
          SizedBox(width: 4),
          Text(
            '100% Offline Ready',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF065F46),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. STAT METRIC CARDS (TOTAL TERNAK & SIAP PANEN)
  // ==========================================
  Widget _buildMetricCards(BuildContext context) {
    return Row(
      children: [
        // Total Ternak Card
        Expanded(
          child: Container(
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
                  children: const [
                    Text(
                      'TOTAL TERNAK',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                    Icon(
                      Icons.info_outline_rounded,
                      size: 15,
                      color: Color(0xFF9CA3AF),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '12',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ekor',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sapi Madura Ras Murni',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Siap Panen Card
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.terracottaLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.terracottaBorder, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SIAP PANEN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEDD5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.eco_outlined,
                        size: 13,
                        color: Color(0xFFEA580C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: const [
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Ekor',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Bulan Ini (Est. Qurban)',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFFC2410C),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. ADG RATE & CHART CARD
  // ==========================================
  Widget _buildAdgCard(BuildContext context) {
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
              const Text(
                'RATA-RATA PERTUMBUHAN HARIAN (ADG)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: Color(0xFF4B5563),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.trending_up_rounded,
                      size: 13,
                      color: Color(0xFF047857),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Optimal',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF047857),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: const [
              Text(
                '0.72',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(width: 6),
              Text(
                'kg / hari',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Custom Sparkline upward chart
          SizedBox(
            height: 44,
            width: double.infinity,
            child: CustomPaint(
              painter: _AdgSparklinePainter(),
            ),
          ),
          const SizedBox(height: 8),

          // Footer note
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: Color(0xFF10B981),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 11, color: Color(0xFF4B5563)),
                    children: [
                      TextSpan(text: 'Naik '),
                      TextSpan(
                        text: '+0.2 kg/hari',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                      ),
                      TextSpan(text: ' dibanding pakan konvensional jerami'),
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
  // 6. AI SIMULATION BANNER
  // ==========================================
  Widget _buildAiBanner(BuildContext context) {
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
          // ONNX Runtime pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.memory_rounded, size: 14, color: Color(0xFF6EE7B7)),
                SizedBox(width: 6),
                Text(
                  'ENGINE ONNX RUNTIME V1.14',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    color: Color(0xFFE2E8F0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Simulasi Prediksi Panen AI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Hitung perkiraan bobot potong dan nilai jual qurban secara instan di dalam kandang tanpa memerlukan koneksi internet.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Action row
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.terracotta,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (onNavigateTab != null) {
                      onNavigateTab!(1);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PredictionFormScreen()),
                      );
                    }
                  },
                  icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
                  label: const Text(
                    'Jalankan Inferensi',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () {
                  _showEngineSettingsDialog(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
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
  // 7. MENU OPERASIONAL KANDANG
  // ==========================================
  Widget _buildMenuOperasional(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Operasional Kandang',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Catat Timbang
            Expanded(
              child: _buildOperationButton(
                context: context,
                icon: Icons.scale_rounded,
                iconColor: const Color(0xFF0F766E),
                backgroundColor: const Color(0xFFCCFBF1),
                label: 'Catat Timbang',
                onTap: () {
                  _showQuickWeightSheet(context);
                },
              ),
            ),
            const SizedBox(width: 10),

            // Panggil Dokter
            Expanded(
              child: _buildOperationButton(
                context: context,
                icon: Icons.medical_services_outlined,
                iconColor: const Color(0xFFE11D48),
                backgroundColor: const Color(0xFFFFE4E6),
                label: 'Panggil Dokter',
                onTap: () {
                  if (onNavigateTab != null) {
                    onNavigateTab!(3);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConsultationScreen()),
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 10),

            // Kalkulator FCR
            Expanded(
              child: _buildOperationButton(
                context: context,
                icon: Icons.calculate_outlined,
                iconColor: const Color(0xFF475569),
                backgroundColor: const Color(0xFFF1F5F9),
                label: 'Kalkulator FCR',
                onTap: () {
                  if (onNavigateTab != null) {
                    onNavigateTab!(2);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RoiCalculatorScreen()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationButton({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: backgroundColor,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 8. PENGGEMUKAN (FEEDLOT) - 1-2 ITEMS SESUAI FIGMA
  // ==========================================
  Widget _buildFeedlotSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            const Icon(
              Icons.home_work_outlined,
              size: 18,
              color: Color(0xFF374151),
            ),
            const SizedBox(width: 6),
            const Text(
              'Penggemukan (Feedlot)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                _showAllCattleModal(context);
              },
              child: const Text(
                'Lihat Semua (12) >',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Item 1: Sapi Bima (#MD-042)
        _buildCattleFeedlotCard(
          context: context,
          imagePath: 'assets/images/sapi_bima.jpg',
          name: 'Sapi Bima',
          tag: '#MD-042',
          subtitle: 'Sapi Jantan Madura • Umur 2.1 Thn',
          statusBadge: 'Sehat Prima',
          statusBadgeColor: const Color(0xFFD1FAE5),
          statusTextColor: const Color(0xFF065F46),
          statusIcon: Icons.circle,
          harvestEstimate: 'Panen ~48 hari lagi',
          currentWeight: 340,
          targetWeight: 380,
          adgRate: '+0.78',
          progressPercent: 89.4,
          progressColor: AppColors.forestGreen,
          progressBgColor: const Color(0xFFE5E7EB),
          footerLeftText: 'Progress Penggemukan',
          footerRightText: '89.4% Menuju Target',
          isTerracottaTheme: false,
          onTap: () {
            _showCattleDetailModal(
              context: context,
              name: 'Sapi Bima',
              tag: '#MD-042',
              age: '2.1 Tahun',
              gender: 'Jantan',
              initialWeight: 280,
              currentWeight: 340,
              targetWeight: 380,
              adg: 0.78,
              feedType: 'Konsentrat Komersial (60%) + Rumput Gajah (40%)',
              status: 'Sehat Prima',
            );
          },
        ),
        const SizedBox(height: 12),

        // Item 2: Sapi Arjuna (#MD-039)
        _buildCattleFeedlotCard(
          context: context,
          imagePath: 'assets/images/sapi_arjuna.jpg',
          name: 'Sapi Arjuna',
          tag: '#MD-039',
          subtitle: 'Sapi Jantan Madura • Umur 2.4 Thn',
          statusBadge: 'Mendekati Target',
          statusBadgeColor: AppColors.terracottaBorder,
          statusTextColor: const Color(0xFF9A3412),
          statusIcon: Icons.hourglass_bottom_rounded,
          harvestEstimate: '11 hari lagi',
          currentWeight: 368,
          targetWeight: 375,
          adgRate: '+0.65',
          progressPercent: 98.1,
          progressColor: AppColors.terracotta,
          progressBgColor: const Color(0xFFFED7AA),
          footerLeftText: 'Sisa 7 kg menuju potong',
          footerRightText: '98.1% Siap Panen',
          isTerracottaTheme: true,
          onTap: () {
            _showCattleDetailModal(
              context: context,
              name: 'Sapi Arjuna',
              tag: '#MD-039',
              age: '2.4 Tahun',
              gender: 'Jantan',
              initialWeight: 295,
              currentWeight: 368,
              targetWeight: 375,
              adg: 0.65,
              feedType: 'Konsentrat + Ampas Tahu + Silase Jagung',
              status: 'Mendekati Target (Siap Panen)',
            );
          },
        ),
      ],
    );
  }

  Widget _buildCattleFeedlotCard({
    required BuildContext context,
    required String imagePath,
    required String name,
    required String tag,
    required String subtitle,
    required String statusBadge,
    required Color statusBadgeColor,
    required Color statusTextColor,
    required IconData statusIcon,
    required String harvestEstimate,
    required int currentWeight,
    required int targetWeight,
    required String adgRate,
    required double progressPercent,
    required Color progressColor,
    required Color progressBgColor,
    required String footerLeftText,
    required String footerRightText,
    required bool isTerracottaTheme,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Image + Name + Tag + Status
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        imagePath,
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 58,
                          height: 58,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusBadgeColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(statusIcon, size: 7, color: statusTextColor),
                                    const SizedBox(width: 4),
                                    Text(
                                      statusBadge,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: statusTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                harvestEstimate,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Metrics Box
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isTerracottaTheme ? AppColors.terracottaLight : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isTerracottaTheme ? AppColors.terracottaBorder : const Color(0xFFF3F4F6),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bobot Saat Ini',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isTerracottaTheme ? const Color(0xFF9A3412) : const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '$currentWeight',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isTerracottaTheme ? const Color(0xFF9A3412) : const Color(0xFF111827),
                                    ),
                                  ),
                                  Text(
                                    ' / $targetWeight kg',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isTerracottaTheme ? const Color(0xFF78350F) : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Laju ADG',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isTerracottaTheme ? const Color(0xFF9A3412) : const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up_rounded,
                                    size: 15,
                                    color: isTerracottaTheme ? const Color(0xFF9A3412) : const Color(0xFF111827),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    adgRate,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: isTerracottaTheme ? const Color(0xFF9A3412) : const Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'kg/hr',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isTerracottaTheme ? const Color(0xFF78350F) : const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressPercent / 100.0,
                          minHeight: 6,
                          backgroundColor: progressBgColor,
                          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Progress Footer Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            footerLeftText,
                            style: TextStyle(
                              fontSize: 10,
                              color: isTerracottaTheme ? const Color(0xFF78350F) : const Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            footerRightText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isTerracottaTheme ? const Color(0xFF9A3412) : const Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 9. BACKUP STATUS CARD
  // ==========================================
  Widget _buildBackupCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              size: 16,
              color: Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Backup Kandang Terjamin',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  'Tersinkron otomatis saat mendeteksi koneksi',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(60, 30),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Status Sinkronisasi: 100% Data aman tersimpan lokal di SQLite.'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Cek Status',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODAL / DIALOG HELPERS
  // ==========================================
  void _showCattleDetailModal({
    required BuildContext context,
    required String name,
    required String tag,
    required String age,
    required String gender,
    required double initialWeight,
    required int currentWeight,
    required int targetWeight,
    required double adg,
    required String feedType,
    required String status,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.forestGreen,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Status: $status • Umur $age • Kelamin $gender',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailStat('Bobot Awal', '$initialWeight kg'),
                  _buildDetailStat('Bobot Kini', '$currentWeight kg'),
                  _buildDetailStat('Target Panen', '$targetWeight kg'),
                  _buildDetailStat('Laju ADG', '+$adg kg/hr'),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'Komposisi Pakan Harian:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                feedType,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.forestGreen),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoiCalculatorScreen(initialTag: tag),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calculate_outlined, size: 16, color: AppColors.forestGreen),
                      label: const Text(
                        'Analisis Finansial & FCR',
                        style: TextStyle(fontSize: 11, color: AppColors.forestGreen, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.terracotta,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PredictionFormScreen(prefilledTag: tag),
                          ),
                        );
                      },
                      icon: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
                      label: const Text(
                        'Prediksi Ulang AI',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF143D2B),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConsultationScreen(initialTag: tag),
                      ),
                    );
                  },
                  icon: const Icon(Icons.medical_services_outlined, size: 16),
                  label: const Text(
                    'Lihat Rekam Medis & Konsul Dokter',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Tutup', style: TextStyle(color: Color(0xFF6B7280))),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
        ),
      ],
    );
  }

  void _showFarmInfoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profil Peternakan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Peternak: Pak Sutrisno\nLokasi: Peternakan Sumber Barokah, Pasean, Bangkalan, Madura.\nKapasitas Kandang: 25 Ekor Sapi Madura Ras Murni.\nSistem Edge: Offline ONNX Runtime v1.14 & SQLite Lokal.',
              style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.forestGreen),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllCattleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollCtrl) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
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
              const SizedBox(height: 12),
              const Text(
                'Daftar Semua Sapi Feedlot (12 Ekor)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  children: const [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFD1FAE5),
                        child: Icon(Icons.pets, color: AppColors.forestGreen),
                      ),
                      title: Text('Sapi Bima (#MD-042)', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('340 / 380 kg • ADG +0.78 kg/hr • Sehat Prima'),
                      trailing: Text('48 hari lagi', style: TextStyle(fontSize: 12)),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFFFEDD5),
                        child: Icon(Icons.pets, color: AppColors.terracotta),
                      ),
                      title: Text('Sapi Arjuna (#MD-039)', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('368 / 375 kg • ADG +0.65 kg/hr • Siap Panen'),
                      trailing: Text('11 hari lagi', style: TextStyle(fontSize: 12)),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFF3F4F6),
                        child: Icon(Icons.pets, color: Colors.grey),
                      ),
                      title: Text('Sapi Sadewa (#MD-045)', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('280 / 350 kg • ADG +0.55 kg/hr • Fase Awal'),
                      trailing: Text('120 hari lagi', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEngineSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.tune_rounded, color: AppColors.forestGreen),
            SizedBox(width: 8),
            Text('Konfigurasi Engine AI', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Runtime: ONNX Runtime Edge v1.14', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('• Model: Ensemble Regressor (Ridge + LightGBM)', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('• Presisi: FP32 Quantized', style: TextStyle(fontSize: 12)),
            SizedBox(height: 4),
            Text('• Database: SQLite Offline Embedded', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showQuickWeightSheet(BuildContext context) {
    final weightCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Catat Timbang Berkala',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan hasil penimbangan terbaru untuk memperbarui kalkulasi ADG kandang.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Bobot Terbaru (kg)',
                hintText: 'Contoh: 345',
                suffixText: 'kg',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.forestGreen),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data penimbangan berhasil dicatat ke SQLite lokal.')),
                  );
                },
                child: const Text('Simpan Data Timbang'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// ADG SPARKLINE CUSTOM PAINTER
// ==========================================
class _AdgSparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Upward cubic bezier path
    final path = Path();
    path.moveTo(0, height * 0.75);
    path.cubicTo(
      width * 0.35,
      height * 0.65,
      width * 0.70,
      height * 0.35,
      width,
      height * 0.15,
    );

    // Gradient area fill underneath
    final fillPath = Path.from(path)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF10B981).withValues(alpha: 0.22),
          const Color(0xFF10B981).withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // The line itself
    final linePaint = Paint()
      ..color = const Color(0xFF1B4D3E)
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Marker dot on the peak right side
    final dotPaint = Paint()
      ..color = const Color(0xFF9E4717)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(width, height * 0.15), 4, dotPaint);

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(width, height * 0.15), 4, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
