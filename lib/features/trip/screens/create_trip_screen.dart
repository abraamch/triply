import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/config/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/trip_controller.dart';
import '../models/trip_model.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Viaje a Brasil');
  final _destinationInputController = TextEditingController();
  final _budgetController = TextEditingController();

  final List<String> _destinations = ['Río de Janeiro'];
  DateTime _startDate = DateTime.now().add(const Duration(days: 30));
  DateTime _endDate = DateTime.now().add(const Duration(days: 37));

  TripType _selectedTripType = TripType.friends;
  String _selectedCurrency = 'USD';
  int _travelersCount = 4;
  TripPace _selectedPace = TripPace.balanced;

  final List<String> _availablePreferences = [
    'Playa',
    'Gastronomía',
    'Cultura',
    'Naturaleza',
    'Aventura',
    'Fiesta',
    'Compras',
    'Descanso',
    'Fotografía',
    'Deportes',
    'Mixto'
  ];
  final Set<String> _selectedPreferences = {'Playa', 'Gastronomía', 'Descanso'};

  @override
  void dispose() {
    _titleController.dispose();
    _destinationInputController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _addDestination() {
    final text = _destinationInputController.text.trim();
    if (text.isNotEmpty && !_destinations.contains(text)) {
      setState(() {
        _destinations.add(text);
        _destinationInputController.clear();
      });
    }
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_destinations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregá al menos un destino')),
      );
      return;
    }

    final double? budget = _budgetController.text.isNotEmpty
        ? double.tryParse(_budgetController.text.replaceAll(',', '.'))
        : null;

    final created = await ref.read(tripFormControllerProvider.notifier).createTrip(
          title: _titleController.text.trim(),
          destinations: _destinations,
          startDate: _startDate,
          endDate: _endDate,
          tripType: _selectedTripType,
          budget: budget,
          currency: _selectedCurrency,
          travelersCount: _travelersCount,
          preferences: _selectedPreferences.toList(),
          pace: _selectedPace,
        );

    if (created != null && mounted) {
      // En modo demo el repositorio puede devolver el demo trip directamente
      context.go('/trip/${created.id}');
    } else if (mounted) {
      // Fallback: si no se pudo crear, muestra snackbar de error
      final tripState = ref.read(tripFormControllerProvider);
      if (tripState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tripState.errorMessage!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripFormControllerProvider);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Nuevo Viaje', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del viaje
                  const Text(
                    'Nombre del viaje',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Ej: Escapada a Río con amigos',
                      prefixIcon: Icon(Icons.travel_explore),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Ingresá un nombre para el viaje' : null,
                  ),
                  const SizedBox(height: 24),

                  // Destinos
                  const Text(
                    'Destinos',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _destinationInputController,
                          onSubmitted: (_) => _addDestination(),
                          decoration: const InputDecoration(
                            hintText: 'Escribí una ciudad o país y tocá +',
                            prefixIcon: Icon(Icons.place_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: AppColors.primary),
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addDestination,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _destinations.map((dest) {
                      return Chip(
                        label: Text(dest, style: const TextStyle(color: Colors.white, fontSize: 13)),
                        backgroundColor: AppColors.surfaceLight,
                        deleteIconColor: AppColors.textSecondary,
                        onDeleted: () => setState(() => _destinations.remove(dest)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Fechas
                  const Text(
                    'Fechas del viaje',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDateRange,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.surfaceLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.date_range, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text(
                            '${dateFormat.format(_startDate)}  —  ${dateFormat.format(_endDate)} '
                            '(${_endDate.difference(_startDate).inDays + 1} días)',
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          const Text('Cambiar', style: TextStyle(color: AppColors.primary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tipo de viaje
                  const Text(
                    'Tipo de viaje',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: TripType.values.map((type) {
                      final isSelected = _selectedTripType == type;
                      return ChoiceChip(
                        label: Text(type.label),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedTripType = type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Presupuesto y Moneda
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Presupuesto estimado (opcional)',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _budgetController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Ej: 3000',
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Moneda',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedCurrency,
                              dropdownColor: AppColors.surface,
                              decoration: const InputDecoration(),
                              items: ['USD', 'EUR', 'ARS', 'BRL', 'MXN'].map((c) {
                                return DropdownMenuItem(value: c, child: Text(c));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedCurrency = val);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Cantidad de viajeros
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cantidad de viajeros',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Podrás invitar a los demás luego con un link',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.surfaceLight),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _travelersCount > 1
                                  ? () => setState(() => _travelersCount--)
                                  : null,
                            ),
                            Text(
                              '$_travelersCount',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _travelersCount++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Preferencias
                  const Text(
                    'Preferencias del grupo',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availablePreferences.map((pref) {
                      final isSelected = _selectedPreferences.contains(pref);
                      return FilterChip(
                        label: Text(pref),
                        selected: isSelected,
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedPreferences.add(pref);
                            } else {
                              _selectedPreferences.remove(pref);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Ritmo del viaje
                  const Text(
                    'Ritmo del viaje',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: TripPace.values.map((pace) {
                      final isSelected = _selectedPace == pace;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => setState(() => _selectedPace = pace),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    pace == TripPace.relaxed
                                        ? Icons.spa_outlined
                                        : pace == TripPace.balanced
                                            ? Icons.balance_outlined
                                            : Icons.bolt_outlined,
                                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    pace.label,
                                    style: TextStyle(
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 36),

                  // Botón Final
                  AppButton(
                    label: 'Crear Viaje',
                    icon: Icons.check,
                    isLoading: state.isLoading,
                    width: double.infinity,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
