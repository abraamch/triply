import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/config/theme/app_colors.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/loading_state.dart';
import '../controllers/trip_controller.dart';
import '../data/demo_trip_data.dart';
import '../models/trip_model.dart';
import '../models/trip_member.dart';

class TripDashboardScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripDashboardScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDashboardScreen> createState() => _TripDashboardScreenState();
}

class _TripDashboardScreenState extends ConsumerState<TripDashboardScreen> {
  int _currentNavIndex = 0;

  void _showAiDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Trip AI Assistant', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: const Text(
          'Hola, soy el asistente inteligente de tu viaje. Conozco el itinerario, reservas, gastos y participantes de este viaje.\n\n'
          'En la Fase 3 podrás hacerme preguntas como:\n'
          '• "¿Qué tenemos planeado para mañana?"\n'
          '• "¿Cuánto llevamos gastado hasta hoy?"\n'
          '• "¿Qué nos falta reservar?"',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Entendido', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.person_add_outlined, color: AppColors.primary),
            SizedBox(width: 10),
            Text('Invitar Amigos', style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Compartí este enlace con tus amigos para que se unan como editores del viaje:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.surfaceLight),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'https://triply.app/invite?token=triply-rio-2027',
                      style: TextStyle(color: AppColors.primaryLight, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enlace copiado al portapapeles')),
                      );
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  void _showQuickAddBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Agregar al Viaje',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.event_note, color: AppColors.primary),
                  title: const Text('Actividad o Evento', style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('Sumar un hito al itinerario', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.confirmation_number, color: AppColors.secondary),
                  title: const Text('Reserva', style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('Vuelo, hotel, traslado o restaurante', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.receipt_long, color: AppColors.accent),
                  title: const Text('Gasto', style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('Registrar compra y dividir el saldo', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  onTap: () => Navigator.pop(ctx),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: Colors.purpleAccent),
                  title: const Text('Foto o Recuerdo', style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('Subir momento a la memoria grupal', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailsProvider(widget.tripId));
    final membersAsync = ref.watch(tripMembersProvider(widget.tripId));

    return tripAsync.when(
      loading: () => const Scaffold(body: LoadingState(message: 'Cargando viaje...')),
      error: (err, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error al cargar viaje: $err'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
      data: (trip) {
        final currentTrip = trip ?? DemoTripData.rioTrip;
        final members = membersAsync.value ?? DemoTripData.members;

        return AdaptiveScaffold(
          tripTitle: currentTrip.title,
          currentIndex: _currentNavIndex,
          onIndexChanged: (idx) => setState(() => _currentNavIndex = idx),
          onAiPressed: () => _showAiDialog(context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () => _showQuickAddBottomSheet(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: _buildDashboardContent(context, currentTrip, members),
        );
      },
    );
  }

  Widget _buildDashboardContent(BuildContext context, Trip trip, List<TripMember> members) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return CustomScrollView(
      slivers: [
        // App Bar con Banner del Viaje
        SliverAppBar(
          expandedHeight: isDesktop ? 260 : 200,
          pinned: true,
          backgroundColor: AppColors.surface,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            title: Text(
              trip.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 8)],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (trip.coverImageUrl != null)
                  Image.network(
                    trip.coverImageUrl!,
                    fit: BoxFit.cover,
                  )
                else
                  Container(color: AppColors.surfaceLight),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withOpacity(0.85),
                        AppColors.background,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined, color: Colors.white),
              tooltip: 'Invitar amigos',
              onPressed: () => _showInviteDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () => _showInviteDialog(context),
            ),
          ],
        ),

        // Cuerpo del Dashboard
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 40 : 20,
            vertical: 24,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Fila Resumen: Fechas, Destinos y Viajeros
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildBadge(
                    Icons.date_range,
                    '${dateFormat.format(trip.startDate)} - ${dateFormat.format(trip.endDate)} (${trip.durationDays} días)',
                  ),
                  _buildBadge(
                    Icons.place,
                    trip.destinations.join(' • '),
                  ),
                  _buildBadge(
                    Icons.group,
                    '${trip.travelersCount} viajeros (${trip.tripType.label})',
                  ),
                  _buildBadge(
                    Icons.speed,
                    'Ritmo: ${trip.pace.label}',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Botón destacado móvil: Preguntarle a la IA
              if (!isDesktop) ...[
                InkWell(
                  onTap: () => _showAiDialog(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preguntarle a la IA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Conoce vuelos, reservas, presupuesto y planes',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Participantes del viaje
              _buildSectionTitle(
                title: 'Participantes (${members.length})',
                actionLabel: '+ Invitar',
                onAction: () => _showInviteDialog(context),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: members.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, idx) {
                    final member = members[idx];
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.2),
                          foregroundColor: AppColors.primary,
                          child: Text(
                            member.fullName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              member.fullName,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              member.role.label,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Alerta de Próximo Evento / Hito
              _buildSectionTitle(title: 'Próximo Evento'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vuelo Latam LA8000 (EZE -> GIG)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Jueves 14 Ene • 07:30 - 10:45 • Aeropuerto Galeão',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Presupuesto y Gastos Resumen
              _buildSectionTitle(title: 'Control de Presupuesto'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Presupuesto Total',
                      value: '\$${trip.budget?.toStringAsFixed(0) ?? "0"} ${trip.currency}',
                      icon: Icons.savings_outlined,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Gastado hasta hoy',
                      value: '\$1,120 ${trip.currency}',
                      icon: Icons.receipt_long_outlined,
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Itinerario Destacado (Eventos Demo)
              _buildSectionTitle(
                title: 'Itinerario Rápido',
                actionLabel: 'Ver todo el plan',
                onAction: () => setState(() => _currentNavIndex = 1),
              ),
              const SizedBox(height: 12),
              ...DemoTripData.demoEvents.take(3).map((event) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.surfaceLight),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          event['category'] == 'flight'
                              ? Icons.flight
                              : event['category'] == 'hotel'
                                  ? Icons.hotel
                                  : Icons.attractions,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${event['day']} • ${event['time']}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${event['cost']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 40),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle({
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (actionLabel != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
