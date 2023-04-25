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
  final List<int> _tables = [];
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
                    title: Text('Table 4 chairs'),
                    trailing: _selectedTableId == table ? Icon(Icons.check_circle) : null,
                    onTap: () {
                      setState(() {
                        _selectedTableId = table;
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
  Future<void> fetchRestaurants() async {
    final List<int> bookedTables = await database.getBookedTables(widget.restaurant.id) as List<int>;
    int tables = widget.restaurant.numTables - bookedTables.length;
    _tables.fillRange(1, tables,0);
    print(_tables);
  }
}
