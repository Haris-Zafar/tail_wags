import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../events/models/event_model.dart';
import '../../events/providers/events_provider.dart';
import '../../events/widgets/filter_sheet.dart';
import '../widgets/compact_event_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isCalendarView = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getSectionTitle() {
    if (_selectedDay == null || _isSameDay(_selectedDay, DateTime.now())) {
      return 'Today Events';
    }
    return '${DateFormat('d MMM yyyy').format(_selectedDay!)} Events';
  }

  void _switchToListView() {
    setState(() {
      _isCalendarView = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allEventsAsync = ref.watch(allEventsProvider);
    final allEvents = allEventsAsync.value ?? [];

    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = AppColors.borderOf(context);

    // Selected events or all events for List View
    final selectedDayEvents = allEvents.where((e) {
      return _isSameDay(e.date, _selectedDay);
    }).toList();

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar: Events Title + Filter Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Home',
                      style: AppTextStyles.headline.copyWith(
                        color: textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Icon(
                          Icons.tune,
                          size: 20,
                          color: textPrimary,
                        ),
                      ),
                      onPressed: () => FilterSheet.show(context),
                      tooltip: 'Filter Events',
                    ),
                  ],
                ),
              ),

              // Calendar View / List View Segmented Toggle (Centered)
              Center(
                child: Container(
                  width: 320,
                  height: 48,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCalendarView = true;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _isCalendarView
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Calendar View',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isCalendarView
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white70
                                        : const Color(0xFF757575)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _switchToListView,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: !_isCalendarView
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'List View',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: !_isCalendarView
                                    ? Colors.white
                                    : (isDark
                                        ? Colors.white70
                                        : const Color(0xFF757575)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Main Body View
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isCalendarView) ...[
                        // Transparent Calendar Widget
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TableCalendar<EventModel>(
                            firstDay: DateTime.utc(2024, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                _isSameDay(_selectedDay, day),
                            eventLoader: (day) {
                              return allEvents
                                  .where((e) => _isSameDay(e.date, day))
                                  .toList();
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                              leftChevronIcon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: borderColor, width: 1),
                                ),
                                child: Icon(
                                  Icons.chevron_left,
                                  size: 20,
                                  color: textPrimary,
                                ),
                              ),
                              rightChevronIcon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: borderColor, width: 1),
                                ),
                                child: Icon(
                                  Icons.chevron_right,
                                  size: 20,
                                  color: textPrimary,
                                ),
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: AppTextStyles.caption.copyWith(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF8E8AA0),
                                fontWeight: FontWeight.w500,
                              ),
                              weekendStyle: AppTextStyles.caption.copyWith(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF8E8AA0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              outsideDaysVisible: true,
                              outsideTextStyle: AppTextStyles.body.copyWith(
                                color: isDark
                                    ? Colors.white24
                                    : const Color(0xFFA0A0C0),
                              ),
                              defaultTextStyle: AppTextStyles.body.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              weekendTextStyle: AppTextStyles.body.copyWith(
                                color: textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                              todayDecoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            calendarBuilders: CalendarBuilders<EventModel>(
                              headerTitleBuilder: (context, date) {
                                return Column(
                                  children: [
                                    Text(
                                      DateFormat('MMMM').format(date),
                                      style: AppTextStyles.headline.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF2B2353),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('yyyy').format(date),
                                      style: AppTextStyles.caption.copyWith(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.white60
                                            : const Color(0xFF8E8AA0),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              markerBuilder: (context, day, events) {
                                if (events.isEmpty) return const SizedBox.shrink();

                                const ringColors = [
                                  Color(0xFF4CAF50), // Green ring
                                  Color(0xFFE53935), // Red ring
                                  Color(0xFF00ACC1), // Blue ring
                                ];

                                final count = events.length.clamp(1, 3);
                                return Positioned(
                                  bottom: 2,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(count, (index) {
                                      final color =
                                          ringColors[index % ringColors.length];
                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 1.5),
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent, // Unfilled ring!
                                          border: Border.all(
                                            color: color,
                                            width: 1.5,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Divider line below calendar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          child: Divider(
                            color: borderColor.withValues(alpha: 0.5),
                            height: 1,
                          ),
                        ),
                      ],

                      // Events Section Header ("Events" for List View, date-specific for Calendar View)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: Text(
                          _isCalendarView ? _getSectionTitle() : 'Events',
                          style: AppTextStyles.title.copyWith(
                            color: textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // List of Events using CompactEventCard
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: _buildEventsList(
                          _isCalendarView ? selectedDayEvents : allEvents,
                          textPrimary,
                          textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList(
    List<EventModel> events,
    Color textPrimary,
    Color textSecondary,
  ) {
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.event_available,
                  size: 48, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                'No events for this selection',
                style: AppTextStyles.title.copyWith(
                  color: textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Try selecting another date or check back later.',
                style: AppTextStyles.body.copyWith(
                  color: textSecondary,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: events.map((event) {
        return CompactEventCard(event: event);
      }).toList(),
    );
  }
}
