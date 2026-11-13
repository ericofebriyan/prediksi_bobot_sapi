import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

// ============================================================================
// DATA MODELS FOR TELE-VET CONSULTATION
// ============================================================================

enum MessageSender { doctor, farmer }

enum MessageType { text, eResep, image, telemetry }

class ConsultationMessage {
  final String id;
  final MessageSender sender;
  final MessageType type;
  final String text;
  final String time;
  final bool isDelivered;
  final String? medicineName;
  final String? medicineDose;
  final String? medicineInstruction;
  final String? barcodeCode;
  final String? imageAsset;
  final Map<String, String>? telemetryData;

  ConsultationMessage({
    required this.id,
    required this.sender,
    required this.type,
    required this.text,
    required this.time,
    this.isDelivered = true,
    this.medicineName,
    this.medicineDose,
    this.medicineInstruction,
    this.barcodeCode,
    this.imageAsset,
    this.telemetryData,
  });
}

class CattleContextData {
  final String tag;
  final String name;
  final String triaseLabel;
  final Color triaseColor;
  final Color triaseTextColor;
  final String diagnosisLabel;
  final String doctorName;
  final String doctorSpecialty;
  final double doctorRating;
  final String doctorAvatarUrl;
  final String defaultMedicine;
  final String defaultDose;
  final String defaultInstruction;
  final String rxCode;

  const CattleContextData({
    required this.tag,
    required this.name,
    required this.triaseLabel,
    required this.triaseColor,
    required this.triaseTextColor,
    required this.diagnosisLabel,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorRating,
    required this.doctorAvatarUrl,
    required this.defaultMedicine,
    required this.defaultDose,
    required this.defaultInstruction,
    required this.rxCode,
  });
}

// Preset contexts matching the Dashboard cattle cards
const CattleContextData contextMelati = CattleContextData(
  tag: 'MDR-2024-004',
  name: 'Sapi Sonok Melati',
  triaseLabel: 'Triase Merah',
  triaseColor: AppColors.bsDanger,
  triaseTextColor: Colors.white,
  diagnosisLabel: 'Helmintiasis (CF 0.88)',
  doctorName: 'drh. Aisha Putri, M.Si',
  doctorSpecialty: 'Spesialis Ruminansia Madura',
  doctorRating: 4.9,
  doctorAvatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuACqnKdqNBYl3q7pgFTSQaxdpcqzbVKNsQDpadniVeiqmJyRhAEO9Uu-z2Fd9ojRCQc1ehGcRSPtTgt3XyPJpOnvQcg6KnHbLU1hXWQIQ1dOAFacicb7vBI1A5ZnKrR-tRjcqGyX8zRg2xjjfoZYX_6ehoTi1Wa1Ly28c3gG-JKZyS5_-O555KXR4uDeLR7w8aZz4SK3tcazLLH0G3RJWc9B6jhED4bZMgQItQ-CxI1',
  defaultMedicine: 'Albendazole Bolus 1500mg',
  defaultDose: '1 Bolus / 150 kg BB (Tunggal)',
  defaultInstruction: 'Oral via Konsentrat Sore',
  rxCode: 'RX-MDR-2024-8891',
);

const CattleContextData contextJalu = CattleContextData(
  tag: 'MDR-2024-001',
  name: 'Sapi Karapan Jalu',
  triaseLabel: 'Optimal',
  triaseColor: AppColors.bsSuccess,
  triaseTextColor: Colors.white,
  diagnosisLabel: 'Kondisi Prima (CF 0.95)',
  doctorName: 'drh. Ahmad Fauzi, M.Vet',
  doctorSpecialty: 'Spesialis Stamina & Otot Karapan',
  doctorRating: 4.95,
  doctorAvatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuACqnKdqNBYl3q7pgFTSQaxdpcqzbVKNsQDpadniVeiqmJyRhAEO9Uu-z2Fd9ojRCQc1ehGcRSPtTgt3XyPJpOnvQcg6KnHbLU1hXWQIQ1dOAFacicb7vBI1A5ZnKrR-tRjcqGyX8zRg2xjjfoZYX_6ehoTi1Wa1Ly28c3gG-JKZyS5_-O555KXR4uDeLR7w8aZz4SK3tcazLLH0G3RJWc9B6jhED4bZMgQItQ-CxI1',
  defaultMedicine: 'Calci-Mag Bolus & B-Complex',
  defaultDose: '2 Bolus per Minggu',
  defaultInstruction: 'Oral setelah latihan fisik',
  rxCode: 'RX-MDR-2024-1022',
);

