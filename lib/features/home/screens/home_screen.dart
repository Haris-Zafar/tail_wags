import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../events/models/event_model.dart';
import '../../events/providers/events_provider.dart';
import '../../events/widgets/event_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isCalendarView = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final allEventsAsync = ref.watch(allEventsProvider);
    final todaysEvents = ref.watch(todaysEventsProvider);

    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header with Title and List/Calendar View Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home',
                      style: AppTextStyles.headline.copyWith(
                        color: textPrimary,
                        fontSize: 24,
                      ),
                    ),

                    // Toggle Segmented Buttons
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.format_list_bulleted,
                              color: !_isCalendarView ? AppColors.primary : textSecondary,
                            ),
                            onPressed: () => setState(() => _isCalendarView = false),
                            tooltip: 'List view',
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: _isCalendarView ? AppColors.primary : textSecondary,
                            ),
                            onPressed: () => setState(() => _isCalendarView = true),
                            tooltip: 'Calendar view',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // View Body
              Expanded(
                child: _isCalendarView
                    ? _buildCalendarView(allEventsAsync.value ?? [], textPrimary)
                    : _buildListView(todaysEvents, textPrimary, textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(
    List<EventModel> events,
    Color textPrimary,
    Color textSecondary,
  ) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_available, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'No Events Today',
                style: AppTextStyles.title.copyWith(color: textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                'Check back later or view all events in the Features tab.',
                style: AppTextStyles.body.copyWith(color: textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );
  }

  Widget _buildCalendarView(List<EventModel> allEvents, Color textPrimary) {
    final selectedDayEvents = allEvents.where((e) {
      return _isSameDay(e.date, _selectedDay);
    }).toList();

    return Column(
      children: [
        // Table Calendar Widget
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: TableCalendar<EventModel>(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => _isSameDay(_selectedDay, day),
            eventLoader: (day) {
              return allEvents.where((e) => _isSameDay(e.date, day)).toList();
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Events list for selected date
        Expanded(
          child: selectedDayEvents.isEmpty
              ? Center(
                  child: Text(
                    'No events on selected date',
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondaryOf(context)),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: selectedDayEvents.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: selectedDayEvents[index]);
                  },
                ),
        ),
      ],
    );
  }
}
