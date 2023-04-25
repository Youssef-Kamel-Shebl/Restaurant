import 'package:flutter/material.dart';
import './details.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Define a list of tables with their corresponding number of chairs
  final List<Map<String, dynamic>> _tables = [    {'id': 1, 'chairs': 2},    {'id': 2, 'chairs': 4},    {'id': 3, 'chairs': 6},    {'id': 4, 'chairs': 8},  ];

  // Define a variable to store the selected table
  int? _selectedTableId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select a table:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _tables.length,
                itemBuilder: (context, index) {
                  final table = _tables[index];
                  return ListTile(
                    title: Text('Table ${table['id']} - ${table['chairs']} chairs'),
                    trailing: _selectedTableId == table['id'] ? Icon(Icons.check_circle) : null,
                    onTap: () {
                      setState(() {
                        _selectedTableId = table['id'];
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectedTableId == null ? null : () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ReservationScreen()));
              },
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
