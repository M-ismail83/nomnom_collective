import 'package:flutter/material.dart';
import 'package:the_nomnom_collective/utilities/googleSignIn.dart';
import 'LoginPage.dart';

class DietProfilePage extends StatefulWidget {
  const DietProfilePage({super.key});

  @override
  State<DietProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<DietProfilePage> {
  // Creates a custom container widget with text and an optional leading icon
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

  // Builds the main body layout for users signed in with Google
  Widget bodyForGoogle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Displays user profile information including avatar, name and role
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
                    Text('Elif Güler',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                    const Text('Dietitian'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Displays log out button and additional options
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _customContainer(context, "Account Settings", Icons.settings),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                  // Logs the user out and navigates to the login page
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
              // Displays notification settings options
              _customContainer(
                context,
                "Notification Settings",
                Icons.notifications,
              ),
              const SizedBox(height: 10),
              // Display about option
              _customContainer(context, "About", Icons.info),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 232, 1),
        body: bodyForGoogle(context));
  }
}
