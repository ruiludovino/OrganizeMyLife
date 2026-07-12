class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.dateTime,
  });

  final String id;
  final String title;
  final DateTime dateTime;

  Reminder copyWith({String? title, DateTime? dateTime}) {
    return Reminder(
      id: id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
