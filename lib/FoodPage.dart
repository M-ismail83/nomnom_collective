import 'package:flutter/material.dart';
import 'package:the_nomnom_collective/FilterPage.dart';

class Foodpage extends StatefulWidget {
  const Foodpage({super.key});

  @override
  State<Foodpage> createState() => _FoodpageState();
}

class _FoodpageState extends State<Foodpage> {
  Widget _customListTile(String mealName, String pathToImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 100, // Adjusted width for better visibility
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(pathToImage)),
          border: Border.all(width: 1.0, color: Colors.deepOrange.shade800),
          borderRadius:
              BorderRadius.circular(8.0), // Optional for rounded corners
        ),
        child: Center(
          child: Text(
            mealName,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 232, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 7.5, horizontal: 20.0),
        child: ListView(
          children: [
            ListTile(
              tileColor: Colors.amber.shade800,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              leading: Icon(Icons.search),
              title: Text(
                'Search For Food',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => FoodSearchPage())),
            ),
            SizedBox(height: 7.5),
            SizedBox(
              height: 40,
              child: Text(
                'Recipes For You',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 18,
              child: Text('Breakfast', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 5),
            Container(
              height: 95,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.amber.shade300,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _customListTile('Menemen', 'lib/Images/Brek.jpg'),
                    _customListTile('Scrambled Eggs', 'lib/Images/Brek.jpg'),
                    _customListTile('Egg Salad', 'lib/Images/Brek.jpg'),
                    _customListTile('Oats with Yogurt', 'lib/Images/Brek.jpg'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 18,
              child: Text('Snack', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 5),
            Container(
              height: 95,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.amber.shade300,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _customListTile('Smoothie', 'lib/Images/Snek.jpg'),
                    _customListTile('Chia Pudding', 'lib/Images/Snek.jpg'),
                    _customListTile('Hummus and Wasa', 'lib/Images/Snek.jpg'),
                    _customListTile('Sorbet', 'lib/Images/Snek.jpg'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 18,
              child: Text('Lunch/Dinner', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 5),
            Container(
              height: 95,
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.amber.shade300,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _customListTile('Broccoli Soup', 'lib/Images/LuncDin.jpg'),
                    _customListTile('Tomato Soup', 'lib/Images/LuncDin.jpg'),
                    _customListTile('Ratatouille', 'lib/Images/LuncDin.jpg'),
                    _customListTile(
                        'Stuffed Peppers', 'lib/Images/LuncDin.jpg'),
                    _customListTile('Steak', 'lib/Images/LuncDin.jpg'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Colors.lightGreen.shade300,
                  borderRadius: BorderRadius.circular(40)),
              height: 300,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Friendly Remaninder :)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "It is best for you to avoid the following foods!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
