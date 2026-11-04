import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/cattle_test_data.dart';

class ConsultationScreen extends StatefulWidget {
  final String? initialTag;

  const ConsultationScreen({super.key, this.initialTag});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  int _selectedCattleIndex = 0;

  // Selected clinical symptoms (default matches Figma: Liur berlebih + Kotoran encer)
  final Set<String> _selectedSymptoms = {
    'Liur berlebih',
    'Kotoran encer',
  };

  final List<String> _symptomList = [
    'Nafsu makan turun',
    'Liur berlebih',
    'Kotoran encer',
    'Sapi tampak lemas',
    'Luka celah kuku',
  ];

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
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Beralih ke rekam medis: ${currentCattle.fullName}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleSymptom(String symptom) {
    setState(() {
      if (_selectedSymptoms.contains(symptom)) {
        _selectedSymptoms.remove(symptom);
      } else {
        _selectedSymptoms.add(symptom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cattle = currentCattle;

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

              // 2. Top Badges (Tele-Veteriner Terpadu & Dukungan Lapangan)
              _buildTopBadges(),
              const SizedBox(height: 8),

              // 3. Page Title & Subtitle
              _buildPageTitle(),
              const SizedBox(height: 14),

              // 4. Diagnosis Cepat Mandiri (Sistem Pakar / Edge Rules)
              _buildDiagnosisCepatCard(),
              const SizedBox(height: 16),

              // 5. Direktori Tele-Veteriner
              _buildDirektoriVeterinerSection(context),
              const SizedBox(height: 16),

              // 6. Rekam Medis Terakhir (Relasi Sapi Uji Coba #MD-042 / #MD-039)
              _buildRekamMedisSection(context, cattle),
              const SizedBox(height: 16),

              // 7. Hotline Darurat Dinas Peternakan
              _buildHotlineCard(context),
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
  // 2. TOP BADGES
  // ==========================================
  Widget _buildTopBadges() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'TELE-VETERINER TERPADU',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF065F46),
              letterSpacing: 0.4,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.terracottaBorder,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: const [
              Icon(Icons.circle, size: 6, color: Color(0xFFC2410C)),
              SizedBox(width: 4),
              Text(
                'Dukungan Lapangan',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC2410C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 3. PAGE TITLE & SUBTITLE
  // ==========================================
  Widget _buildPageTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Layanan Dokter Hewan & Pakar Nutrisi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            height: 1.25,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Diagnosis mandiri cepat tanpa sinyal di kandang atau konsultasi langsung dengan dokter hewan Madura.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            height: 1.35,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. DIAGNOSIS CEPAT MANDIRI
  // ==========================================
  Widget _buildDiagnosisCepatCard() {
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
          // Header Card
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF143D2B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Diagnosis Cepat Mandiri',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      'Aturan Pakar + Siap Berfungsi 100% Offline',
                      style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
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
                child: Row(
                  children: const [
                    Icon(Icons.circle, size: 6, color: Color(0xFF059669)),
                    SizedBox(width: 4),
                    Text(
                      'Edge Rules Aktif',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Symptoms Label
          const Text(
            'Pilih Gejala Klinis yang Tampak pada Sapi:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),

          // Symptom Matrix Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _symptomList.map((symptom) {
              final isSelected = _selectedSymptoms.contains(symptom);
              return InkWell(
                onTap: () => _toggleSymptom(symptom),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFFEDD5) : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFED7AA) : const Color(0xFFE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        size: 16,
                        color: isSelected ? const Color(0xFFC2410C) : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        symptom,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? const Color(0xFF78350F) : const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Rekomendasi Otomatis Aturan Pakar Box
          _buildRekomendasiAturanPakarBox(),
        ],
      ),
    );
  }

  Widget _buildRekomendasiAturanPakarBox() {
    String headline;
    String actionSteps;
    String accuracy;

    if (_selectedSymptoms.contains('Luka celah kuku') || _selectedSymptoms.contains('Liur berlebih') && _selectedSymptoms.contains('Sapi tampak lemas')) {
      headline = 'Indikasi Gejala Suspek PMK (Penyakit Mulut & Kuku)';
      actionSteps =
          'Tindakan Cepat Lapangan: Karantina sapi dari kawanan, bersihkan kuku dengan larutan antiseptik/citric acid 2%, dan segera hubungi mantri atau dokter dinas peternakan.';
      accuracy = '96%';
    } else if (_selectedSymptoms.contains('Kotoran encer') && _selectedSymptoms.contains('Nafsu makan turun')) {
      headline = 'Indikasi Gangguan Parasit Saluran Cerna / Cacingan Akut';
      actionSteps =
          'Tindakan Cepat Lapangan: Berikan bolus obat cacing Albendazole, kurangi pakan basah tinggi kadar air, dan sediakan air bersih campur mineral blok.';
      accuracy = '91%';
    } else {
      // Default Figma recommendation
      headline = 'Indikasi Asidosis Ringan akibat proporsi konsentrat ampas tahu/bekatul berlebih.';
      actionSteps =
          'Tindakan Cepat Lapangan: Segera kurangi porsi konsentrat. Berikan hijauan serat kasar (jerami padi kering atau pucuk tebu) dan larutan elektrolit/air gula merah hangat untuk menstabilkan pH rumen.';
      accuracy = '94%';
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFEDD5), width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.lightbulb_outline_rounded, size: 16, color: Color(0xFF9A3412)),
              SizedBox(width: 6),
              Text(
                'Rekomendasi Otomatis Aturan Pakar:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF78350F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            headline,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9A3412),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            actionSteps,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.verified_outlined, size: 14, color: Color(0xFF059669)),
                  SizedBox(width: 4),
                  Text(
                    'Basis Pengetahuan: Balai Veteriner Madura',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              Text(
                'Tingkat Akurasi $accuracy',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9A3412),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. DIREKTORI TELE-VETERINER
  // ==========================================
  Widget _buildDirektoriVeterinerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.medical_services_outlined, size: 16, color: Color(0xFF374151)),
                SizedBox(width: 6),
                Text(
                  'Direktori Tele-Veteriner',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: const [
                  Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                  SizedBox(width: 4),
                  Text(
                    'Online • FastAPI Server',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Doctor 1: drh. Ahmad Fauzi, M.Si
        _buildDoctorCard(
          context: context,
          name: 'drh. Ahmad Fauzi, M.Si',
          imagePath: 'assets/images/doctor_ahmad.jpg',
          specialty: 'Spesialis Ruminansia Besar & Feedlot Madura',
          location: 'RSUD Hewan Bangkalan',
          rating: '4.9',
          consultCount: '124 konsultasi sukses',
          responseTime: 'Respon < 5 mnt',
          statusBadge: 'Siaga',
        ),
        const SizedBox(height: 10),

        // Doctor 2: drh. Siti Nurhaliza
        _buildDoctorCard(
          context: context,
          name: 'drh. Siti Nurhaliza',
          imagePath: 'assets/images/doctor_siti.jpg',
          specialty: 'Pakar Nutrisi & Reproduksi Sapi Madura',
          location: 'Dinas Peternakan Pamekasan',
          rating: '4.8',
          consultCount: '98 konsultasi sukses',
          responseTime: 'Tersedia Tele-Inseminasi',
          statusBadge: 'Siaga',
        ),
      ],
    );
  }

  Widget _buildDoctorCard({
    required BuildContext context,
    required String name,
    required String imagePath,
    required String specialty,
    required String location,
    required String rating,
    required String consultCount,
    required String responseTime,
    required String statusBadge,
  }) {
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 44,
                    height: 44,
                    color: const Color(0xFFF3F4F6),
                    child: const Icon(Icons.person, color: AppColors.forestGreen),
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
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD1FAE5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            statusBadge,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065F46),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      specialty,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563)),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 12, color: Color(0xFF6B7280)),
                        const SizedBox(width: 2),
                        Text(
                          location,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Rating & Response Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 2),
                  Text(
                    rating,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                  ),
                  const Text('  •  ', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 10)),
                  Text(
                    consultCount,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              Text(
                responseTime,
                style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _showChatBottomSheet(context, name);
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 15, color: Color(0xFF374151)),
                  label: const Text(
                    'Konsultasi Chat',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF143D2B),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _showVoiceCallDialog(context, name);
                  },
                  icon: const Icon(Icons.phone_outlined, size: 15),
                  label: const Text(
                    'Panggil Voice',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
  // 6. REKAM MEDIS TERAKHIR (RELASI SAPI FIGMA)
  // ==========================================
  Widget _buildRekamMedisSection(BuildContext context, CattleTestData cattle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Icon(Icons.receipt_long_outlined, size: 16, color: Color(0xFF374151)),
                SizedBox(width: 6),
                Text(
                  'Rekam Medis Terakhir',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: _toggleCattle,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.terracottaBorder,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Text(
                      'Tag: ${cattle.tag}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC2410C),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.swap_horiz_rounded, size: 12, color: Color(0xFFC2410C)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 0.9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cattle.medicalBreedTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    cattle.medicalDate,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                cattle.medicalLocation,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 10),

              // Medicine Treatment Box (Light Green)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1FAE5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_outlined,
                        size: 16,
                        color: Color(0xFF065F46),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cattle.medicalTreatmentTitle,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            cattle.medicalTreatmentDose,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Footer row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 11, color: Color(0xFF4B5563)),
                      children: [
                        const TextSpan(text: 'Jadwal Booster Cacing: '),
                        TextSpan(
                          text: cattle.medicalNextBooster,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111827)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      _showAllMedicalHistorySheet(context, cattle);
                    },
                    child: const Text(
                      'Semua Riwayat >',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9A3412),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 7. HOTLINE DARURAT DINAS PETERNAKAN
  // ==========================================
  Widget _buildHotlineCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF8B3A14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFFFEDD5),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.emergency_rounded,
                color: Color(0xFF9E4717),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hotline Darurat Dinas Peternakan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Siaga Wabah PMK & Kondisi Kritis Madura (24 Jam)',
                  style: TextStyle(fontSize: 10, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F2937),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: const Size(70, 32),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () {
              _showEmergencyHotlineDialog(context);
            },
            icon: const Icon(Icons.call_rounded, size: 14, color: Color(0xFF1F2937)),
            label: const Text(
              'Hubungi',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // MODALS & DIALOGS
  // ==========================================
  void _showChatBottomSheet(BuildContext context, String doctorName) {
    final chatCtrl = TextEditingController();
    final List<Map<String, String>> messages = [
      {
        'sender': doctorName,
        'text': 'Halo Pak Sutrisno! Ada keluhan atau gejala khusus pada sapi feedlot hari ini?',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFD1FAE5),
                        radius: 16,
                        child: Icon(Icons.medical_services_rounded, color: AppColors.forestGreen, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(doctorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const Text('Online • Tele-Veteriner Siaga', style: TextStyle(fontSize: 10, color: Color(0xFF059669))),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 20),

                  // Messages list
                  Container(
                    constraints: const BoxConstraints(maxHeight: 180),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final m = messages[i];
                        final isMe = m['sender'] == 'me';
                        return Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? AppColors.forestGreen : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              m['text']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: isMe ? Colors.white : const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Input box
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Ketik pesan keluhan...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.forestGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (chatCtrl.text.trim().isEmpty) return;
                          final sentText = chatCtrl.text.trim();
                          setModalState(() {
                            messages.add({'sender': 'me', 'text': sentText});
                            chatCtrl.clear();
                          });

                          // Simulasi balasan dokter cepat
                          Future.delayed(const Duration(milliseconds: 600), () {
                            if (context.mounted) {
                              setModalState(() {
                                messages.add({
                                  'sender': doctorName,
                                  'text': 'Baik Pak, segera berikan hijauan segar dan pantau suhu tubuh sapi ya.',
                                });
                              });
                            }
                          });
                        },
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showVoiceCallDialog(BuildContext context, String doctorName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.phone_in_talk_rounded, color: AppColors.forestGreen),
            SizedBox(width: 8),
            Text('Panggilan Suara Tele-Vet', style: TextStyle(fontSize: 15)),
          ],
        ),
        content: Text(
          'Menghubungkan panggilan langsung ke $doctorName melalui jaringan seluler / VoIP Kandang...',
          style: const TextStyle(fontSize: 12, height: 1.4),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.forestGreen),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Memulai panggilan suara ke $doctorName...')),
              );
            },
            child: const Text('Panggil Sekarang'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyHotlineDialog(BuildContext context) {
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
            Row(
              children: const [
                Icon(Icons.emergency_rounded, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Hotline Darurat Dinas Peternakan Madura',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildHotlineContactTile('Posko Siaga PMK Bangkalan', '0812-3456-7890'),
            _buildHotlineContactTile('Puskeswan Pasean Pamekasan', '0852-9876-5432'),
            _buildHotlineContactTile('Balai Veteriner Provinsi Jawa Timur', '(031) 829-1122'),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B3A14)),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotlineContactTile(String title, String phone) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: Color(0xFFFFEDD5),
        child: Icon(Icons.phone_rounded, color: Color(0xFFC2410C), size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      subtitle: Text(phone, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
      trailing: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestGreen,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          minimumSize: const Size(60, 28),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Menghubungi $title ($phone)...')),
          );
        },
        child: const Text('Panggil', style: TextStyle(fontSize: 10)),
      ),
    );
  }

  void _showAllMedicalHistorySheet(BuildContext context, CattleTestData cattle) {
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
            Text(
              'Riwayat Medis Lengkap: ${cattle.fullName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669)),
              title: const Text('Vaksin PMK Dosis 2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('10 Mei 2025 • drh. Ahmad Fauzi • Sehat & Normal', style: TextStyle(fontSize: 11)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669)),
              title: const Text('Pemberian Obat Cacing Albendazole', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('12 Januari 2025 • Mantri Hewan Pasean', style: TextStyle(fontSize: 11)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_rounded, color: Color(0xFF059669)),
              title: const Text('Vaksin PMK Dosis 1 (Bakalan Awal)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('15 Oktober 2024 • Tim Vaksinasi Kab. Bangkalan', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
