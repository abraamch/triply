enum TripType {
  friends('Amigos'),
  family('Familia'),
  couple('Pareja'),
  business('Negocios'),
  event('Evento'),
  adventure('Aventura'),
  other('Otro');

  final String label;
  const TripType(this.label);
}

enum TripPace {
  relaxed('Relajado'),
  balanced('Equilibrado'),
  intense('Intenso');

  final String label;
  const TripPace(this.label);
}

class Trip {
  final String id;
  final String title;
  final String? description;
  final List<String> destinations;
  final DateTime startDate;
  final DateTime endDate;
  final TripType tripType;
  final double? budget;
  final String currency;
  final int travelersCount;
  final List<String> preferences;
  final TripPace pace;
  final String? coverImageUrl;
  final bool isArchived;
  final String createdBy;

  const Trip({
    required this.id,
    required this.title,
    this.description,
    required this.destinations,
    required this.startDate,
    required this.endDate,
    this.tripType = TripType.friends,
    this.budget,
    this.currency = 'USD',
    this.travelersCount = 1,
    this.preferences = const [],
    this.pace = TripPace.balanced,
    this.coverImageUrl,
    this.isArchived = false,
    required this.createdBy,
  });

  int get durationDays => endDate.difference(startDate).inDays + 1;

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      destinations: (json['destinations'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      tripType: TripType.values.firstWhere(
        (e) => e.name == json['trip_type'],
        orElse: () => TripType.friends,
      ),
      budget: json['budget'] != null ? double.tryParse(json['budget'].toString()) : null,
      currency: json['currency'] as String? ?? 'USD',
      travelersCount: json['travelers_count'] as int? ?? 1,
      preferences: (json['preferences'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      pace: TripPace.values.firstWhere(
        (e) => e.name == json['pace'],
        orElse: () => TripPace.balanced,
      ),
      coverImageUrl: json['cover_image_url'] as String?,
      isArchived: json['is_archived'] as bool? ?? false,
      createdBy: json['created_by'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'destinations': destinations,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'trip_type': tripType.name,
      'budget': budget,
      'currency': currency,
      'travelers_count': travelersCount,
      'preferences': preferences,
      'pace': pace.name,
      'cover_image_url': coverImageUrl,
      'is_archived': isArchived,
      'created_by': createdBy,
    };
  }
}