const CattleContextData contextPerkasa = CattleContextData(
  tag: 'MDR-2023-089',
  name: 'Sapi Pejantan Perkasa',
  triaseLabel: 'Mendekati Panen',
  triaseColor: AppColors.bsDarkSurface,
  triaseTextColor: AppColors.bsLight,
  diagnosisLabel: 'Evaluasi Akhir Karkas (CF 0.92)',
  doctorName: 'drh. Siti Nurhaliza, M.Sc',
  doctorSpecialty: 'Spesialis Feedlot & Karkas Daging',
  doctorRating: 4.88,
  doctorAvatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuACqnKdqNBYl3q7pgFTSQaxdpcqzbVKNsQDpadniVeiqmJyRhAEO9Uu-z2Fd9ojRCQc1ehGcRSPtTgt3XyPJpOnvQcg6KnHbLU1hXWQIQ1dOAFacicb7vBI1A5ZnKrR-tRjcqGyX8zRg2xjjfoZYX_6ehoTi1Wa1Ly28c3gG-JKZyS5_-O555KXR4uDeLR7w8aZz4SK3tcazLLH0G3RJWc9B6jhED4bZMgQItQ-CxI1',
  defaultMedicine: 'Sertifikasi Bebas Residu Antibiotik',
  defaultDose: '1 Dokumen Digital Resmi',
  defaultInstruction: 'Verifikasi e-SKKH Disnak Jatim',
  rxCode: 'SKKH-MDR-2023-089',
);

// ============================================================================
// MAIN CONSULTATION SCREEN (TELE-VET MADURA)
// ============================================================================

class ConsultationScreen extends StatefulWidget {
  final String? initialTag;

  const ConsultationScreen({super.key, this.initialTag});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  late CattleContextData _currentCattle;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ConsultationMessage> _messages = [];

  final List<String> _quickResponses = [
    'Siap, obat sudah diberikan',
    'Kirim foto feses terbaru',
    'Update suhu rectal',
  ];

  @override
  void initState() {
    super.initState();
    _initCattleContext();
    _loadInitialChatMessages();
  }

  void _initCattleContext() {
    final tag = widget.initialTag?.toUpperCase() ?? 'MDR-2024-004';
    if (tag.contains('001')) {
      _currentCattle = contextJalu;
    } else if (tag.contains('089')) {
      _currentCattle = contextPerkasa;
    } else {
      _currentCattle = contextMelati;
    }
  }

