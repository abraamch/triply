import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../app/config/env.dart';
import '../models/user_profile.dart';

abstract class IAuthRepository {
  Stream<UserProfile?> authStateChanges();
  Future<UserProfile?> getCurrentUser();
  Future<UserProfile> signInWithEmailPassword(String email, String password);
  Future<UserProfile> signUpWithEmailPassword(String email, String password, String fullName);
  Future<void> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class SupabaseAuthRepository implements IAuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository([SupabaseClient? client])
      : _client = client ?? Supabase.instance.client;

  @override
  Stream<UserProfile?> authStateChanges() {
    if (!Env.isConfigured) {
      // Stream local simulado si Supabase aún no tiene credenciales
      return Stream.value(
        const UserProfile(
          id: 'demo-user-123',
          email: 'demo@triply.app',
          fullName: 'Juan Pérez (Demo)',
        ),
      );
    }

    return _client.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      if (user == null) return null;
      return UserProfile(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] as String? ?? 'Viajero',
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    });
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    if (!Env.isConfigured) {
      return const UserProfile(
        id: 'demo-user-123',
        email: 'demo@triply.app',
        fullName: 'Juan Pérez (Demo)',
      );
    }

    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final res = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
      if (res != null) {
        return UserProfile.fromJson(res);
      }
    } catch (_) {}

    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String? ?? 'Viajero',
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  @override
  Future<UserProfile> signInWithEmailPassword(String email, String password) async {
    if (!Env.isConfigured) {
      return UserProfile(
        id: 'demo-user-123',
        email: email,
        fullName: 'Usuario Demo',
      );
    }

    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user!;
    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String? ?? 'Viajero',
    );
  }

  @override
  Future<UserProfile> signUpWithEmailPassword(
      String email, String password, String fullName) async {
    if (!Env.isConfigured) {
      return UserProfile(
        id: 'demo-user-123',
        email: email,
        fullName: fullName,
      );
    }

    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    final user = response.user!;
    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: fullName,
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    if (!Env.isConfigured) return;
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'https://abraamch.github.io/triply/',
    );
  }

  @override
  Future<void> signOut() async {
    if (!Env.isConfigured) return;
    await _client.auth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    if (!Env.isConfigured) return;
    await _client.auth.resetPasswordForEmail(email);
  }
}
