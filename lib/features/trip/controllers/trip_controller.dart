import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip_model.dart';
import '../models/trip_member.dart';
import '../repositories/trip_repository.dart';
import '../../auth/controllers/auth_controller.dart';

final tripRepositoryProvider = Provider<ITripRepository>((ref) {
  return SupabaseTripRepository();
});

final userTripsProvider = FutureProvider.autoDispose<List<Trip>>((ref) async {
  final repo = ref.watch(tripRepositoryProvider);
  return repo.getUserTrips();
});

final selectedTripIdProvider = StateProvider<String?>((ref) => null);

final tripDetailsProvider = FutureProvider.family<Trip?, String>((ref, tripId) async {
  final repo = ref.watch(tripRepositoryProvider);
  return repo.getTripById(tripId);
});

final tripMembersProvider = FutureProvider.family<List<TripMember>, String>((ref, tripId) async {
  final repo = ref.watch(tripRepositoryProvider);
  return repo.getTripMembers(tripId);
});

class TripFormState {
  final bool isLoading;
  final String? errorMessage;
  final Trip? createdTrip;

  const TripFormState({
    this.isLoading = false,
    this.errorMessage,
    this.createdTrip,
  });

  TripFormState copyWith({
    bool? isLoading,
    String? errorMessage,
    Trip? createdTrip,
  }) {
    return TripFormState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      createdTrip: createdTrip ?? this.createdTrip,
    );
  }
}

class TripFormController extends StateNotifier<TripFormState> {
  final ITripRepository _repository;
  final Ref _ref;

  TripFormController(this._repository, this._ref) : super(const TripFormState());

  Future<Trip?> createTrip({
    required String title,
    String? description,
    required List<String> destinations,
    required DateTime startDate,
    required DateTime endDate,
    required TripType tripType,
    double? budget,
    String currency = 'USD',
    required int travelersCount,
    required List<String> preferences,
    required TripPace pace,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final currentUser = await _ref.read(currentUserProvider.future);
      final userId = currentUser?.id ?? 'demo-user-123';

      final newTrip = Trip(
        id: 'trip-${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        description: description,
        destinations: destinations,
        startDate: startDate,
        endDate: endDate,
        tripType: tripType,
        budget: budget,
        currency: currency,
        travelersCount: travelersCount,
        preferences: preferences,
        pace: pace,
        createdBy: userId,
        coverImageUrl: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?q=80&w=1200&auto=format&fit=crop',
      );

      final result = await _repository.createTrip(newTrip);
      state = state.copyWith(isLoading: false, createdTrip: result);

      // Invalida la lista de viajes para refrescar la UI
      _ref.invalidate(userTripsProvider);
      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo crear el viaje: ${e.toString()}',
      );
      return null;
    }
  }
}

final tripFormControllerProvider =
    StateNotifierProvider.autoDispose<TripFormController, TripFormState>((ref) {
  final repo = ref.watch(tripRepositoryProvider);
  return TripFormController(repo, ref);
});