  void _loadInitialChatMessages() {
    _messages.clear();

    if (_currentCattle.tag == 'MDR-2024-004') {
      _messages.addAll([
        ConsultationMessage(
          id: '1',
          sender: MessageSender.doctor,
          type: MessageType.text,
          text:
              'Halo Pak Erico, saya sudah meninjau grafik deviasi ADG sapi Melati dan hasil Certainty Factor sistem pakar. Feses yang encer mengindikasikan infeksi cacing usus. Segera berikan Albendazole sesuai dosis ya.',
          time: '14:19',
        ),
        ConsultationMessage(
          id: '2',
          sender: MessageSender.farmer,
          type: MessageType.text,
          text:
              'Baik dok, apakah pemberian obat bisa dicampur langsung ke ransum konsentrat basah sore ini?',
          time: '14:21',
          isDelivered: true,
        ),
        ConsultationMessage(
          id: '3',
          sender: MessageSender.doctor,
          type: MessageType.eResep,
          text:
              'Bisa dicampur konsentrat, pastikan habis dihabiskan. Ini saya terbitkan e-Resep resmi.',
          time: '14:24',
          medicineName: _currentCattle.defaultMedicine,
          medicineDose: _currentCattle.defaultDose,
          medicineInstruction: _currentCattle.defaultInstruction,
          barcodeCode: _currentCattle.rxCode,
        ),
      ]);
    } else if (_currentCattle.tag == 'MDR-2024-001') {
      _messages.addAll([
        ConsultationMessage(
          id: '1',
          sender: MessageSender.doctor,
          type: MessageType.text,
          text:
              'Halo Pak Erico, data telemetri Jalu menunjukkan ADG stabil +0.82 kg/hari. Nafsu makan dan refleks lari sangat optimal.',
          time: '10:15',
        ),
        ConsultationMessage(
          id: '2',
          sender: MessageSender.farmer,
          type: MessageType.text,
          text:
              'Alhamdulillah dok. Apakah perlu booster kalsium tambahan sebelum jadwal latihan sabtu ini?',
          time: '10:17',
          isDelivered: true,
        ),
        ConsultationMessage(
          id: '3',
          sender: MessageSender.doctor,
          type: MessageType.eResep,
          text:
              'Cukup tambahkan suplemen elektrolit & mineral rutin ini untuk menjaga kepadatan tulang metakarpal.',
          time: '10:20',
          medicineName: _currentCattle.defaultMedicine,
          medicineDose: _currentCattle.defaultDose,
          medicineInstruction: _currentCattle.defaultInstruction,
          barcodeCode: _currentCattle.rxCode,
        ),
      ]);
    } else {
      _messages.addAll([
        ConsultationMessage(
          id: '1',
          sender: MessageSender.doctor,
          type: MessageType.text,
          text:
              'Selamat siang Pak Erico, bobot riil Perkasa kini sudah 438 kg. Sudah memenuhi standar SNI karkas Madura (52%).',
          time: '11:05',
        ),
        ConsultationMessage(
          id: '2',
          sender: MessageSender.farmer,
          type: MessageType.text,
          text:
              'Terima kasih dok. Mohon verifikasi kelayakan sertifikat e-SKKH untuk pengiriman pasar hewan.',
          time: '11:08',
          isDelivered: true,
        ),
        ConsultationMessage(
          id: '3',
          sender: MessageSender.doctor,
          type: MessageType.eResep,
          text:
              'Hasil uji lab dan pemantauan bebas residu antibiotik sudah selesai. Ini e-SKKH resmi ber-barcode validasi Disnak.',
          time: '11:12',
          medicineName: _currentCattle.defaultMedicine,
          medicineDose: _currentCattle.defaultDose,
          medicineInstruction: _currentCattle.defaultInstruction,
          barcodeCode: _currentCattle.rxCode,
        ),
      ]);
    }
  }

  void _switchCattleContext(CattleContextData contextData) {
    setState(() {
      _currentCattle = contextData;
      _loadInitialChatMessages();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.bsDarkCard,
        content: Text(
          'Beralih ke sesi konsultasi: ${_currentCattle.name} (${_currentCattle.tag})',
          style: const TextStyle(color: AppColors.bsLight),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        ConsultationMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: MessageSender.farmer,
          type: MessageType.text,
          text: text.trim(),
          time: timeStr,
          isDelivered: true,
        ),
      );
    });

    _chatController.clear();
    _scrollToBottom();

    // Auto simulated response from Doctor after 1.2s
    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final replyTime =
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
      setState(() {
        String doctorReply =
            'Baik Pak Erico, catatan telah saya sinkronkan ke log rekam medis ${_currentCattle.name}. Terus pantau feses dan nafsu makan sapi.';
        if (text.toLowerCase().contains('obat')) {
          doctorReply =
              'Pastikan obat diminumkan tuntas sesuai dosis e-Resep. Jika dalam 48 jam belum ada perbaikan, kita jadwalkan kunjungan fisik.';
        } else if (text.toLowerCase().contains('suhu')) {
          doctorReply =
              'Suhu rectal terpantau normal. Lanjutkan pemberian air minum ad libitum bergaram mineral.';
        } else if (text.toLowerCase().contains('foto')) {
          doctorReply =
              'Foto feses telah tervalidasi via AI Vision. Tingkat konsistensi mulai membaik.';
        }

        _messages.add(
          ConsultationMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sender: MessageSender.doctor,
            type: MessageType.text,
            text: doctorReply,
            time: replyTime,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _sendTelemetryData() {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        ConsultationMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: MessageSender.farmer,
          type: MessageType.telemetry,
          text: 'Mengirimkan telemetri sensor ear-tag IoT kandang terkini:',
          time: timeStr,
          telemetryData: {
            'Suhu Tubuh': '38.6 °C (Normal)',
            'Denyut Nadi': '72 bpm',
            'Ruminasi': '420 mnt/hari',
            'Sensor ID': 'BLE-Pasean-04',
          },
        ),
      );
    });

