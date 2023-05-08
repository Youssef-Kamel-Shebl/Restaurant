import 'package:flutter/material.dart';
import 'package:restaurant/services/database.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  var restaurant_id;
  var table;
  var timeSlots;

  ReservationScreen({this.restaurant_id, this.table, this.timeSlots});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  var database = DatabaseServices();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late List<TimeOfDay> availableTimeSlots ;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    availableTimeSlots = widget.timeSlots.map((timeSlot) {
      DateTime dateTime = DateFormat('h:mm a').parse(timeSlot);
      return TimeOfDay.fromDateTime(dateTime);
    }).toList().cast<TimeOfDay>();
    _selectedTime = availableTimeSlots[0];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 20)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservation Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8.0),
                  Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Available Time Slots',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: availableTimeSlots.map((time) {
                bool isSelected = time == _selectedTime;
                return ChoiceChip(
                  label: Text('${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTime = time;
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                database.addBooking(widget.restaurant_id, widget.table, _selectedTime.format(context), _selectedDate, context);
              },
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
