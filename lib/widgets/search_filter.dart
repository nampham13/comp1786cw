import 'package:flutter/material.dart';

class SearchFilter extends StatefulWidget {
  final Function(String?, String?) onApplyFilters;

  const SearchFilter({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<SearchFilter> createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  String? _selectedDay;
  String? _selectedTimeOfDay;
  bool _isExpanded = false;

  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> _timesOfDay = [
    'Morning',
    'Afternoon',
    'Evening',
  ];

  void _resetFilters() {
    setState(() {
      _selectedDay = null;
      _selectedTimeOfDay = null;
    });
    widget.onApplyFilters(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Header with expand/collapse button
            Row(
              children: [
                const Icon(Icons.filter_list),
                const SizedBox(width: 8),
                const Text(
                  'Filter Classes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            
            // Filter options (visible when expanded)
            if (_isExpanded)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  
                  // Day filter
                  const Text(
                    'Day of Week:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: _daysOfWeek.map((day) {
                      return ChoiceChip(
                        label: Text(day),
                        selected: _selectedDay == day,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDay = selected ? day : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Time of day filter
                  const Text(
                    'Time of Day:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8.0,
                    children: _timesOfDay.map((time) {
                      return ChoiceChip(
                        label: Text(time),
                        selected: _selectedTimeOfDay == time,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTimeOfDay = selected ? time : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  // Apply and reset buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _resetFilters,
                        child: const Text('RESET'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          widget.onApplyFilters(_selectedDay, _selectedTimeOfDay);
                        },
                        child: const Text('APPLY'),
                      ),
                    ],
                  ),
                ],
              ),
            
            // Selected filters summary (visible when collapsed)
            if (!_isExpanded && (_selectedDay != null || _selectedTimeOfDay != null))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  children: [
                    if (_selectedDay != null)
                      Chip(
                        label: Text(_selectedDay!),
                        onDeleted: () {
                          setState(() {
                            _selectedDay = null;
                          });
                          widget.onApplyFilters(_selectedDay, _selectedTimeOfDay);
                        },
                      ),
                    if (_selectedTimeOfDay != null)
                      Chip(
                        label: Text(_selectedTimeOfDay!),
                        onDeleted: () {
                          setState(() {
                            _selectedTimeOfDay = null;
                          });
                          widget.onApplyFilters(_selectedDay, _selectedTimeOfDay);
                        },
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}