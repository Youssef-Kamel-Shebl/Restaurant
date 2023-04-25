import 'package:flutter/material.dart';
import './booking.dart';
import './services/database.dart';

class Restaurant {
  final String name;
  final String imageUrl;
  final String location;

  Restaurant({required this.name, required this.imageUrl, required this.location});
}

class RestaurantScreen extends StatelessWidget {

  var database = DatabaseServices();

  var restaurants = [];


  // final List<Restaurant> restaurants = [
  //   Restaurant(
  //     name: 'Restaurant A',
  //     imageUrl: 'https://source.unsplash.com/random/200x200',
  //     location: '123 Main St, Anytown USA',
  //   ),
  //   Restaurant(
  //     name: 'Restaurant B',
  //     imageUrl: 'https://source.unsplash.com/random/200x200',
  //     location: '456 Oak St, Anytown USA',
  //   ),
  //   Restaurant(
  //     name: 'Restaurant C',
  //     imageUrl: 'https://source.unsplash.com/random/200x200',
  //     location: '789 Maple St, Anytown USA',
  //   ),
  //   Restaurant(
  //     name: 'Restaurant D',
  //     imageUrl: 'https://source.unsplash.com/random/200x200',
  //     location: '101 Elm St, Anytown USA',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    fetchRestaurants();
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurants'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BookingScreen()));
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(
                      restaurant.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          restaurant.location,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchRestaurants() async {
    restaurants = await database.getAllRestaurants();
    print(restaurants);
  }
}
