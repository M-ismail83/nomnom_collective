import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ProfilePage.dart';
import 'FilterPage.dart';
import 'FoodPage.dart';
import 'PatientStorage.dart' as patient_storage;
import 'DataStorage.dart' as data_storage;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Fetches patient information from the database using the current user's UID
  Future<Map<String, dynamic>> fetchPatientInfo() async {
    final User? user = auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");
    final String uid = user.uid;

    // Fetch patient info using the database helper
    return await patient_storage.DatabaseHelper.instance.getPatientByUID(uid);
  }

  // Example list of snacks
  List<Map<String, String>> snacks = [
    {'name': 'Fruit Salad', 'ingredients': 'Mixed fruits, Honey, Lemon juice'},
    {'name': 'Granola Bar', 'ingredients': 'Oats, Honey, Nuts, Dried fruits'},
    {'name': 'Yogurt with Berries', 'ingredients': 'Yogurt, Berries, Honey'},
  ];

  // Keeps track of the selected tab in the bottom navigation bar
  int _selectedIndex = 1;

  // Updates the selected tab when a user taps on a bottom navigaton bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Returns a hardcoded mapping of patient names to their meal plans
  Map<String, List<String>> getPatientMealMapping() {
    return {
      'Aslı': ['Scrambled Eggs', 'Tomato Soup', 'Pilaf'],
      'Burcu': ['Egg Salad', 'Creamy Mushroom Soup', 'Steak'],
      'Cengiz': ['Oats with Yoghurt', 'Red Lentil Soup', 'Roasted Fish'],
      'Mahmut': ['Menemen', 'Chicken Sauté', 'Ratatouille'],
    };
  }

  // Fetches the ingredients for the given meal names from the database
  Future<Map<String, String>> fetchMealIngredients(
      List<String> mealNames) async {
    final db = await data_storage.DatabaseHelper.instance.database;
    final placeholders = List.filled(mealNames.length, '?').join(', ');

    final results = await db.query(
      'food',
      where: 'name IN ($placeholders)',
      whereArgs: mealNames,
    );

    // Map meal names to their ingredients
    return {
      for (var meal in results)
        meal['name'] as String: meal['ingredients'] as String,
    };
  }

  // Body for Google sign-in users (personalized page)
  Widget _bodyForGoogle(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 40.0, vertical: 0.0),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          SizedBox(height: 7.5),
          ListTile(
            tileColor: Colors.amber.shade800,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            leading: Icon(Icons.search),
            title: Text(
              'Search For Food',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
            onTap: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => FoodSearchPage())),
          ),
          SizedBox(height: 7.5),
          _customTileList(
              context, 125, 'Breakfast', 'lib/Images/Breakfast.jpg', 'Deneme'),
          _customTileList(
              context, 75, 'Snack', "lib/Images/Snack1.jpg", 'Deneme'),
          _customTileList(
              context, 125, 'Lunch', "lib/Images/Lunch.jpg", 'Deneme'),
          _customTileList(
              context, 75, 'Snack', "lib/Images/Snack2.jpg", 'Deneme'),
          _customTileList(
              context, 125, 'Dinner', "lib/Images/Dinner.jpg", 'Deneme'),
          _customTileList(
              context, 75, 'Snack', "lib/Images/Snack3.jpg", 'Deneme'),
          SizedBox(
            height: 7.5,
          )
        ],
      ),
    );
  }

  // Checks if the user is logged-in with Google and returns the apropriate body
  Widget googleChecker() {
    final User? user = FirebaseAuth.instance.currentUser;
    for (final provider in user!.providerData) {
      if (provider.providerId == 'google.com') {
        return _bodyForGoogle(context);
      } else {
        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchPatientInfo(),
              builder: (context, patientSnapshot) {
                if (patientSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (patientSnapshot.hasError) {
                  return Center(child: Text('Error: ${patientSnapshot.error}'));
                }
                if (!patientSnapshot.hasData || patientSnapshot.data == null) {
                  return const Center(child: Text('No patient data found.'));
                }

                final patientName = patientSnapshot.data!['PATIENT_NAME'];
                final mealMapping = getPatientMealMapping();
                final mealNames = mealMapping[patientName] ?? [];

                return FutureBuilder<Map<String, String>>(
                  future: fetchMealIngredients(mealNames),
                  builder: (context, mealSnapshot) {
                    if (mealSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (mealSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${mealSnapshot.error}'));
                    }
                    if (!mealSnapshot.hasData || mealSnapshot.data == null) {
                      return const Center(child: Text('No meal data found.'));
                    }

                    final mealData = mealSnapshot.data!;
                    final mealTimes = [
                      'Breakfast',
                      'Lunch',
                      'Dinner'
                    ]; // Predefined order

                    // Create a list to hold the combined meals and snacks
                    List<Map<String, String>> combinedList = [];

                    // Add the search bar as the first item
                    combinedList.add({
                      'type': 'search',
                      'name': 'Search For Food',
                      'image':
                          'lib/Images/SearchBarImage.jpg', // Replace with your actual image or use an icon
                      'ingredients': '',
                    });

                    // Add meals and snacks in alternating order
                    for (int i = 0; i < mealData.entries.length; i++) {
                      // Add the meal
                      combinedList.add({
                        'type': 'meal',
                        'name': mealData.entries.elementAt(i).key,
                        'ingredients': mealData.entries.elementAt(i).value,
                        'image':
                            'lib/Images/${mealTimes[i % mealTimes.length]}.jpg'
                      });

                      // Add the snack after the meal if there is one
                      if (i < snacks.length) {
                        combinedList.add({
                          'type': 'snack',
                          'name': snacks[i]['name']!,
                          'ingredients': snacks[i]['ingredients']!,
                          'image': 'lib/Images/Snack${i + 1}.jpg'
                        });
                      }
                    }

                    return ListView.builder(
                      itemCount:
                          combinedList.length, // Total number of combined items
                      itemBuilder: (context, index) {
                        final item = combinedList[index];
                        if (item['type'] == 'search') {
                          return Column(
                            children: [
                              SizedBox(height: 7.5),
                              ListTile(
                                tileColor: Colors.amber.shade800,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                leading: Icon(Icons.search),
                                title: Text(
                                  'Search For Food',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                  textAlign: TextAlign.center,
                                ),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FoodSearchPage()));
                                },
                              ),
                              SizedBox(height: 7.5),
                            ],
                          );
                        }

                        if (item['type'] == 'meal') {
                          return Column(
                            children: [
                              _customTileList(
                                context,
                                125,
                                item['name']!,
                                item['image']!,
                                item['ingredients']!,
                              ),
                              SizedBox(height: 7.5), // Space between tiles
                            ],
                          );
                        } else if (item['type'] == 'snack') {
                          return Column(
                            children: [
                              _customTileList(
                                context,
                                75, // Smaller height for snacks
                                item['name']!,
                                item['image']!,
                                item['ingredients']!,
                              ),
                              SizedBox(height: 7.5), // Space between tiles
                            ],
                          );
                        }
                        return const SizedBox(); // Fallback case (shouldn't happen)
                      },
                    );
                  },
                );
              },
            ));
      }
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [Foodpage(), googleChecker(), Profilepage()];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber.shade800,
        title: Text(
          'NomNom Collective',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900, // Make the title bold
          ),
        ),
      ),
      body: _pages[_selectedIndex],
      backgroundColor: Color.fromRGBO(244, 244, 232, 1),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_4), label: 'Profile', key: Key('Profile'))
        ],
        backgroundColor: Colors.amber.shade800,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Custom tile for displaying food items with image, name, and ingredients
  Widget _customTileList(BuildContext context, double height, String text,
      String pathToImage, String ingredients) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.deepOrange.shade700),
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                  image: AssetImage(pathToImage),
                  fit: BoxFit.cover,
                  opacity: 0.7)),
          height: height,
          child: ListTile(
            title: StrokeText(
              text: text,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              strokeColor: Color.fromRGBO(244, 244, 232, 1),
              strokeWidth: 4,
            ),
            onTap: () => _showDialog(context, text, ingredients),
            focusColor: Colors.deepOrange.shade700,
          ),
        )
      ],
    );
  }

  // Shows a dialog with the food name and its ingredients
  _showDialog(BuildContext context, String text, String details) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // We are just creating a dialog pop-up with the food name and ingredients
          return AlertDialog(
            backgroundColor: Color.fromRGBO(244, 244, 232, 1),
            scrollable: true,
            title: Text(text),
            content: Text('Ingredients: \n$details'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Kapat'))
            ],
          );
        });
  }
}

extension IterableExtensions<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) transform) {
    int i = 0;
    return map((e) => transform(i++, e));
  }
}
