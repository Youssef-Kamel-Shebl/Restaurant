
import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String _name;
  String _description;
  String _foodCategory;
  int _numTables;
  int _numSeats;
  List<String> _timeslots;
  String _id;
  String _longitude;
  String _latitude;
  String _imgUrl;
  String _token;
  String _location;

  // Constructor with id parameter
  Restaurant.withId(
      this._id,
      this._name,
      this._description,
      this._foodCategory,
      this._numTables,
      this._numSeats,
      this._timeslots,
      this._latitude,
      this._longitude,
      this._imgUrl,
      this._token,
      this._location);

  // Constructor without id parameter (sets _id to null)
  Restaurant(
      this._name,
      this._description,
      this._foodCategory,
      this._numTables,
      this._numSeats,
      this._timeslots,
      this._latitude,
      this._longitude,
      this._imgUrl,
      this._token,
      this._location)
      : _id = 'null';

  // Empty constructor
  Restaurant.empty()
      : _name = '',
        _description = '',
        _foodCategory = '',
        _numTables = 0,
        _numSeats = 0,
        _timeslots = [],
        _id = '',
        _latitude = '',
        _longitude = '',
        _imgUrl = '',
        _token = '',
        _location ='';

  factory Restaurant.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Restaurant.withId(
        snapshot.id,
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
        data['location']
    );
  }

  String get name => _name;

  set name(String name) => _name = name;

  String get description => _description;

  set description(String description) => _description = description;

  String get foodCategory => _foodCategory;

  set foodCategory(String foodCategory) => _foodCategory = foodCategory;

  int get numTables => _numTables;

  set numTables(int numTables) => _numTables = numTables;

  int get numSeats => _numSeats;

  set numSeats(int numSeats) => _numSeats = numSeats;

  List<String> get timeslots => _timeslots;

  set timeslots(List<String> timeslots) => _timeslots = timeslots;

  String get id => _id;

  set id(String id) => _id = id;

  String get imgUrl => _imgUrl;

  set imgUrl(String value) {
    _imgUrl = value;
  }

  String get token => _token;

  set token(String value) {
    _token = value;
  }

  String get latitude => _latitude;

  set latitude(String value) {
    _latitude = value;
  }

  String get longitude => _longitude;

  set longitude(String value) {
    _longitude = value;
  }

  String get location => _location;

  set location(String value) {
    _location = value;
  }
}
