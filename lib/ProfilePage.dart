import 'package:flutter/material.dart';
import 'package:the_nomnom_collective/utilities/googleSignIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';
import 'PatientStorage.dart';

// Profilepage widget, representing the user profile screen
class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profilepage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Fetches the patient's information based on the current logged-in user
  Future<Map<String, dynamic>> fetchPatientInfo() async {
    final User? user = auth.currentUser;
    if (user == null) throw Exception("No user is currently signed in.");
    final String uid = user.uid;

    // Fetch patient info using the database helper
    return await DatabaseHelper.instance.getPatientByUID(uid);
  }

  // Custom method to create a container with an icon and a label
  Widget _customContainer(
      BuildContext context, String text, IconData? leadingIcon) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        width: 360,
        height: 50,
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          leading: Icon(leadingIcon, size: 40),
          title: Text(text,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // Builds the profile screen for users signed-in via Google
  Widget bodyForGoogle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Displaying user's profile with their avatar and basic details
        Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('lib/Images/Snack1.jpg'),
              ),
              const SizedBox(width: 25),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mahmut Enişte',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                    const Text('Patient'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Displaying custom containers for various options
              _customContainer(
                context,
                "My Dietitian: Dr. Elif Güler",
                Icons.psychology_alt,
              ),
              _customContainer(
                context,
                "My Conditions: Type-2 Diabetes",
                Icons.no_meals,
              ),
              Divider(
                height: 13,
                thickness: 2,
                indent: 35,
                endIndent: 35,
                color: Colors.amber.shade600,
              ),
              _customContainer(context, "Account Settings", Icons.settings),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Log-out option
              SizedBox(
                height: 50.0,
                width: 360.0,
                child: ListTile(
                  key: const Key('LogOut'),
                  titleAlignment: ListTileTitleAlignment.center,
                  leading: const Icon(Icons.logout, size: 40),
                  title: const Text("Log out",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    await signOutWithGoogle();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Additional settings options
              _customContainer(
                context,
                "Notification Settings",
                Icons.notifications,
              ),
              const SizedBox(height: 10),
              _customContainer(context, "About", Icons.info),
            ],
          ),
        ),
      ],
    );
  }

  // Checks if the user is signed in via Google and displays the appropriate profile layout
  Widget googleChecker() {
    final User? user = auth.currentUser;
    for (final provider in user!.providerData) {
      if (provider.providerId == 'google.com') {
        return bodyForGoogle(context);
      } else {
        // If user is signed in via another method, fetch and display patient info
        return FutureBuilder<Map<String, dynamic>>(
            future: fetchPatientInfo(),
            builder: (context, snapshot) {
              // Handle loading state
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle error state
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              // Ensure snapshot has data
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No patient data found.'));
              }
              final patientData = snapshot.data!;
              final name = patientData['PATIENT_NAME'];
              final surname = patientData['PATIENT_SURNAME'];
              final diseases = (patientData['DISEASES'] as List).join(', ');

              // Displaying profile info and patient data
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('lib/Images/Snack1.jpg'),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$name $surname',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                              const Text('Patient'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Displaying custom containers for options based on Dietitian Data
                        _customContainer(
                          context,
                          "My Dietitian: Dr. Elif Güler",
                          Icons.psychology_alt,
                        ),
                        _customContainer(
                          context,
                          "My Conditions: $diseases",
                          Icons.no_meals,
                        ),
                        Divider(
                          height: 13,
                          thickness: 2,
                          indent: 35,
                          endIndent: 35,
                          color: Colors.amber.shade600,
                        ),
                        _customContainer(
                            context, "Account Settings", Icons.settings),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Log-out option
                        SizedBox(
                          height: 50.0,
                          width: 360.0,
                          child: ListTile(
                            key: const Key('LogOut'),
                            titleAlignment: ListTileTitleAlignment.center,
                            leading: const Icon(Icons.logout, size: 40),
                            title: const Text("Log out",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            onTap: () async {
                              await signOutWithGoogle();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Additional settings options
                        _customContainer(
                          context,
                          "Notification Settings",
                          Icons.notifications,
                        ),
                        const SizedBox(height: 10),
                        _customContainer(context, "About", Icons.info),
                      ],
                    ),
                  ),
                ],
              );
            });
      }
    }
    return SizedBox();
  }

  // Builds the profile layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 232, 1),
        body: googleChecker());
  }
}
