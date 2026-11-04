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

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(
        onNavigateTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const PredictionFormScreen(),
      const RoiCalculatorScreen(),
      const ConsultationScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFE5E7EB).withValues(alpha: 0.8),
              width: 0.8,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          indicatorColor: _currentIndex == 1
              ? AppColors.terracottaBorder
              : AppColors.forestGreen.withValues(alpha: 0.12),
          backgroundColor: Colors.white,
          elevation: 0,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined, size: 22),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.forestGreen, size: 22),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.flare_outlined, size: 22),
              selectedIcon: Icon(Icons.flare_rounded, color: AppColors.terracotta, size: 22),
              label: 'Prediksi AI',
            ),
            NavigationDestination(
              icon: Icon(Icons.insert_chart_outlined_rounded, size: 22),
              selectedIcon: Icon(Icons.insert_chart_rounded, color: AppColors.forestGreen, size: 22),
              label: 'Finansial & ROI',
            ),
            NavigationDestination(
              icon: Icon(Icons.medical_services_outlined, size: 22),
              selectedIcon: Icon(Icons.medical_services_rounded, color: AppColors.forestGreen, size: 22),
              label: 'Dokter Hewan',
            ),
          ],
        ),
      ),
    );
  }
}
