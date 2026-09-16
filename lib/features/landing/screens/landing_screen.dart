import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/config/app_constants.dart';
import '../../../app/config/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../trip/data/demo_trip_data.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 860;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Barra de Navegación Superior
            _buildNavbar(context, isDesktop),

            // Hero Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 64 : 24,
                vertical: isDesktop ? 60 : 36,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: [
                    // Badge de novedad
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text(
                            'El sistema operativo del viaje grupal potenciado con IA',
                            style: TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Headline
                    Text(
                      'Todo tu viaje.\nEn un solo lugar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isDesktop ? 56 : 36,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        height: 1.15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Subheadline
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Text(
                        AppConstants.appSubheadline,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 15,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Call To Actions (Principal y Demo)
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        AppButton(
                          label: 'Crear mi viaje',
                          icon: Icons.add_circle_outline,
                          onPressed: () => context.go('/create-trip'),
                        ),
                        AppButton(
                          label: 'Explorar demo',
                          icon: Icons.play_arrow_outlined,
                          isSecondary: true,
                          onPressed: () => context.go('/trip/${DemoTripData.rioTrip.id}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),

                    // Mockup / Preview Visual del Viaje
                    _buildHeroAppPreview(context, isDesktop),
                  ],
                ),
              ),
            ),

            // Features Grid (Itinerario, Mapa, Participantes, IA, Gastos, Fotos, Checklist)
            _buildFeaturesSection(context, isDesktop),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildNavbar(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.surfaceLight, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Triply',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => context.go('/trip/${DemoTripData.rioTrip.id}'),
                child: const Text('Ver Demo', style: TextStyle(color: AppColors.textSecondary)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.surfaceLight),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAppPreview(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceLight, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Browser / App Header bar simulado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF151E2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'triply.app/trip/rio-con-amigos-2027',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dashboard Mockup Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Río de Janeiro con amigos 🌴',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '14 Ene - 21 Ene 2027 • 4 viajeros • Presupuesto \$3,200 USD',
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.primary, size: 14),
                          SizedBox(width: 6),
                          Text('Trip AI Conectada', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.surfaceLight),
                const SizedBox(height: 20),

                // 3 Cards del mockup
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _buildPreviewCard(
                      icon: Icons.flight_takeoff,
                      color: AppColors.primary,
                      title: 'Vuelo Latam LA8000',
                      detail: 'EZE -> GIG • Jue 14 Ene, 07:30',
                    ),
                    _buildPreviewCard(
                      icon: Icons.hotel,
                      color: AppColors.secondary,
                      title: 'Hotel Arena Ipanema',
                      detail: '7 noches • Vista al mar confirmada',
                    ),
                    _buildPreviewCard(
                      icon: Icons.savings,
                      color: AppColors.accent,
                      title: 'Gastos divididos',
                      detail: 'Juan pagó \$820 • Todos al día',
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

  Widget _buildPreviewCard({
    required IconData icon,
    required Color color,
    required String title,
    required String detail,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, bool isDesktop) {
    final features = [
      {
        'icon': Icons.view_timeline,
        'title': 'Itinerario Colaborativo',
        'desc': 'Construyan el plan día por día. Muevan, organicen y voten qué hacer en tiempo real.',
      },
      {
        'icon': Icons.map,
        'title': 'Mapa Integrado',
        'desc': 'Todas las reservas y actividades geolocalizadas. Nunca más desvíos innecesarios.',
      },
      {
        'icon': Icons.group,
        'title': 'Colaboración sin Caos',
        'desc': 'Roles claros, invitaciones por enlace y sincronización inmediata entre web y celular.',
      },
      {
        'icon': Icons.auto_awesome,
        'title': 'Trip AI Contextual',
        'desc': 'Asistente que conoce todo el contexto del viaje. Preguntale qué falta reservar o armá planes.',
      },
      {
        'icon': Icons.savings,
        'title': 'División de Gastos',
        'desc': 'Registrá pagos, dividí en partes iguales o porcentajes y sabé exactamente quién le debe a quién.',
      },
      {
        'icon': Icons.checklist,
        'title': 'Checklist Grupal',
        'desc': 'Equipaje, seguro, documentos y compras con asignación individual de responsables.',
      },
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 24,
        vertical: 60,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceLight, width: 0.5)),
      ),
      child: Column(
        children: [
          const Text(
            'El diferencial de Triply',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No es solo un planner: es el centro de comando para tu grupo de viaje.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: features.map((f) {
                return SizedBox(
                  width: isDesktop ? 330 : double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.surfaceLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(f['icon'] as IconData, color: AppColors.primary, size: 28),
                        const SizedBox(height: 16),
                        Text(
                          f['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          f['desc'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: const Text(
        '© 2027 Triply. Construido para viajar en equipo.',
        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
    );
  }
}
