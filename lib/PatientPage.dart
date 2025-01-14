import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_nomnom_collective/DynamicDetailPage.dart';
import 'package:the_nomnom_collective/MealData.dart';

// This is the StatefulWidget for the PatientPage
class Patientpage extends StatefulWidget {
  const Patientpage({super.key});

  @override
  State<Patientpage> createState() => _PatientpageState();
}

// State class for the PatientPage
class _PatientpageState extends State<Patientpage> {
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'Aslı',
      'surname': 'Güngören',
      'email': 'asligngrn56@hotmail.com',
      'disease': 'Celiac',
      'meals': ['Breakfast', 'Snack1', 'Lunch', 'Snack2', 'Dinner', 'Snack3'],
    },
    {
      'name': 'Cengiz',
      'surname': 'Türker',
      'email': 'cngzturker26@hotmail.com',
      'disease': 'Obese',
      'meals': ['Breakfast', 'Snack1', 'Lunch', 'Snack2', 'Dinner', 'Snack3'],
    },
    {
      'name': 'Burcu',
      'surname': 'Çakıltaş',
      'email': 'burcuckltas45@hotmail.com',
      'disease': 'Pregnant',
      'meals': ['Breakfast', 'Snack1', 'Lunch', 'Snack2', 'Dinner', 'Snack3'],
    },
    {
      'name': 'Mahmut',
      'surname': 'Çiftbakır',
      'email': 'mahmutcftbkr86@hotmail.com',
      'disease': 'Diabetic',
      'meals': ['Breakfast', 'Snack1', 'Lunch', 'Snack2', 'Dinner', 'Snack3'],
    },
  ];

  // This function builds a custom tile to represent each patient in the list.
  Widget _customTileList(
      BuildContext context, double height, String name, String surname) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(0.5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
          height: height,
          child: ListTile(
            leading: Icon(Icons.person),
            titleAlignment: ListTileTitleAlignment.center,
            title: StrokeText(
              textAlign: TextAlign.start,
              text: '$name $surname',
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              strokeColor: Color.fromRGBO(244, 244, 232, 1),
              strokeWidth: 4,
            ),
            // This function navigates to the patient details page when the tile is tapped.
            onTap: () => dynamicPatientPage(name, surname),
          ),
        )
      ],
    );
  }

  // This method builds the entire PatientPage widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 232, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _patients.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              // Add "Active Patients" text at the top
              return Padding(
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  'Active Patients',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              );
            }
            final patient = _patients[index - 1];
            return Column(
              children: [
                // Display each patient's tile
                _customTileList(
                    context, 40, patient['name'], patient['surname']),
                Divider(
                  height: 13,
                  thickness: 2,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.amber.shade300,
                ),
              ],
            );
          },
        ),
      ),
      // Floating action button to add a new patient.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPatientDialog(context),
        backgroundColor: Color.fromRGBO(135, 211, 127, 1),
        child: Icon(Icons.add),
      ),
    );
  }

  // Navigates to the dynamic patient details page when a patient's name is tapped.
  Future<void> dynamicPatientPage(String name, String surname) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => DetailPage(name: name, surname: surname)),
    );
  }

  // This function shows a bottom sheet to add a new patient to the list.
  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final ageController = TextEditingController();
    final emailController = TextEditingController();
    final diseaseController = TextEditingController();
    final mealsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: surnameController,
                decoration: InputDecoration(labelText: 'Surname'),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                controller: diseaseController,
                decoration: InputDecoration(labelText: 'Disease'),
              ),
              TextField(
                controller: mealsController,
                decoration: InputDecoration(
                  labelText: 'Meals (comma-separated)',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final surname = surnameController.text.trim();
                  final age = ageController.text.trim();
                  final email = emailController.text.trim();
                  final disease = diseaseController.text.trim();
                  final meals = mealsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .toList();

                  // Validate fields to avoid null errors later
                  if (name.isEmpty || surname.isEmpty || meals.isEmpty) {
                    // Show a snackbar if validation fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  setState(() {
                    // Update maps consistently
                    MealData.patientMealMap[name] = meals;
                    MealData.patientPastMealMap[name] = [
                      [
                        'Omlette',
                        'Dates + Walnuts',
                        'Tomato Soup',
                        'Smoothie',
                        'Turkish Dumplings',
                        'Mini Carrots'
                      ],
                      [
                        'Menemen',
                        'Sorbet',
                        'Yogurt Soup',
                        'Fruit Salad',
                        'Roasted Chicken',
                        'Mixed Nuts'
                      ]
                    ];
                    MealData.patientPastMealDateMap[name] = [
                      '30.11.2024',
                      '18.06.2024'
                    ];
                    MealData.patientInfo[name] = [email, age, disease];

                    // Add to patients list
                    _patients.add({
                      'name': name,
                      'surname': surname,
                      'email': email,
                      'disease': disease,
                      'meals': meals,
                    });
                  });
                  Navigator.pop(context); // Close the modal
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
