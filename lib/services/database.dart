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
          data['foodCategory']?? '',
          data['numTables'] ?? 0,
          data['numSeats'] ?? 0,
          List<String>.from(data['timeslots'] ?? []),
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
        .where('resturant_id', isEqualTo: restaurantId)
        .get();

    querySnapshot.docs.forEach((doc) {
      List<dynamic> bookedTableNumbers = doc['booked_tables'];
      bookedTableNumbers.forEach((tableNumber) {
        bookedTables.add(tableNumber);
      });
    });

    return bookedTables;
  }

}
