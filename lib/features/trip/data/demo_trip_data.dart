import '../models/trip_model.dart';
import '../models/trip_member.dart';

class DemoTripData {
  static final Trip rioTrip = Trip(
    id: 'demo-rio-2027',
    title: 'Río de Janeiro con amigos 🌴',
    description: 'Semana de playa, atardeceres en Ipanema, visitas culturales y caipirinhas.',
    destinations: ['Río de Janeiro, Brasil', 'Copacabana', 'Ipanema'],
    startDate: DateTime(2027, 1, 14),
    endDate: DateTime(2027, 1, 21),
    tripType: TripType.friends,
    budget: 3200.0,
    currency: 'USD',
    travelersCount: 4,
    preferences: ['playa', 'gastronomía', 'naturaleza', 'fiesta', 'fotografía'],
    pace: TripPace.balanced,
    coverImageUrl: 'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?q=80&w=1200&auto=format&fit=crop',
    createdBy: 'demo-user-123',
  );

  static final List<TripMember> members = [
    TripMember(
      id: 'm1',
      tripId: 'demo-rio-2027',
      userId: 'demo-user-123',
      role: MemberRole.owner,
      fullName: 'Juan Pérez (Tú)',
      joinedAt: DateTime(2026, 12, 1),
    ),
    TripMember(
      id: 'm2',
      tripId: 'demo-rio-2027',
      userId: 'u2',
      role: MemberRole.editor,
      fullName: 'María González',
      joinedAt: DateTime(2026, 12, 2),
    ),
    TripMember(
      id: 'm3',
      tripId: 'demo-rio-2027',
      userId: 'u3',
      role: MemberRole.editor,
      fullName: 'Lucas Rodríguez',
      joinedAt: DateTime(2026, 12, 2),
    ),
    TripMember(
      id: 'm4',
      tripId: 'demo-rio-2027',
      userId: 'u4',
      role: MemberRole.viewer,
      fullName: 'Sofía Martínez',
      joinedAt: DateTime(2026, 12, 3),
    ),
  ];

  static final List<Map<String, dynamic>> demoEvents = [
    {
      'id': 'e1',
      'title': 'Vuelo Latam LA8000 (EZE -> GIG)',
      'category': 'flight',
      'day': 'Jueves 14 Ene',
      'time': '07:30 - 10:45',
      'location': 'Aeropuerto Internacional de Galeão (GIG)',
      'notes': 'Check-in online 24h antes. Equipaje de mano incluido.',
      'cost': 450.0,
    },
    {
      'id': 'e2',
      'title': 'Check-in Hotel Arena Ipanema',
      'category': 'hotel',
      'day': 'Jueves 14 Ene',
      'time': '14:00',
      'location': 'Rua Francisco Otaviano 131, Ipanema',
      'notes': 'Reserva #BK-88421. Vista al mar confirmada.',
      'cost': 820.0,
    },
    {
      'id': 'e3',
      'title': 'Subida al Cristo Redentor por Tren das Corcovado',
      'category': 'activity',
      'day': 'Viernes 15 Ene',
      'time': '09:00 - 12:30',
      'location': 'Parque Nacional da Tijuca',
      'notes': 'Llevar protector solar y agua. Voto del grupo confirmado.',
      'cost': 35.0,
    },
    {
      'id': 'e4',
      'title': 'Almuerzo en Marius Degustare',
      'category': 'restaurant',
      'day': 'Viernes 15 Ene',
      'time': '13:30 - 15:30',
      'location': 'Av. Atlântica 290, Leme',
      'notes': 'Buffet de mariscos y carnes de primera.',
      'cost': 60.0,
    },
    {
      'id': 'e5',
      'title': 'Atardecer en Pedra do Arpoador',
      'category': 'free_time',
      'day': 'Sábado 16 Ene',
      'time': '17:45 - 19:30',
      'location': 'Arpoador, Ipanema',
      'notes': 'Aplaudo al sol tradicional. Llevar música.',
      'cost': 0.0,
    },
    {
      'id': 'e6',
      'title': 'Teleférico Pão de Açúcar al atardecer',
      'category': 'activity',
      'day': 'Domingo 17 Ene',
      'time': '16:00 - 19:00',
      'location': 'Urca, Río de Janeiro',
      'notes': 'Entradas compradas online para saltar fila.',
      'cost': 30.0,
    },
  ];

  static final List<Map<String, dynamic>> demoExpenses = [
    {
      'title': 'Reserva Hotel Arena Ipanema (7 noches)',
      'amount': 820.0,
      'currency': 'USD',
      'paidBy': 'Juan Pérez (Tú)',
      'split': 'Dividido en partes iguales (4 personas)',
      'category': 'Alojamiento',
      'date': '14 Ene 2027',
    },
    {
      'title': 'Supermercado Zona Sul (Desayunos y bebidas)',
      'amount': 160.0,
      'currency': 'USD',
      'paidBy': 'Lucas Rodríguez',
      'split': 'Dividido en partes iguales (4 personas)',
      'category': 'Comida',
      'date': '14 Ene 2027',
    },
    {
      'title': 'Entradas Cristo Redentor + Tren',
      'amount': 140.0,
      'currency': 'USD',
      'paidBy': 'María González',
      'split': 'Dividido en partes iguales (4 personas)',
      'category': 'Actividades',
      'date': '15 Ene 2027',
    },
  ];

  static final List<Map<String, dynamic>> demoChecklist = [
    {'title': 'Pasaportes / DNI vigentes', 'completed': true, 'assignedTo': 'Todos'},
    {'title': 'Seguro médico internacional', 'completed': true, 'assignedTo': 'María González'},
    {'title': 'Adaptador de enchufe Brasil (tipo N)', 'completed': false, 'assignedTo': 'Lucas Rodríguez'},
    {'title': 'Reservar mesa para cenar el sábado', 'completed': false, 'assignedTo': 'Juan Pérez'},
    {'title': 'Comprar repelente y protector solar', 'completed': false, 'assignedTo': 'Sofía Martínez'},
  ];
}
