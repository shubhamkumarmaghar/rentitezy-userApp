
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/home/home_view/home_screen.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/ticket/view/tickets_list_screen.dart';

import '../../utils/const/appConfig.dart';
import '../../wishlist/wishlist_screen.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      builder: (controller) {
        return Scaffold(
          body: getDashboardBody(context, controller.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            onTap: (value) => controller.setIndex(value),
            currentIndex: controller.selectedIndex,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            items: barItemsList(selectedIndex: controller.selectedIndex),
          ),
        );
      },
    );
  }

  Widget getDashboardBody(BuildContext context, int index) {
    if (index == 0) {
      return MyHomePage();
    } else if (index == 1) {
      return const WishlistScreen();
    } else if (index == 2) {
      return const TicketsListScreen();
    } else {
      return const Text('RentsEasy');
    }
  }

  List<BottomNavigationBarItem> barItemsList({required int selectedIndex}) {
    return [
      barItem(icon: Icons.home, label: 'Home', selected: selectedIndex == 0),
      barItem(icon: Icons.favorite_border, label: 'Wishlist', selected: selectedIndex == 1),
      barItem(icon: Icons.add_chart_sharp, label: 'Tickets', selected: selectedIndex == 2),
    ];
  }

  BottomNavigationBarItem barItem({required IconData icon, required String label, required bool selected}) {
    return BottomNavigationBarItem(
      icon: CircleAvatar(
        backgroundColor: selected ? Constants.primaryColor : CustomTheme.appThemeContrast.withOpacity(0.2),
        child: Icon(
          icon,
          size: 24,
          color: selected ? Colors.white : CustomTheme.appThemeContrast.withOpacity(0.8),
        ),
      ),
      label: label,
    );
  }
}
