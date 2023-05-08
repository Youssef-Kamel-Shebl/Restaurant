import 'package:flutter/material.dart';
import 'package:restaurant/classes/Resturant.dart';
import 'package:restaurant/services/database.dart';
import './details.dart';

class BookingScreen extends StatefulWidget {
  final Restaurant restaurant;

  const BookingScreen({Key? key, required this.restaurant}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  var database = DatabaseServices();
  // Define a list of tables with their corresponding number of chairs
  late List<int> _tables = [];
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
              child: FutureBuilder<void>(
                future: fetchTables(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching tables'));
                  } else {
                    return ListView.builder(
                      itemCount: _tables.length,
                      itemBuilder: (context, index) {
                        var table = _tables[index];
                        return ListTile(
                          title: Text('Table 4 chairs'),
                          trailing: _selectedTableId == table ? Icon(Icons.check_circle) : null,
                          onTap: () {
                            setState(() {
                              _selectedTableId = table;
                            });
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _selectedTableId == null ? null : () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ReservationScreen(restaurant_id: widget.restaurant.id, table: _selectedTableId, timeSlots: widget.restaurant.timeslots,)));
              },
              child: Text('Continue Booking'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchTables() async {
    _tables = List<int>.generate(widget.restaurant.numTables, (index) => index + 1);
  }
}
