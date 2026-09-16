import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/config/env.dart';
import '../data/demo_trip_data.dart';
import '../models/trip_model.dart';
import '../models/trip_member.dart';

abstract class ITripRepository {
  Future<List<Trip>> getUserTrips();
  Future<Trip?> getTripById(String id);
  Future<Trip> createTrip(Trip trip);
  Future<List<TripMember>> getTripMembers(String tripId);
  Future<String> createInviteLink(String tripId, MemberRole role);
}

class SupabaseTripRepository implements ITripRepository {
  final SupabaseClient _client;

  // Cache en memoria para viajes creados durante modo demo o desarrollo
  static final List<Trip> _localTrips = [DemoTripData.rioTrip];

  SupabaseTripRepository([SupabaseClient? client])
      : _client = client ?? Supabase.instance.client;

  @override
  Future<List<Trip>> getUserTrips() async {
    if (!Env.isConfigured) {
      return List.unmodifiable(_localTrips);
    }

    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('trips')
          .select('*, trip_members!inner(user_id)')
          .eq('trip_members.user_id', userId)
          .order('start_date', ascending: true);

      final trips = (response as List).map((json) => Trip.fromJson(json)).toList();
      return trips.isEmpty ? _localTrips : trips;
    } catch (_) {
      return _localTrips;
    }
  }

  @override
  Future<Trip?> getTripById(String id) async {
    if (id == DemoTripData.rioTrip.id) {
      return DemoTripData.rioTrip;
    }

    final localMatch = _localTrips.where((t) => t.id == id).firstOrNull;
    if (localMatch != null) return localMatch;

    if (!Env.isConfigured) return DemoTripData.rioTrip;

    try {
      final response = await _client.from('trips').select().eq('id', id).maybeSingle();
      if (response != null) {
        return Trip.fromJson(response);
      }
    } catch (_) {}

    return null;
  }

  @override
  Future<Trip> createTrip(Trip trip) async {
    if (!Env.isConfigured) {
      _localTrips.insert(0, trip);
      return trip;
    }

    try {
      final data = trip.toJson();
      data.remove('id'); // Generado por PostgreSQL UUID

      final response = await _client.from('trips').insert(data).select().single();
      final newTrip = Trip.fromJson(response);

      // Insertar al creador como Owner en trip_members
      await _client.from('trip_members').insert({
        'trip_id': newTrip.id,
        'user_id': newTrip.createdBy,
        'role': 'owner',
      });

      return newTrip;
    } catch (e) {
      // Fallback local seguro
      _localTrips.insert(0, trip);
      return trip;
    }
  }

  @override
  Future<List<TripMember>> getTripMembers(String tripId) async {
    if (tripId == DemoTripData.rioTrip.id || !Env.isConfigured) {
      return DemoTripData.members;
    }

    try {
      final response = await _client
          .from('trip_members')
          .select('*, profiles(full_name, avatar_url)')
          .eq('trip_id', tripId);

      return (response as List).map((json) => TripMember.fromJson(json)).toList();
    } catch (_) {
      return DemoTripData.members;
    }
  }

  @override
  Future<String> createInviteLink(String tripId, MemberRole role) async {
    final token = 'triply-inv-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}';
    return 'https://triply.app/invite?token=$token';
  }
}
