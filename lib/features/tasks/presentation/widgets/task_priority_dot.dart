import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/task.dart';

Color colorForPriority(TaskPriority priority) => switch (priority) {
      TaskPriority.low => AppColors.priorityLow,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.high => AppColors.priorityHigh,
    };

class TaskPriorityDot extends StatelessWidget {
  const TaskPriorityDot({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: colorForPriority(priority), shape: BoxShape.circle),
    );
  }
}
