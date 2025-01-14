import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_nomnom_collective/DietProfilePage.dart';
import 'package:the_nomnom_collective/FilterPage.dart';
import 'package:the_nomnom_collective/MealData.dart';
import 'package:the_nomnom_collective/PatientPage.dart';

class DietHomePage extends StatefulWidget {
  const DietHomePage({super.key});

  @override
  State<DietHomePage> createState() => _DietHomePageState();
}

class _DietHomePageState extends State<DietHomePage> {
  int _selectedIndex = 1;

  // Method to handle tab selection in the bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Method that returns a map of patients and their diseases
  Map<String, String> getPatientDisease() {
    return {
      'Aslı': 'Celiac',
      'Burcu': 'Pregnant',
      'Cengiz': 'Obese',
      'Mahmut': 'Diabetic'
    };
  }

  // Method that returns a map of patients and their meal plans (fetched from MealData)
  Map<String, List<String>> getPatientMealMapping() {
    return MealData.patientMealMap;
  }

  // Build method to render the UI based on selected tab
  @override
  Widget build(BuildContext context) {
    // List of pages for each bottom navigation tab
    final List<Widget> pages = [
      Patientpage(), // Patient page to show a list of patients
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            SizedBox(height: 7.5),
            // A button that navigates to the FoodSearchPage when tapped
            ListTile(
              tileColor: Color.fromRGBO(135, 211, 127, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
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
            _customTileList(context, 80, 'Aslı', 'Güngören', 'ingredients'),
            _customTileList(context, 80, 'Cengiz', 'Türker', 'ingredients'),
            _customTileList(context, 80, 'Burcu', 'Çakıltaş', 'ingredients'),
            _customTileList(context, 80, 'Mahmut', 'Çiftbakır', 'ingredients'),
          ],
        ),
      ),
      DietProfilePage() // Profile page to show diet profile
    ];

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 244, 232, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(135, 211, 127, 1),
        title: Text(
          'NomNom Collective',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ),
      body: pages[_selectedIndex], // Display content based on selected tab
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patient'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person_4), label: 'Profile')
        ],
        backgroundColor: Color.fromRGBO(135, 211, 127, 1),
        currentIndex: _selectedIndex, // Set the currently selected tab
        onTap: _onItemTapped, // Call method to handle tab selection
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Custom method to create a list tile for each patient
  Widget _customTileList(BuildContext context, double height, String name,
      String surname, String ingredients) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Container(
          padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
              color: Colors.amber.shade300,
              border: Border.all(width: 1.0, color: Colors.deepOrange.shade700),
              borderRadius: BorderRadius.circular(15.0)),
          height: height,
          child: ListTile(
            leading: Icon(Icons.personal_injury),
            title: StrokeText(
              text:
                  '$name $surname', // Display the patient name with stroke effect
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              strokeColor: Color.fromRGBO(244, 244, 232, 1),
              strokeWidth: 4,
            ),
            onTap: () => _showDialog(context, name,
                ingredients), // Show dialog with patient details when tapped
            focusColor: Colors.deepOrange.shade700,
          ),
        )
      ],
    );
  }

  // Method to show a dialog with detailed information about the patient's meals and disease status
  _showDialog(BuildContext context, String name, String details) {
    Map<String, List<String>> patientMealList = getPatientMealMapping();
    Map<String, String> patientDiseaseList = getPatientDisease();
    List<String>? meals =
        patientMealList[name]; // Fetch meals for the selected patient
    String? disease =
        patientDiseaseList[name]; // Fetch disease for the selected patient

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(244, 244, 232, 1),
            scrollable: true,
            title: Text(name), // Display patient name in the dialog title
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the patient's meal list for the day
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0, color: Color.fromRGBO(135, 211, 127, 1)),
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(7.5),
                  child: Text("Today's List:\n$meals"),
                ),
                SizedBox(height: 5),
                // Display the patient's current disease status
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0, color: Color.fromRGBO(135, 211, 127, 1)),
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(7.5),
                  child: Text("Current Status:\n$disease"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the dialog when the close button is pressed
                  },
                  child: const Text('Close'))
            ],
          );
        });
  }
}
