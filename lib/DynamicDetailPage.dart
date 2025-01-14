import 'package:flutter/material.dart';
import 'package:the_nomnom_collective/DietHomePage.dart';
import 'package:the_nomnom_collective/MealData.dart';

class DetailPage extends StatefulWidget {
  // Constructor that accepts patient name and surname to personalize the page
  const DetailPage({super.key, required this.name, required this.surname});

  final String name;
  final String surname;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Returns the patient information stored in MealData
  Map<String, List<String>> getPatientInfo() {
    return MealData.patientInfo;
  }

  // Returns the patient's past meals mapping stored in MealData
  Map<String, List<List<String>>> getPatientPastMealMapping() {
    return MealData.patientPastMealMap;
  }

  // Returns the patient's meal mapping stored in MealData
  Map<String, List<String>> getPatientMealMapping() {
    return MealData.patientMealMap;
  }

  // Navigates to the DietHomePage
  Future<void> goToDietHomePage() {
    return Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DietHomePage()));
  }

  // Creates a custom tile for each meal item in the patient's diet
  Widget _customTileList(BuildContext context, double width, int mealNum) {
    Map<String, List<String>> patientDietMap = getPatientMealMapping();
    List<String>? patientDiet =
        patientDietMap[widget.name]; // Fetch the specific patient's diet list
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showMealInputDialog(context, mealNum,
              patientDiet), // Show meal input dialog when tapped
          child: Container(
            padding: EdgeInsets.all(0.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber.shade300)),
            height: 120,
            width: width,
            child: Center(
              child: Text(
                patientDiet![
                    mealNum], // Display the specific meal item based on `mealNum`
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> patientPastMealDateMap =
        MealData.patientPastMealDateMap;

    // Fetch past meal data for the specific patient
    final List<String>? patientPastMealDate =
        patientPastMealDateMap[widget.name];

    Map<String, List<String>> patientInfoMap = getPatientInfo();
    Map<String, List<List<String>>> patientPastMealMap =
        getPatientPastMealMapping();
    List<String>? patientInfo = patientInfoMap[widget.name];
    List<List<String>>? patientPastMeal = patientPastMealMap[widget.name];

    // Build the main structure of the DetailPage
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 232, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(135, 211, 127, 1),
        leading: IconButton(
            onPressed: () => goToDietHomePage(), icon: Icon(Icons.arrow_back)),
        title: Text('Dynamic Detail Page'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('lib/Images/Snack1.jpg'),
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${widget.name}'),
                    Text('Surname: ${widget.surname}')
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            // Container that holds the patient's info like email, age, and disease
            Container(
                height: 100,
                width: 330,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber.shade300),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email: ${patientInfo?[0]}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Age: ${patientInfo?[1]}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      'Disease: ${patientInfo?[2]}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                )),
            SizedBox(height: 15),
            // Container that holds the patient's diet for the current day
            Container(
              padding: EdgeInsets.all(8),
              height: 140,
              width: 320,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color.fromRGBO(135, 211, 127, 1))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _customTileList(context, 120, 0),
                    _customTileList(context, 120, 1),
                    _customTileList(context, 120, 2),
                    _customTileList(context, 120, 3),
                    _customTileList(context, 120, 4),
                    _customTileList(context, 120, 5),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            // Past meal history
            Text('Past Lists:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color.fromRGBO(135, 211, 127, 1))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${patientPastMealDate![0]}:\n ${patientPastMeal![0]}'),
                  Text('${patientPastMealDate[1]}:\n ${patientPastMeal[1]}')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Displays a dialog for editing the selected meal item
  void _showMealInputDialog(
      BuildContext context, int mealNum, List<String>? patientDiet) {
    TextEditingController mealController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Edit Meal"),
            content: TextField(
              controller: mealController,
              decoration: InputDecoration(
                labelText: "Enter new meal",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // Save new meal
                  if (mealController.text.isNotEmpty) {
                    setState(() {
                      patientDiet![mealNum] = mealController.text;
                      // Update the maps in all necessary files
                      getPatientMealMapping()[widget.name] = patientDiet;
                    });
                  }
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Save"),
              ),
            ],
          );
        });
  }
}
