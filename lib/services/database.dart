import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/Resturant.dart';

class DatabaseServices {
  final CollectionReference restaurantsCollection =
  FirebaseFirestore.instance.collection('resturant');

  final CollectionReference booksCollection =
  FirebaseFirestore.instance.collection('books');

  // Function to add a new restaurant document to Firestore
  Future<void> addRestaurant(Restaurant res) async {
    await restaurantsCollection.add({
      'name': res.name,
      'description': res.description,
      'food_category': res.foodCategory,
      'num_tables': res.numTables,
      'num_seats': res.numSeats,
      'time_slots': res.timeslots,
      'location':res.location,
      'image':res.imgUrl,
      'token':res.token
    });
  }

  // Function to get a list of all restaurants in Firestore
  Future<List<Restaurant>> getAllRestaurants() async {
    final querySnapshot = await restaurantsCollection.get();
    List<Restaurant> restaurants = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        Restaurant restaurant = Restaurant.withId(
          doc.id ?? '0',
          data['name'] ?? '',
          data['description'] ?? '',
          data['food_category']?? '',
          data['num_tables'] ?? 0,
          data['num_seats'] ?? 0,
          List<String>.from(data['time_slots'] ?? []),
          data['location'] ?? '',
          data['image'] ?? '',
          data['token'] ?? '',
        );
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
  Future<void> updateRestaurantById(String id, String name, String description,
      String image, String foodCategory, int numTables, int numSeats,
      List<String> timeSlots, Map<String, double> salesPoint) async {
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

  Future<void> addBooking(String restaurantId, int newBookedTables) async {
    try {
      // Get a reference to the document with the specified restaurant_id
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('restaurant_id', isEqualTo: restaurantId)
          .get();

      // Check if the query result is empty
      // if (querySnapshot.docs.isEmpty) {
      //   print('No document found with restaurant_id = $restaurantId');
      //   return;
      // } else {
      //   print('Document found with restaurant_id = $restaurantId');
      //   return;
      // }

      // Get the first document from the query result
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;

      // Get the current booked_tables array from the document
      List<int> currentBookedTables = List<int>.from(documentSnapshot.get('booked_tables'));

      // Add the new booked tables to the current booked tables
      currentBookedTables.add(newBookedTables);

      // Update the document with the new booked tables array
      await documentSnapshot.reference.update({'booked_tables': currentBookedTables});

      print('Booked tables updated successfully!');
    } catch (e) {
      print('Error updating booked tables: $e');
    }
  }

  

}
