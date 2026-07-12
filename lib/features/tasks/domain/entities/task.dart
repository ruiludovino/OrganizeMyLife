enum TaskPriority { low, medium, high }

class Task {
  const Task({
    required this.id,
    required this.title,
    required this.priority,
    required this.done,
    required this.createdAt,
    this.category,
    this.dueDate,
  });

  final String id;
  final String title;
  final String? category;
  final TaskPriority priority;
  final bool done;
  final DateTime? dueDate;
  final DateTime createdAt;

  Task copyWith({
    String? title,
    String? category,
    TaskPriority? priority,
    bool? done,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      done: done ?? this.done,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
    );
  }
}
