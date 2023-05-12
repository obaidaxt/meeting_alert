// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _pageController = PageController(initialPage: _selectedDate.month - 1);
  }

  void _previousMonth() {
    // print(_pageController);

    int newMonth = _selectedDate.month - 1;
    int newYear = _selectedDate.year;
    if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    setState(() {
      _selectedDate = DateTime(newYear, newMonth, _selectedDate.day);
      _pageController = PageController(initialPage: _selectedDate.month - 1);
    });
  }

  void _nextMonth() {
    int newMonth = _selectedDate.month + 1;
    int newYear = _selectedDate.year;
    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    }
    setState(() {
      _selectedDate = DateTime(newYear, newMonth, _selectedDate.day);
      _pageController = PageController(initialPage: _selectedDate.month - 1);
    });
  }

  void _previousYear() {
    int newYear = _selectedDate.year - 1;
    setState(() {
      _selectedDate = DateTime(newYear, _selectedDate.month, _selectedDate.day);
      _pageController = PageController(initialPage: _selectedDate.month - 1);
    });
  }

  void _nextYear() {
    int newYear = _selectedDate.year + 1;
    setState(() {
      _selectedDate = DateTime(newYear, _selectedDate.month, _selectedDate.day);
      _pageController = PageController(initialPage: _selectedDate.month - 1);
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  List<Widget> _buildWeekdays() {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
        .map((day) => Padding(
              padding: const EdgeInsets.all(50.0),
              child: Text(
                day,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black,
                    backgroundColor: Colors.blueAccent),
              ),
            ))
        .toList();
  }

  List<Widget> _buildDays(BuildContext context) {
    List<Widget> days = [];
    DateTime firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    int weekdayOfFirstDay = firstDayOfMonth.weekday;
    for (int i = 0; i < weekdayOfFirstDay - 1; i++) {
      days.add(Container());
    }
    DateTime lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    for (int i = 0; i < lastDayOfMonth.day; i++) {
      DateTime day = DateTime(_selectedDate.year, _selectedDate.month, i + 1);
      days.add(GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(day.toString()),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(44.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.cyan,
              border: Border.all(color: Colors.grey),
            ),
            child: Center(
              child: Text('${day.day}'),
            ),
          ),
        ),
      ));
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _previousYear,
                icon: const Icon(Icons.arrow_back),
              ),
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.arrow_left),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${_getMonthName(_selectedDate.month)} ${_selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.arrow_right),
              ),
              IconButton(
                onPressed: _nextYear,
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedDate = DateTime(
                      _selectedDate.year, index + 1, _selectedDate.day);
                });
              },
              itemBuilder: (context, index) {
                // ignore: unused_local_variable
                DateTime month = DateTime(_selectedDate.year, index + 1);
                return GridView.count(
                  crossAxisCount: 7,
                  children: [
                    ..._buildWeekdays(),
                    ..._buildDays(context),
                  ],
                );
              },
              itemCount: 12,
            ),
          ),
        ],
      ),
    );
  }
}
