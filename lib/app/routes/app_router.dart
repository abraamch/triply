import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/landing/screens/landing_screen.dart';
import '../../features/trip/data/demo_trip_data.dart';
import '../../features/trip/screens/create_trip_screen.dart';
import '../../features/trip/screens/trip_dashboard_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/create-trip',
      name: 'create-trip',
      builder: (context, state) => const CreateTripScreen(),
    ),
    GoRoute(
      path: '/trip/:id',
      name: 'trip-dashboard',
      builder: (context, state) {
        final tripId = state.pathParameters['id'] ?? DemoTripData.rioTrip.id;
        return TripDashboardScreen(tripId: tripId);
      },
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      redirect: (context, state) => '/trip/${DemoTripData.rioTrip.id}',
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Página no encontrada', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Ir al inicio'),
          ),
        ],
      ),
    ),
  ),
);
