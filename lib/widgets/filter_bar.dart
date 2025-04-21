import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/class_provider.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _timeRanges = [
    'Morning (6:00-12:00)',
    'Afternoon (12:00-17:00)',
    'Evening (17:00-22:00)',
  ];

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list),
              const SizedBox(width: 8),
              Text(
                'Filter Classes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (classProvider.selectedDay != null || classProvider.selectedTimeRange != null)
                TextButton(
                  onPressed: () {
                    classProvider.clearFilters();
                  },
                  child: const Text('Clear Filters'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDayDropdown(context, classProvider),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeDropdown(context, classProvider),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayDropdown(BuildContext context, ClassProvider classProvider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Day',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      value: classProvider.selectedDay,
      hint: const Text('Select Day'),
      isExpanded: true,
      onChanged: (value) {
        classProvider.filterByDay(value);
      },
      items: _daysOfWeek.map((day) {
        return DropdownMenuItem<String>(
          value: day,
          child: Text(day),
        );
      }).toList(),
    );
  }

  Widget _buildTimeDropdown(BuildContext context, ClassProvider classProvider) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Time',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
      value: classProvider.selectedTimeRange,
      hint: const Text('Select Time'),
      isExpanded: true,
      onChanged: (value) {
        classProvider.filterByTimeRange(value);
      },
      items: _timeRanges.map((timeRange) {
        return DropdownMenuItem<String>(
          value: timeRange,
          child: Text(timeRange),
        );
      }).toList(),
    );
  }
}