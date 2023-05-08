import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/Resturant.dart';
import '../classes/Category.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class DatabaseServices {
  final CollectionReference restaurantsCollection =
      FirebaseFirestore.instance.collection('resturant');

  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  final CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  // Function to add a new restaurant document to Firestore
  Future<void> addRestaurant(Restaurant res) async {
    await restaurantsCollection.add({
      'name': res.name,
      'description': res.description,
      'food_category': res.foodCategory,
      'num_tables': res.numTables,
      'num_seats': res.numSeats,
      'time_slots': res.timeslots,
      'location': res.location,
      'image': res.imgUrl,
      'token': res.token
    });
  }

  // Function to get a list of all restaurants in Firestore
  Future<List<Restaurant>> getAllRestaurants(categoryId) async {
    final querySnapshot = await restaurantsCollection
        .where('food_category', isEqualTo: categoryId)
        .get();
    List<Restaurant> restaurants = [];
    print(querySnapshot);

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        Restaurant restaurant = Restaurant.withId(
            doc.id ?? '0',
            data['name'] as String,
            data['description'] as String,
            data['food_category'],
            data['num_tables'] as int,
            data['num_seats'] as int,
            List<String>.from(data['time_slots'] as List) as List<String>,
            data['latitude'] as String,
            data['longitude'] as String,
            data['image'] as String,
            data['token'],
            data['location']);
        restaurants.add(restaurant);
      }
    }

    return restaurants;
  }

  // Function to get a single restaurant document from Firestore by ID
  Future<DocumentSnapshot> getRestaurantById(String id) async {
    final restaurantDoc = await restaurantsCollection.doc(id).get();
    return restaurantDoc;
  }

  // Function to update a restaurant document in Firestore by ID
  Future<void> updateRestaurantById(
      String id,
      String name,
      String description,
      String image,
      String foodCategory,
      int numTables,
      int numSeats,
      List<String> timeSlots,
      Map<String, double> salesPoint) async {
    await restaurantsCollection.doc(id).update({
      'name': name,
      'description': description,
      'image': image,
      'food_category': foodCategory,
      'num_tables': numTables,
      'num_seats': numSeats,
      'time_slots': timeSlots,
      'sales_point': salesPoint,
    });
  }

  // Function to delete a restaurant document from Firestore by ID
  Future<void> deleteRestaurantById(String id) async {
    await restaurantsCollection.doc(id).delete();
  }

  // Function to get a single restaurant document from Firestore by name
  Future<DocumentSnapshot?> getRestaurantByName(String name) async {
    final querySnapshot =
        await restaurantsCollection.where('name', isEqualTo: name).get();
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return querySnapshot.docs.first;
  }

  Future<List<DocumentSnapshot>> searchRestaurantsByName(String query) async {
    final querySnapshot = await restaurantsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();
    return querySnapshot.docs;
  }

  Future<List<int>> getBookedTables(String restaurantId) async {
    List<int> bookedTables = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('restaurant_id', isEqualTo: restaurantId)
        .get();

    querySnapshot.docs.forEach((doc) {
      List<dynamic> bookedTableNumbers = doc['booked_tables'];
      bookedTableNumbers.forEach((tableNumber) {
        bookedTables.add(tableNumber);
      });
    });

    return bookedTables;
  }

  // Future<void> addBooking(String restaurantId, int newBookedTables) async {
  //   // try {
  //     // Get a reference to the document with the specified restaurant_id
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('books')
  //         .where('restaurant_id', isEqualTo: restaurantId)
  //         .get();
  //
  //     // Get the first document from the query result
  //     DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
  //
  //     // Get the current booked_tables array from the document
  //     List<int> currentBookedTables = List<int>.from(documentSnapshot.get('booked_tables'));
  //
  //     // Add the new booked tables to the current booked tables
  //     currentBookedTables.add(newBookedTables);
  //
  //     // Update the document with the new booked tables array
  //     await documentSnapshot.reference.update({'booked_tables': currentBookedTables});
  //
  //     print('Booked tables updated successfully!');
  //   // } catch (e) {
  //   //   print('Error updating booked tables: $e');
  //   // }
  // }

  Future<bool> isTableAlreadyBooked(String restaurantId, int bookedTables, var time, var date) async {

    final existingBookingsSnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('restaurant_id', isEqualTo: restaurantId)
        .where('date', isEqualTo: date)
        .where('table', isEqualTo: bookedTables)
        .where('time_slot', isEqualTo: time)
        .get();

    return existingBookingsSnapshot.docs.isNotEmpty;
  }


  Future<void> addBooking(String restaurantId, int newBookedTables, var time, var date, context) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final isAlreadyBooked = await isTableAlreadyBooked(restaurantId, newBookedTables, time, formattedDate);

      if (isAlreadyBooked) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Table Already Booked'),
              content: Text('Sorry, the table is already booked. Please choose another time slot or date.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      await FirebaseFirestore.instance.collection('books').add({
        'restaurant_id': restaurantId,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'time_slot': time,
        'table': newBookedTables
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              'Booking added successfully!',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      });

      print('Booked tables updated successfully!');
    } catch (e) {
      print('Error updating booked tables: $e');
    }
  }

  Future<List<Category>> getAllCategories() async {
    List<Category> categories = [];

    try {
      QuerySnapshot querySnapshot = await categoryCollection.get();
      querySnapshot.docs.forEach((doc) {
        categories.add(Category.fromSnapshot(doc));
      });
    } catch (e) {
      print('Error getting categories: $e');
    }

    return categories;
  }

  Future<String> getFoodCategoryName(String categoryId) async {
    final categoryDoc = await categoryCollection.doc(categoryId).get();
    if (categoryDoc.exists) {
      final categoryName = categoryDoc.get('name');
      return categoryName;
    } else {
      throw Exception('Food category not found');
    }
  }

// void loadCategories() async {
//   List<Category> categories = await db.getAllCategories();
//   setState(() {
//     foodCategories = categories;
//     print(foodCategories[0].name);
//     print(foodCategories[1].name);
//   });
// }
}