    _scrollToBottom();

    Timer(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      final replyTime =
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
      setState(() {
        _messages.add(
          ConsultationMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sender: MessageSender.doctor,
            type: MessageType.text,
            text:
                'Data telemetri diterima & terenkripsi TLS 1.3. Suhu 38.6°C dan ruminasi aman, tidak terdeteksi demam pada ${_currentCattle.name}.',
            time: replyTime,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _sendImageAttachment() {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add(
        ConsultationMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: MessageSender.farmer,
          type: MessageType.image,
          text: 'Foto dokumentasi kondisi fisik sapi:',
          time: timeStr,
          imageAsset: 'assets/images/sapi_arjuna.jpg',
        ),
      );
    });

    _scrollToBottom();

    Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final replyTime =
          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}';
      setState(() {
        _messages.add(
          ConsultationMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sender: MessageSender.doctor,
            type: MessageType.text,
            text:
                'Foto fisik diterima. Postur gumba dan turgor kulit menunjukkan hidrasi masih terjaga baik.',
            time: replyTime,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ============================================================================
  // BUILD METHOD
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bsDark,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar Header
            _buildTopHeader(context),

            // 2. Chat Conversation View + Context Cards
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  children: [
                    // Doctor Profile Card
                    _buildDoctorProfileCard(context),
                    const SizedBox(height: 10),

                    // Cattle Medical Record Context Card (Tappable to switch)
                    _buildCattleContextCard(context),
                    const SizedBox(height: 12),

                    // Date Stamp Divider
                    _buildDateStamp('Hari ini • 14:18 WIB'),
                    const SizedBox(height: 14),

                    // Messages List
                    ..._messages.map((msg) => _buildMessageItem(msg)),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // 3. Quick Response Chips
            _buildQuickResponseChips(),

            // 4. Bottom Input Bar
            _buildBottomInputBar(context),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 1. TOP HEADER BAR
  // ============================================================================
  Widget _buildTopHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.bsSurfaceDark,
        border: Border(
          bottom: BorderSide(color: AppColors.bsDarkBorder, width: 1.0),
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
          // Tele-Vet Logo
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
                        color: AppColors.bsSuccess.withValues(alpha: 0.25),
                        border: Border.all(
                          color: AppColors.bsSuccess.withValues(alpha: 0.40),
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
                  'Konsultasi Tele Vet',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.bsSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Emergency Button
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _showEmergencyDialog(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bsDanger.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bsDanger.withValues(alpha: 0.3)),
              ),
              child: const Icon(
                Icons.emergency_rounded,
                color: Color(0xFFFF6B6B),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Profile Doctor Avatar
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _showCattleSwitcherSheet(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bsDarkBorder, width: 1.5),
              ),
              child: ClipOval(
                child: Image.network(
                  _currentCattle.doctorAvatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    color: AppColors.bsDarkSurface,
                    child: const Icon(Icons.person, color: AppColors.bsSecondary, size: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 2. DOCTOR PROFILE CARD
  // ============================================================================
  Widget _buildDoctorProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          // Avatar with green online dot
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.bsDarkBorder, width: 1.5),
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    _currentCattle.doctorAvatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: AppColors.bsDarkSurface,
                      child: const Icon(Icons.person, color: AppColors.bsSecondary, size: 30),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                right: 1,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.bsSuccess,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.bsDarkCard, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _currentCattle.doctorName,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: AppColors.bsLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bsSurfaceDark,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.bsWarning, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            _currentCattle.doctorRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bsLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _currentCattle.doctorSpecialty,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.bsSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bsSuccess.withValues(alpha: 0.25),
                        border: Border.all(
                          color: AppColors.bsSuccess.withValues(alpha: 0.40),
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.bsSuccess,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Online',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bsSuccessText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.bsSurfaceDark,
                        border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.lock_rounded, size: 11, color: AppColors.bsSecondary),
                          SizedBox(width: 3),
                          Text(
                            'E2EE TLS 1.3',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColors.bsSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Action Video & Call Buttons
          Column(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _startVideoConsultation(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bsPrimary,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.bsPrimary.withValues(alpha: 0.35),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 19),
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _startPhoneCall(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bsDarkSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.bsDarkBorder),
                  ),
                  child: const Icon(Icons.call_rounded, color: AppColors.bsLight, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 3. CATTLE MEDICAL RECORD CONTEXT CARD
  // ============================================================================
  Widget _buildCattleContextCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showCattleSwitcherSheet(context),
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.bsPrimary.withValues(alpha: 0.2),
                border: Border.all(
                  color: AppColors.bsPrimary.withValues(alpha: 0.4),
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.assignment_rounded,
                color: AppColors.bsPrimaryText,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${_currentCattle.tag} (${_currentCattle.name})',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.bsLight,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _currentCattle.triaseColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currentCattle.triaseLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _currentCattle.triaseTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Diagnosa Sistem Pakar: ',
                        style: TextStyle(fontSize: 11, color: AppColors.bsSecondary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.bsSurfaceDark,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
                        ),
                        child: Text(
                          _currentCattle.diagnosisLabel,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bsLight,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.swap_horiz_rounded, size: 16, color: AppColors.bsSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // 4. CHAT MESSAGES ITEMS
  // ============================================================================
  Widget _buildDateStamp(String label) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.bsDarkCard,
          border: Border.all(color: AppColors.bsDarkBorder, width: 0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w500,
            color: AppColors.bsSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(ConsultationMessage msg) {
    final isFarmer = msg.sender == MessageSender.farmer;

    if (isFarmer) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bsPrimary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                        if (msg.type == MessageType.image && msg.imageAsset != null) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              msg.imageAsset!,
                              width: 180,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        if (msg.type == MessageType.telemetry &&
                            msg.telemetryData != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: msg.telemetryData!.entries.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        e.key,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        e.value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        msg.time,
                        style: const TextStyle(fontSize: 10, color: AppColors.bsSecondary),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.done_all_rounded,
                        size: 13,
                        color: AppColors.bsPrimaryText,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Doctor Message (Left)
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.network(
                _currentCattle.doctorAvatarUrl,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 28,
                  height: 28,
                  color: AppColors.bsDarkSurface,
                  child: const Icon(Icons.person, size: 16, color: AppColors.bsSecondary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.82,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bsDarkCard,
                      border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: const TextStyle(
                            color: AppColors.bsLight,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                        if (msg.type == MessageType.eResep) ...[
                          const SizedBox(height: 10),
                          _buildEResepCard(msg),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      msg.time,
                      style: const TextStyle(fontSize: 10, color: AppColors.bsSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // Embedded e-Resep Card
  Widget _buildEResepCard(ConsultationMessage msg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bsSurfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.medication_rounded, color: AppColors.bsPrimaryText, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'e-Resep Tele-Vet',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bsLight,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.bsSuccess,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Tervalidasi',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0x40495057), height: 1),
          const SizedBox(height: 8),
          _buildResepRow('Obat:', msg.medicineName ?? _currentCattle.defaultMedicine, isBold: true),
          const SizedBox(height: 4),
          _buildResepRow('Dosis:', msg.medicineDose ?? _currentCattle.defaultDose),
          const SizedBox(height: 4),
          _buildResepRow('Pemberian:', msg.medicineInstruction ?? _currentCattle.defaultInstruction),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bsPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 9),
                elevation: 1,
              ),
              icon: const Icon(Icons.receipt_long_rounded, size: 16),
              label: const Text(
                'Lihat Detail Barcode & Tebus',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _showBarcodePrescriptionModal(context, msg),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResepRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.bsSecondary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? Colors.white : const Color(0xFFE0E3E8),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // 5. QUICK RESPONSE CHIPS
  // ============================================================================
  Widget _buildQuickResponseChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: AppColors.bsDark,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _quickResponses.map((text) {
            IconData icon = Icons.check_circle_rounded;
            Color iconColor = AppColors.bsSuccessText;

            if (text.contains('foto')) {
              icon = Icons.photo_camera_rounded;
              iconColor = AppColors.bsPrimaryText;
            } else if (text.contains('suhu')) {
              icon = Icons.device_thermostat_rounded;
              iconColor = AppColors.bsWarning;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (text.contains('foto')) {
                    _sendImageAttachment();
                  } else if (text.contains('suhu')) {
                    _sendMessage(
                        'Update suhu rectal sapi ${_currentCattle.name}: 38.6°C (kondisi turgor stabil).');
                  } else {
                    _sendMessage(text);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.bsDarkCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.bsDarkBorder, width: 0.9),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: iconColor),
                      const SizedBox(width: 6),
                      Text(
                        text,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bsLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ============================================================================
  // 6. BOTTOM INPUT BAR
  // ============================================================================
  Widget _buildBottomInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppColors.bsSurfaceDark,
        border: Border(
          top: BorderSide(color: AppColors.bsDarkBorder, width: 1.0),
        ),
      ),
      child: Row(
        children: [
          // Add Photo
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _sendImageAttachment,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bsDarkCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: const Icon(
                Icons.add_a_photo_rounded,
                color: AppColors.bsSecondary,
                size: 19,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Sensors Telemetry
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _sendTelemetryData,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.bsDarkCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: const Icon(
                Icons.sensors_rounded,
                color: AppColors.bsSecondary,
                size: 19,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Input Text Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.bsDarkCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: TextField(
                controller: _chatController,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                style: const TextStyle(fontSize: 13, color: AppColors.bsLight),
                decoration: const InputDecoration(
                  hintText: 'Ketik pesan konsultasi...',
                  hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF6C757D)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send Button
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => _sendMessage(_chatController.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.bsPrimary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bsPrimary.withValues(alpha: 0.35),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 19),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // 7. INTERACTIVE MODALS & DIALOGS
  // ============================================================================

  void _showCattleSwitcherSheet(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Pilih Rekam Medis Sapi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bsLight,
                  ),
                ),
                Icon(Icons.pets, color: AppColors.bsPrimary, size: 20),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Ganti subjek rekam medis dan dokter spesialis yang berkonsultasi:',
              style: TextStyle(fontSize: 12, color: AppColors.bsSecondary),
            ),
            const SizedBox(height: 16),
            _buildCattleSelectionTile(contextMelati, ctx),
            const SizedBox(height: 8),
            _buildCattleSelectionTile(contextJalu, ctx),
            const SizedBox(height: 8),
            _buildCattleSelectionTile(contextPerkasa, ctx),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCattleSelectionTile(CattleContextData data, BuildContext ctx) {
    final isSelected = _currentCattle.tag == data.tag;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        Navigator.pop(ctx);
        _switchCattleContext(data);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.bsPrimary.withValues(alpha: 0.15)
              : AppColors.bsDarkSurface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.bsPrimary : AppColors.bsDarkBorder,
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: data.triaseColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.assignment_ind_rounded, size: 18, color: data.triaseColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.name} (${data.tag})',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.bsLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${data.doctorName} • ${data.diagnosisLabel}',
                    style: const TextStyle(fontSize: 11, color: AppColors.bsSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: data.triaseColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                data.triaseLabel,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: data.triaseTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBarcodePrescriptionModal(BuildContext context, ConsultationMessage msg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bsDarkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.bsDarkBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'e-Resep Tele-Vet Terverifikasi',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: AppColors.bsLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kode Registrasi: ${msg.barcodeCode ?? _currentCattle.rxCode}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: AppColors.bsPrimaryText,
              ),
            ),
            const SizedBox(height: 16),

            // Barcode Graphic Simulator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      36,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        width: (i % 3 == 0) ? 4 : (i % 2 == 0) ? 2 : 1,
                        height: 48,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${msg.barcodeCode ?? _currentCattle.rxCode} • TEL-VET-SECURE',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Medicine Details Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.bsSurfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.bsDarkBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nama Pasien:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 11.5)),
                      Text('${_currentCattle.name} (${_currentCattle.tag})', style: const TextStyle(color: AppColors.bsLight, fontWeight: FontWeight.bold, fontSize: 11.5)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Obat Rujukan:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 11.5)),
                      Text(msg.medicineName ?? _currentCattle.defaultMedicine, style: const TextStyle(color: AppColors.bsPrimaryText, fontWeight: FontWeight.bold, fontSize: 11.5)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dokter Penerbit:', style: TextStyle(color: AppColors.bsSecondary, fontSize: 11.5)),
                      Text(_currentCattle.doctorName, style: const TextStyle(color: AppColors.bsLight, fontWeight: FontWeight.bold, fontSize: 11.5)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bsSuccess,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.store_mall_directory_rounded, size: 18),
                label: const Text(
                  'Tebus di Apotek Ternak Mitra Pasean',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Barcode resep telah dikirim ke Apotek Mitra Sumber Barokah.'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startVideoConsultation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.bsSurfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.videocam_rounded, color: AppColors.bsPrimary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tele-Konsultasi Video',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.bsLight),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.bsSuccess.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.bsSuccess.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('E2EE TLS 1.3', style: TextStyle(fontSize: 10, color: AppColors.bsSuccessText, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Mock Video Preview Box
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.bsDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.bsDarkBorder),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            _currentCattle.doctorAvatarUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 64,
                              height: 64,
                              color: AppColors.bsDarkSurface,
                              child: const Icon(Icons.person, color: Colors.white, size: 36),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentCattle.doctorName,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Tersambung (01:24) • HD 1080p',
                          style: TextStyle(color: AppColors.bsSuccessText, fontSize: 11),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 60,
                        height: 75,
                        decoration: BoxDecoration(
                          color: AppColors.bsDarkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.bsPrimary, width: 1.5),
                        ),
                        child: const Center(
                          child: Icon(Icons.person, color: AppColors.bsSecondary, size: 24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Call Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppColors.bsDarkSurface),
                    onPressed: () {},
                    icon: const Icon(Icons.mic_rounded, color: Colors.white),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppColors.bsDarkSurface),
                    onPressed: () {},
                    icon: const Icon(Icons.switch_camera_rounded, color: Colors.white),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: AppColors.bsDanger),
                    onPressed: () => Navigator.pop(ctx),
                    icon: const Icon(Icons.call_end_rounded, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPhoneCall(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bsDarkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: const [
            Icon(Icons.phone_in_talk_rounded, color: AppColors.bsSuccess),
            SizedBox(width: 8),
            Text('Panggilan Suara SIP', style: TextStyle(color: AppColors.bsLight, fontSize: 16)),
          ],
        ),
        content: Text(
          'Menghubungi ${_currentCattle.doctorName} (${_currentCattle.doctorSpecialty})...',
          style: const TextStyle(color: AppColors.bsSecondary, fontSize: 13),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bsDanger),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup Panggilan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bsDarkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: const [
            Icon(Icons.emergency_rounded, color: AppColors.bsDanger),
            SizedBox(width: 8),
            Text('Bantuan Darurat Ternak', style: TextStyle(color: AppColors.bsLight, fontSize: 16)),
          ],
        ),
        content: const Text(
          'Hotline Posko Darurat Ruminansia Madura (UIM Pamekasan) siaga 24 jam untuk kasus distokia, bloat akut, atau kecelakaan ternak.',
          style: TextStyle(color: AppColors.bsSecondary, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.bsSecondary)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.bsDanger),
            icon: const Icon(Icons.call, color: Colors.white, size: 16),
            label: const Text('Hubungi 119 Ternak', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menghubungi Satgas Darurat Ruminansia Pamekasan...')),
              );
            },
          ),
        ],
      ),
    );
  }
}
