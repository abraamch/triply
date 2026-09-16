import 'package:flutter/material.dart';
import '../../app/config/theme/app_colors.dart';

/// Define los destinos de navegación para Mobile y Web
class NavDestination {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const NavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.route,
  });
}

/// AdaptiveScaffold conmuta inteligentemente entre:
/// - Móvil (< 800px): BottomNavigationBar con 5 tabs (Viaje, Plan, Mapa, Gastos, Más)
/// - Web / Desktop (>= 800px): Sidebar elegante a la izquierda con acceso directo a todos los módulos
class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final String tripTitle;
  final VoidCallback? onAiPressed;
  final Widget? floatingActionButton;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onIndexChanged,
    this.tripTitle = 'Triply',
    this.onAiPressed,
    this.floatingActionButton,
  });

  // 5 Pestañas Móvil según especificación: VIAJE, PLAN, MAPA, GASTOS, MÁS
  static const List<NavDestination> mobileDestinations = [
    NavDestination(
      label: 'Viaje',
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      route: '/trip',
    ),
    NavDestination(
      label: 'Plan',
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_today,
      route: '/plan',
    ),
    NavDestination(
      label: 'Mapa',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map,
      route: '/map',
    ),
    NavDestination(
      label: 'Gastos',
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      route: '/expenses',
    ),
    NavDestination(
      label: 'Más',
      icon: Icons.menu_outlined,
      selectedIcon: Icons.menu,
      route: '/more',
    ),
  ];

  // Sidebar Desktop según especificación
  static const List<NavDestination> desktopDestinations = [
    NavDestination(
      label: 'Viaje',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      route: '/trip',
    ),
    NavDestination(
      label: 'Itinerario',
      icon: Icons.view_timeline_outlined,
      selectedIcon: Icons.view_timeline,
      route: '/plan',
    ),
    NavDestination(
      label: 'Mapa',
      icon: Icons.map_outlined,
      selectedIcon: Icons.map,
      route: '/map',
    ),
    NavDestination(
      label: 'Reservas',
      icon: Icons.confirmation_number_outlined,
      selectedIcon: Icons.confirmation_number,
      route: '/reservations',
    ),
    NavDestination(
      label: 'Actividades',
      icon: Icons.local_activity_outlined,
      selectedIcon: Icons.local_activity,
      route: '/activities',
    ),
    NavDestination(
      label: 'Gastos',
      icon: Icons.savings_outlined,
      selectedIcon: Icons.savings,
      route: '/expenses',
    ),
    NavDestination(
      label: 'Checklist',
      icon: Icons.checklist_outlined,
      selectedIcon: Icons.checklist,
      route: '/checklist',
    ),
    NavDestination(
      label: 'Documentos',
      icon: Icons.folder_open_outlined,
      selectedIcon: Icons.folder_open,
      route: '/documents',
    ),
    NavDestination(
      label: 'Recuerdos',
      icon: Icons.photo_library_outlined,
      selectedIcon: Icons.photo_library,
      route: '/memories',
    ),
    NavDestination(
      label: 'Configuración',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            // Sidebar Desktop Premium
            Container(
              width: 260,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  right: BorderSide(color: AppColors.surfaceLight, width: 1),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Logo y Marca
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Triply',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              tripTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón destacado de IA en Web
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: onAiPressed,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.secondary],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Preguntarle a la IA',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppColors.surfaceLight, height: 1),
                  const SizedBox(height: 8),

                  // Lista de navegación desktop
                  Expanded(
                    child: ListView.builder(
                      itemCount: desktopDestinations.length,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemBuilder: (context, index) {
                        final item = desktopDestinations[index];
                        final isSelected = index == currentIndex;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ListTile(
                            dense: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            tileColor: isSelected
                                ? AppColors.primary.withOpacity(0.12)
                                : Colors.transparent,
                            leading: Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                              size: 20,
                            ),
                            title: Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () => onIndexChanged(index),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Área Principal de Contenido
            Expanded(child: body),
          ],
        ),
      );
    }

    // Móvil: Bottom Navigation Bar + FAB
    return Scaffold(
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex < mobileDestinations.length ? currentIndex : 0,
        onDestinationSelected: onIndexChanged,
        destinations: mobileDestinations.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon, color: AppColors.primary),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
