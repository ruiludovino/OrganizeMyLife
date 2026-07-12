class Event {
  const Event({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.allDay,
    this.description,
    this.location,
  });

  final String id;
  final String title;
  final String? description;
  final String? location;
  final DateTime start;
  final DateTime end;
  final bool allDay;

  Event copyWith({
    String? title,
    String? description,
    String? location,
    DateTime? start,
    DateTime? end,
    bool? allDay,
  }) {
    return Event(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      start: start ?? this.start,
      end: end ?? this.end,
      allDay: allDay ?? this.allDay,
    );
  }
}
