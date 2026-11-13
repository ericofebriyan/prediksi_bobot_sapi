import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../prediction/providers/cattle_provider.dart';
import '../../prediction/presentation/widgets/new_cattle_input_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int, [String?])? onNavigateTab;

  const DashboardScreen({super.key, this.onNavigateTab});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedFilter = 'Semua Paddock';

  final List<String> _filterCategories = [
    'Semua Paddock',
    'Sapi Karapan',
    'Sapi Sonok',
    'Penggemukan (Pedaging)',
  ];

  @override
  Widget build(BuildContext context) {
    final cattleProv = context.watch<CattleProvider>();

    return Scaffold(
      backgroundColor: AppColors.bsDark,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Top Bar / Header matching HTML & Mockup
            _buildHeader(context),

            // Scrollable Content
            Expanded(
              child: RefreshIndicator(
                color: AppColors.bsPrimary,
                backgroundColor: AppColors.bsDarkCard,
                onRefresh: () => cattleProv.init(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Alert Notifikasi Status Jaringan & TLS
                      _buildTlsAlertBanner(context),
                      const SizedBox(height: 14),

                      // 2. Ringkasan Peternakan (Overview Metrics Grid - 3 cols)
                      _buildOverviewMetrics(context, cattleProv),
                      const SizedBox(height: 18),

                      // 3. Action Toolbar (Title + Badge + Export + Tambah)
                      _buildActionToolbar(context),
                      const SizedBox(height: 12),

                      // 4. Quick Filter Pills
                      _buildFilterPills(),
                      const SizedBox(height: 16),

                      // 5. Cattle Monitoring Cards (Filtered)
                      ..._buildCattleCards(context),
                      const SizedBox(height: 14),

                      // 6. Kurva Pertumbuhan Gompertz Card (Model Non-Linear v2.4)
                      _buildGompertzGrowthCard(context),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. TOP HEADER BAR
  // ==========================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.bsDarkHeader,
        border: Border(
          bottom: BorderSide(color: AppColors.bsDarkSurface, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Tele-Vet Logo / Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida/ALJJyrA9t-woOq5etWMsPzlfs17s_fJVKuk_XV8ofoHG4ZuPbpCUzTGDqFpatUq3jJPxa2ayGphEJsMElScHsBwvfhR_WlfxtwL-EMI5DQGmPBSUxWETA_puHncesDUFFam9_jdanKFBJSq_Tp-JCoYpH18XKLGTUp2moWHXZ-nk7geYGbFnCUVHwxqVc_RXkl_KIDBa232RGQrjc23N2SY1RXurKSUpp3ZHCTUnt2ghRM5rlw',
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.bsPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bsPrimary.withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.pets, color: AppColors.bsPrimary, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title & Status Badge
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Tele-Vet Madura',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bsLight,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bsSuccess.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.bsSuccess.withValues(alpha: 0.45),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.bsSuccess,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Online / Synced',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.bsSuccessText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                const Text(
                  'Dashboard Monitoring',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.bsSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Emergency Triage Action
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _showEmergencyTriageModal(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bsDarkSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: const Icon(
                Icons.emergency_rounded,
                color: AppColors.bsDanger,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Doctor Avatar Profile
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _showDoctorProfileSheet(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bsDarkBorder, width: 1.5),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuACqnKdqNBYl3q7pgFTSQaxdpcqzbVKNsQDpadniVeiqmJyRhAEO9Uu-z2Fd9ojRCQc1ehGcRSPtTgt3XyPJpOnvQcg6KnHbLU1hXWQIQ1dOAFacicb7vBI1A5ZnKrR-tRjcqGyX8zRg2xjjfoZYX_6ehoTi1Wa1Ly28c3gG-JKZyS5_-O555KXR4uDeLR7w8aZz4SK3tcazLLH0G3RJWc9B6jhED4bZMgQItQ-CxI1',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/doctor_ahmad.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: AppColors.bsDarkSurface,
                      child: const Icon(Icons.person, color: AppColors.bsSecondary, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. TLS & SYNC ALERT BANNER
  // ==========================================
  Widget _buildTlsAlertBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.bsDarkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_sync_rounded,
            color: AppColors.bsPrimary,
            size: 22,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sinkronisasi Paddock Aktif',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bsLight,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Data telemetry & sensor kandang terenkripsi',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.bsSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.bsSuccess.withValues(alpha: 0.2),
              border: Border.all(color: AppColors.bsSuccess.withValues(alpha: 0.4), width: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'TLS 1.3',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.bsSuccessText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. OVERVIEW METRICS GRID (3 CARDS)
  // ==========================================
  Widget _buildOverviewMetrics(BuildContext context, CattleProvider cattleProv) {
    return Row(
      children: [
        // Populasi
        Expanded(
          child: _buildMetricCard(
            label: 'Populasi',
            icon: Icons.pets_rounded,
            iconColor: AppColors.bsPrimary,
            value: '18',
            unit: 'Ekor',
            subText: '100% Tercatat',
            subTextColor: AppColors.bsSuccessText,
          ),
        ),
        const SizedBox(width: 8),

        // Siap Jual
        Expanded(
          child: _buildMetricCard(
            label: 'Siap Jual',
            icon: Icons.verified_rounded,
            iconColor: AppColors.bsSuccess,
            value: '4',
            unit: 'Ekor',
            subText: 'Bobot >420kg',
            subTextColor: AppColors.bsSuccessText,
          ),
        ),
        const SizedBox(width: 8),

        // Perhatian
        Expanded(
          child: _buildMetricCard(
            label: 'Perhatian',
            icon: Icons.medical_services_rounded,
            iconColor: AppColors.bsDangerText,
            value: '2',
            unit: 'Ekor',
            subText: 'Perlu Triage',
            subTextColor: AppColors.bsDangerText,
            valueColor: AppColors.bsDangerText,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required String subText,
    required Color subTextColor,
    Color valueColor = AppColors.bsLight,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bsDarkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.bsSecondary,
                ),
              ),
              Icon(icon, size: 16, color: iconColor),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.bsSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: subTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. ACTION TOOLBAR
  // ==========================================
  Widget _buildActionToolbar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Daftar Sapi Madura',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: AppColors.bsLight,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.bsDarkSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
              ),
              child: const Text(
                '3 Aktif Dipantau',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.bsSecondary,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Export Button
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _showExportDialog(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bsDarkSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bsDarkBorder),
                ),
                child: const Icon(
                  Icons.download_rounded,
                  color: AppColors.bsLight,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Tambah Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bsPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                minimumSize: const Size(0, 36),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Tambah',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
              ),
              onPressed: () => _openNewCattleSheet(context),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // 5. QUICK FILTER PILLS
  // ==========================================
  Widget _buildFilterPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterCategories.map((category) {
          final isSelected = _selectedFilter == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  _selectedFilter = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.bsPrimary : AppColors.bsDarkCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.bsPrimary : AppColors.bsDarkBorder,
                    width: 0.9,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.bsPrimary.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? Colors.white : AppColors.bsSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // 6. CATTLE CARDS (FILTERED)
  // ==========================================
  List<Widget> _buildCattleCards(BuildContext context) {
    final List<Widget> cards = [];

    // Card 1: Sapi Karapan Jalu (#MDR-2024-001)
    if (_selectedFilter == 'Semua Paddock' || _selectedFilter == 'Sapi Karapan') {
      cards.add(_buildCardJalu(context));
      cards.add(const SizedBox(height: 14));
    }

    // Card 2: Sapi Sonok Melati (#MDR-2024-004)
    if (_selectedFilter == 'Semua Paddock' || _selectedFilter == 'Sapi Sonok') {
      cards.add(_buildCardMelati(context));
      cards.add(const SizedBox(height: 14));
    }

    // Card 3: Sapi Pejantan Perkasa (#MDR-2023-089)
    if (_selectedFilter == 'Semua Paddock' || _selectedFilter == 'Penggemukan (Pedaging)') {
      cards.add(_buildCardPerkasa(context));
      cards.add(const SizedBox(height: 14));
    }

    if (cards.isEmpty) {
      cards.add(
        Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.bsDarkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.bsDarkBorder),
          ),
          child: const Text(
            'Tidak ada ternak dalam kategori ini.',
            style: TextStyle(color: AppColors.bsSecondary, fontSize: 13),
          ),
        ),
      );
    } else {
      // Remove trailing space
      cards.removeLast();
    }

    return cards;
  }

  // ------------------------------------------
  // Card 1: Sapi Karapan Jalu
  // ------------------------------------------
  Widget _buildCardJalu(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bsDarkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bsDarkSurface.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              border: const Border(
                bottom: BorderSide(color: AppColors.bsDarkBorder, width: 0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.bsPrimary.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.bsPrimary.withValues(alpha: 0.45),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '#01',
                        style: TextStyle(
                          color: AppColors.bsPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sapi Karapan Jalu',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bsLight,
                          ),
                        ),
                        Text(
                          'Tag: #MDR-2024-001',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.bsSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bsSuccess,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Optimal',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Image + Quick Info
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.bsDarkBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBQfpJCrRXh6DuhOXhbQq9x8bIKeb_pHhurCeon3Qn7EhbY4pVxYfXdzvu1nnkJYrV3ZeSwL8nqMdFKAsLlGXn2LAoyA9QJuXnsaZfEXXDqN1JhlxAqCRMehLpodHVFCzcakea4jjfiVGOwRBXz47W0YXGKQf_MUzUpOYfnXXPxQT3RrYpAcNCJLAxtlzfSsRpwDdJTyu2pX3_iA8nTp2rDP0_KAEBMUEwUE35dlshl',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/sapi_bima.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.bsDarkSurface,
                              child: const Icon(Icons.pets, color: AppColors.bsSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Bobot Riil:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '342',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bsLight,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'kg',
                                    style: TextStyle(fontSize: 12, color: AppColors.bsSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Target Panen:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Text(
                                '450 kg',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.bsLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Laju ADG:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Text(
                                '+0.82 kg/hari',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bsSuccessText,
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

                // Growth Progress Bar (Gompertz 76%)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Kurva Pertumbuhan (Gompertz)',
                          style: TextStyle(fontSize: 11, color: AppColors.bsSecondary),
                        ),
                        Text(
                          '76% Menuju Matang',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bsPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 9,
                        color: AppColors.bsDarkBorder,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.76,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.bsPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.bsDarkSurface,
                          foregroundColor: AppColors.bsPrimary,
                          side: const BorderSide(color: AppColors.bsDarkBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.query_stats_rounded, size: 18),
                        label: const Text(
                          'Detail & Prediksi AI',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(1);
                          } else {
                            _showCattleDetailModal(context, 'Sapi Karapan Jalu', 342, 450, 0.82);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bsDarkSurface,
                        border: Border.all(color: AppColors.bsDarkBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.scale_rounded, color: AppColors.bsSecondary),
                        onPressed: () => _showWeighingSheet(context, 'Sapi Karapan Jalu', 342.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Card 2: Sapi Sonok Melati
  // ------------------------------------------
  Widget _buildCardMelati(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bsDarkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bsDarkSurface.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              border: const Border(
                bottom: BorderSide(color: AppColors.bsDarkBorder, width: 0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.bsDanger.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.bsDanger.withValues(alpha: 0.45),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '#04',
                        style: TextStyle(
                          color: AppColors.bsDangerText,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sapi Sonok Melati',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bsLight,
                          ),
                        ),
                        Text(
                          'Tag: #MDR-2024-004',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.bsSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bsWarning,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Evaluasi ADG',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bsDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Image + Quick Info
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.bsDarkBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCFIG6jKbyAzKoPqUBf6cwhsAQCuB6wRzvhJkGTHu22BpDSLQpLmPjMX9m1QsGaAdGzy292Lm7YQyuIUu1LfeCFo_2oPJeUcq3BVeFS0Z5YyA99YaQtV-ka6VV4F_DaqWjRKJwVY7Js6vfm4F6XZMl_7ST11b2hYXX3YSSrymwVhaKgTS-4QpZNMngt6Lfk319Yl8AzyyeAkbmwMBUZl4jtPgPlHiyl47BYdf9adq8V',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/sapi_arjuna.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.bsDarkSurface,
                              child: const Icon(Icons.pets, color: AppColors.bsSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Bobot Riil:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '285',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bsLight,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'kg',
                                    style: TextStyle(fontSize: 12, color: AppColors.bsSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'ADG Deviasi:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Text(
                                '-32% dari Standar',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bsDangerText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Gejala Utama:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Text(
                                'Nafsu makan menurun',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.bsDangerText,
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

                // Danger Callout Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bsDangerBg,
                    border: Border.all(color: AppColors.bsDangerBorder, width: 0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.bsDangerText,
                        size: 19,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Bobot stagnan 14 hari berturut-turut. Segera lakukan diagnosa diferensial parasit cacing lambung atau infestasi caplak.',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.bsDangerText,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bsDanger,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 1,
                        ),
                        icon: const Icon(Icons.medical_services_rounded, size: 18),
                        label: const Text(
                          'Buka Triase Pakar AI',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(3, 'MDR-2024-004');
                          } else {
                            _showEmergencyTriageModal(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bsDarkSurface,
                        border: Border.all(color: AppColors.bsDarkBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.videocam_rounded, color: AppColors.bsSecondary),
                        onPressed: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(3, 'MDR-2024-004');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Menghubungkan sesi tele-konsultasi dokter hewan...'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // Card 3: Sapi Pejantan Perkasa
  // ------------------------------------------
  Widget _buildCardPerkasa(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bsDarkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bsDarkSurface.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              border: const Border(
                bottom: BorderSide(color: AppColors.bsDarkBorder, width: 0.8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.bsDarkSurface,
                        border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '#89',
                        style: TextStyle(
                          color: AppColors.bsLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sapi Pejantan Perkasa',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bsLight,
                          ),
                        ),
                        Text(
                          'Tag: #MDR-2023-089',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.bsSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bsDarkSurface,
                    border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Mendekati Panen (H-12)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.bsLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Image + Quick Info
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.bsDarkBorder),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBDpMu_OeUHIN_3vqWT29uJOvEtIx-JSEJVrRk5WSm-9YDZrhTSR_owxsPl8IYxErDxF6G92rF5GDP_e1P4X347ZLdyWRT5_wrzei-JD3ledj9TNmpZAcyoKoozcbv-ejjexywTvWUzKoDhZwf6vNsUse7lFdTkI0pOBUYRU2hcr546vnYHfPh7rGQPiONz_jAvqdy3QgO1LDl5jfuSCOgK7Vkji0xZTXX_ewAdzP01',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'assets/images/sapi_bima.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.bsDarkSurface,
                              child: const Icon(Icons.pets, color: AppColors.bsSecondary),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Bobot Riil:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '438',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.bsLight,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'kg',
                                    style: TextStyle(fontSize: 12, color: AppColors.bsSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Target Pasar:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Text(
                                '450 kg (Sisa 12 kg)',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.bsLight,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Estimasi Nilai:',
                                style: TextStyle(fontSize: 12.5, color: AppColors.bsSecondary),
                              ),
                              Text(
                                'Rp 31.500.000',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.bsSuccessText,
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

                // Kesiapan Karkas Progress Bar (97.3%)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Tingkat Kesiapan Karkas',
                          style: TextStyle(fontSize: 11, color: AppColors.bsSecondary),
                        ),
                        Text(
                          '97.3% Siap',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bsSuccessText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 9,
                        color: AppColors.bsDarkBorder,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.973,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.bsSuccess,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.bsDarkSurface,
                          foregroundColor: AppColors.bsPrimary,
                          side: const BorderSide(color: AppColors.bsDarkBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        icon: const Icon(Icons.monetization_on_rounded, size: 18),
                        label: const Text(
                          'Prospek Pasar & Log Panen',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          if (widget.onNavigateTab != null) {
                            widget.onNavigateTab!(2);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.bsDarkSurface,
                        border: Border.all(color: AppColors.bsDarkBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.assignment_turned_in_rounded, color: AppColors.bsSecondary),
                        onPressed: () => _showCertificateSheet(context, 'Sapi Pejantan Perkasa', '#MDR-2023-089', 438),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. KURVA PERTUMBUHAN GOMPERTZ CARD
  // ==========================================
  Widget _buildGompertzGrowthCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bsDarkCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 2),
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
                  Icon(Icons.analytics_rounded, color: AppColors.bsPrimary, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Model Pertumbuhan Non-Linear',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bsLight,
                    ),
                  ),
                ],
              ),
              const Text(
                'Gompertz-Madura v2.4',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: AppColors.bsSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Custom Painted Trend Line Chart
          Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.bsDarkHeader,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
            ),
            child: Column(
              children: [
                Expanded(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _GompertzNonLinearPainter(),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.only(top: 6),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0x33495057), width: 0.8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Fase Sapih (6 Bln)',
                        style: TextStyle(fontSize: 10.5, color: AppColors.bsSecondary),
                      ),
                      Text(
                        'Muda (12 Bln)',
                        style: TextStyle(fontSize: 10.5, color: AppColors.bsSecondary),
                      ),
                      Text(
                        'Panen Ideal (24 Bln)',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bsLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Metric Snapshot (ADG Kawasan + Akurasi AI)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bsDarkSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.bsDarkBorder.withValues(alpha: 0.6)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rata-rata ADG Kawasan',
                        style: TextStyle(fontSize: 11, color: AppColors.bsSecondary),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '+0.74 kg/hari',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bsLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.bsDarkSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.bsDarkBorder.withValues(alpha: 0.6)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akurasi Prediksi AI',
                        style: TextStyle(fontSize: 11, color: AppColors.bsSecondary),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '94.8% Akurat',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bsSuccessText,
                        ),
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
  // MODALS & SHEETS
  // ==========================================
  void _openNewCattleSheet(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showModalBottomSheet<NewCattleSubmitResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NewCattleInputSheet(),
    );

    if (result != null && mounted) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.bsDarkCard,
          content: Text(
            'Sapi ${result.cattleData.name} (${result.cattleData.tag}) berhasil ditambahkan ke pemantauan paddock!',
            style: const TextStyle(color: AppColors.bsLight),
          ),
        ),
      );
    }
  }

  void _showEmergencyTriageModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bsDarkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.emergency_rounded, color: AppColors.bsDanger, size: 24),
                SizedBox(width: 8),
                Text(
                  'Triase Darurat Dokter Hewan',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bsLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Pusat triage mendeteksi 2 ekor sapi dengan indikasi perlambatan ADG & nafsu makan turun. Lakukan evaluasi klinis:',
              style: TextStyle(fontSize: 13, color: AppColors.bsSecondary),
            ),
            const SizedBox(height: 16),
            ListTile(
              tileColor: AppColors.bsDarkSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.medication_rounded, color: AppColors.bsWarning),
              title: const Text('Protokol Obat Cacing & Parasit', style: TextStyle(color: AppColors.bsLight, fontSize: 14)),
              subtitle: const Text('Albendazole / Ivermectin dosis bobot 285kg', style: TextStyle(color: AppColors.bsSecondary, fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Protokol terapi parasit telah disimpan.')),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: AppColors.bsDarkSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.call_rounded, color: AppColors.bsSuccess),
              title: const Text('Hubungi Tele-Vet Siaga UIM', style: TextStyle(color: AppColors.bsLight, fontSize: 14)),
              subtitle: const Text('Koneksi prioritas via SIP & WhatsApp', style: TextStyle(color: AppColors.bsSecondary, fontSize: 12)),
              onTap: () {
                Navigator.pop(ctx);
                if (widget.onNavigateTab != null) {
                  widget.onNavigateTab!(3, 'MDR-2024-004');
                }
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showDoctorProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bsDarkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bsPrimary, width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuACqnKdqNBYl3q7pgFTSQaxdpcqzbVKNsQDpadniVeiqmJyRhAEO9Uu-z2Fd9ojRCQc1ehGcRSPtTgt3XyPJpOnvQcg6KnHbLU1hXWQIQ1dOAFacicb7vBI1A5ZnKrR-tRjcqGyX8zRg2xjjfoZYX_6ehoTi1Wa1Ly28c3gG-JKZyS5_-O555KXR4uDeLR7w8aZz4SK3tcazLLH0G3RJWc9B6jhED4bZMgQItQ-CxI1',
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: AppColors.bsDarkSurface,
                    child: const Icon(Icons.person, color: AppColors.bsLight, size: 36),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'drh. Ahmad Fauzi, M.Vet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.bsLight,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dokter Hewan Pengawas Wilayah Madura • SIP 35.28/2023',
              style: TextStyle(fontSize: 12, color: AppColors.bsSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bsDarkSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Column(
                    children: [
                      Text('18 Sapi', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.bsLight)),
                      Text('Dipantau', style: TextStyle(fontSize: 11, color: AppColors.bsSecondary)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('99.2%', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.bsSuccessText)),
                      Text('Uptime Telemetri', style: TextStyle(fontSize: 11, color: AppColors.bsSecondary)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Pasean', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.bsLight)),
                      Text('Kawasan', style: TextStyle(fontSize: 11, color: AppColors.bsSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bsPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWeighingSheet(BuildContext context, String cattleName, double currentWeight) {
    final textCtrl = TextEditingController(text: currentWeight.toStringAsFixed(0));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bsDarkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.scale_rounded, color: AppColors.bsPrimary),
                const SizedBox(width: 8),
                Text(
                  'Catat Penimbangan: $cattleName',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bsLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Masukkan hasil timbang riil atau lingkar dada pita Schoorl terbaru:',
              style: TextStyle(fontSize: 12, color: AppColors.bsSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.bsLight, fontWeight: FontWeight.bold, fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.bsDarkSurface,
                labelText: 'Bobot Terbaru (kg)',
                labelStyle: const TextStyle(color: AppColors.bsSecondary),
                suffixText: 'kg',
                suffixStyle: const TextStyle(color: AppColors.bsSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.bsDarkBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.bsDarkBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.bsPrimary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bsPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bobot $cattleName diperbarui ke ${textCtrl.text} kg (Tersinkron TLS).'),
                    ),
                  );
                },
                child: const Text('Simpan Data Timbang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCertificateSheet(BuildContext context, String cattleName, String tag, double weight) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bsDarkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.assignment_turned_in_rounded, color: AppColors.bsSuccessText, size: 24),
                SizedBox(width: 8),
                Text(
                  'Sertifikat Kelayakan & SKKH Ternak',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bsLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bsDarkSurface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nama / Tag:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 12)),
                      Text('$cattleName ($tag)', style: const TextStyle(color: AppColors.bsLight, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bobot Siap Potong:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 12)),
                      Text('${weight.toStringAsFixed(0)} kg', style: const TextStyle(color: AppColors.bsLight, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Status Vaksinasi PMK:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 12)),
                      Text('Lengkap (Dosis 2)', style: TextStyle(color: AppColors.bsSuccessText, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Estimasi Karkas:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 12)),
                      Text('52.4% (SNI Sapi Madura)', style: TextStyle(color: AppColors.bsLight, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bsSuccess,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text('Unduh e-SKKH Resmi (PDF)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mengunduh e-SKKH Resmi ber-QR Code Disnak Jatim...')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bsDarkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Ekspor Laporan Ternak', style: TextStyle(color: AppColors.bsLight, fontSize: 16)),
        content: const Text(
          'Format ringkasan paddock akan diekspor dalam format spreadsheet Excel dan PDF terenkripsi TLS 1.3.',
          style: TextStyle(color: AppColors.bsSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.bsSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bsPrimary),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Laporan paddock_madura_2024.xlsx berhasil diunduh.')),
              );
            },
            child: const Text('Unduh', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCattleDetailModal(BuildContext context, String name, double weight, double target, double adg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bsDarkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.bsLight)),
            const SizedBox(height: 8),
            Text('Bobot Riil: ${weight.toStringAsFixed(0)} kg | Target: ${target.toStringAsFixed(0)} kg', style: const TextStyle(color: AppColors.bsSecondary)),
            Text('Laju ADG: +${adg.toStringAsFixed(2)} kg/hari', style: const TextStyle(color: AppColors.bsSuccessText, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.bsPrimary),
                onPressed: () {
                  Navigator.pop(ctx);
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(1);
                  }
                },
                child: const Text('Buka Kurva Prediksi Lengkap', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// GOMPERTZ NON-LINEAR TREND PAINTER
// ==========================================
class _GompertzNonLinearPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Grid lines (dashed)
    final gridPaint = Paint()
      ..color = const Color(0xFF495057)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    _drawDashedLine(canvas, Offset(0, height * 0.25), Offset(width, height * 0.25), gridPaint);
    _drawDashedLine(canvas, Offset(0, height * 0.62), Offset(width, height * 0.62), gridPaint);

    // Curve trajectory path (Sigmoid / Gompertz shape)
    final path = Path();
    path.moveTo(0, height * 0.92);
    path.cubicTo(
      width * 0.25,
      height * 0.85,
      width * 0.40,
      height * 0.60,
      width * 0.60,
      height * 0.38,
    );
    path.cubicTo(
      width * 0.75,
      height * 0.22,
      width * 0.85,
      height * 0.18,
      width,
      height * 0.16,
    );

    // Gradient fill under curve
    final fillPath = Path.from(path)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0D6EFD).withValues(alpha: 0.25),
          const Color(0xFF0D6EFD).withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // The line itself
    final linePaint = Paint()
      ..color = const Color(0xFF0D6EFD)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Dot 1: Muda point
    final dot1 = Offset(width * 0.40, height * 0.60);
    _drawMarkerDot(canvas, dot1, const Color(0xFF0D6EFD), 4.0);

    // Dot 2: Panen Ideal point
    final dot2 = Offset(width * 0.80, height * 0.20);
    _drawMarkerDot(canvas, dot2, const Color(0xFF198754), 5.0);
  }

  void _drawMarkerDot(Canvas canvas, Offset offset, Color color, double radius) {
    final ringPaint = Paint()
      ..color = const Color(0xFF212529)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(offset, radius, dotPaint);
    canvas.drawCircle(offset, radius, ringPaint);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = p1.dx;
    while (startX < p2.dx) {
      canvas.drawLine(
        Offset(startX, p1.dy),
        Offset(startX + dashWidth < p2.dx ? startX + dashWidth : p2.dx, p1.dy),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
