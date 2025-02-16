import 'package:flutter/material.dart';

class CalendarComponent extends StatefulWidget {
  const CalendarComponent({super.key});

  @override
  _CalendarComponentState createState() => _CalendarComponentState();
}

class _CalendarComponentState extends State<CalendarComponent> {
  DateTime _selectedDate = DateTime.now();

  final List<String> _schedule = [
    "周一到周五",
    "",
    "",
    "",
    "",
    "",
    "",
  ];

  final Map<DateTime, List<String>> _events = {
    DateTime.now(): ["工作内容1", "工作内容2"],
    DateTime.now().add(const Duration(days: 1)): ["工作内容3"],
    DateTime.now().add(const Duration(days: 2)): ["工作内容4"],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildCalendarGrid(),
        _buildEventList(),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.subtract(const Duration(days: 7));
            });
          },
        ),
        Text(
          "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}",
          style: const TextStyle(fontSize: 24),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.add(const Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Table(
      children: [
        TableRow(
          children: List.generate(7, (index) {
            DateTime date =
                _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
            date = date.add(Duration(days: index));
            return Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                  right: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _schedule[index] != "" ? Colors.yellow : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 8,
                      height: 8,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _selectedDate.day == date.day ? Colors.blue : null,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      width: 40,
                      height: 40,
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _selectedDate.day == date.day ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEventList() {
    List<String> events = _events[_selectedDate] ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(events[index]),
          );
        },
      ),
    );
  }
}