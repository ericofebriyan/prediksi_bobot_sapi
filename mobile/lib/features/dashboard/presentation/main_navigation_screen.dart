import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';
import '../../prediction/presentation/prediction_form_screen.dart';
import '../../consultation/presentation/consultation_screen.dart';
import '../../roi_calculator/presentation/roi_calculator_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _consultationTag = 'MDR-2024-004';

  void _handleNavigateTab(int index, [String? cattleTag]) {
    setState(() {
      _currentIndex = index;
      if (cattleTag != null && cattleTag.isNotEmpty) {
        _consultationTag = cattleTag;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        onNavigateTab: _handleNavigateTab,
      ),
      const PredictionFormScreen(),
      const RoiCalculatorScreen(),
      ConsultationScreen(
        key: ValueKey(_consultationTag),
        initialTag: _consultationTag,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bsDark,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bsDarkHeader,
          border: Border(
            top: BorderSide(
              color: AppColors.bsDarkSurface,
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x4D000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.grid_view_rounded,
                  label: 'Ternak',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.trending_up_rounded,
                  label: 'Prediksi Panen',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.medical_services_rounded,
                  label: 'Sistem Pakar',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.chat_bubble_rounded,
                  label: 'Konsultasi',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppColors.bsPrimary : AppColors.bsSecondary;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        splashColor: AppColors.bsPrimary.withValues(alpha: 0.15),
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: color,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
