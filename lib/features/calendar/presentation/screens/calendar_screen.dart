import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/event.dart';
import '../providers/event_providers.dart';
import '../widgets/add_edit_event_sheet.dart';

DateTime _dayKey(DateTime d) => DateTime(d.year, d.month, d.day);

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final eventsByDay = ref.watch(eventsByDayProvider);
    final selectedEvents = eventsByDay[_dayKey(_selectedDay)] ?? const <Event>[];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calendarTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddEditEventSheet(context, initialDay: _selectedDay),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.now().subtract(const Duration(days: 365 * 3)),
            lastDay: DateTime.now().add(const Duration(days: 365 * 3)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            calendarFormat: _format,
            eventLoader: (day) => eventsByDay[_dayKey(day)] ?? const [],
            availableCalendarFormats: {
              CalendarFormat.month: l10n.calendarFormatMonth,
              CalendarFormat.week: l10n.calendarFormatWeek,
            },
            onFormatChanged: (format) => setState(() => _format = format),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
            onPageChanged: (focused) => _focusedDay = focused,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: selectedEvents.isEmpty
                ? Center(child: Text(l10n.calendarNoEvents))
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: selectedEvents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final event = selectedEvents[index];
                      return AppCard(
                        onTap: () => showAddEditEventSheet(context, existing: event),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.title, style: Theme.of(context).textTheme.bodyLarge),
                                  if (event.location != null)
                                    Text(
                                      event.location!,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: Theme.of(context).colorScheme.outline,
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              event.allDay
                                  ? l10n.eventAllDay
                                  : '${event.start.hour.toString().padLeft(2, '0')}:${event.start.minute.toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ref.read(eventRepositoryProvider).deleteEvent(event.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
