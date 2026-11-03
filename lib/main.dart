import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// USER DATA MODEL
class User {
  final String name;
  final String registrationNumber;
  final double mark1;
  final double mark2;
  final double mark3;

  User({
    required this.name,
    required this.registrationNumber,
    required this.mark1,
    required this.mark2,
    required this.mark3,
  });

  double get total => mark1 + mark2 + mark3;

  double get average => total / 3;

  double get percentage => (total / 300) * 100;
}

// MAIN APPLICATION
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Performance',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}

// HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController regNoController =
      TextEditingController();

  final TextEditingController mark1Controller =
      TextEditingController();

  final TextEditingController mark2Controller =
      TextEditingController();

  final TextEditingController mark3Controller =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    regNoController.dispose();
    mark1Controller.dispose();
    mark2Controller.dispose();
    mark3Controller.dispose();
    super.dispose();
  }

  // NAVIGATE TO RESULT SCREEN
  void navigateToResult() {
    if (_formKey.currentState!.validate()) {
      final user = User(
        name: nameController.text.trim(),
        registrationNumber: regNoController.text.trim(),
        mark1: double.parse(mark1Controller.text),
        mark2: double.parse(mark2Controller.text),
        mark3: double.parse(mark3Controller.text),
      );

      Navigator.pushNamed(
        context,
        '/second',
        arguments: user,
      );
    }
  }

  // TEXT FIELD
  Widget buildTextField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  // MARKS FIELD
  Widget buildMarkField(
    TextEditingController controller,
    String label,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.book),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }

          final mark = double.tryParse(value.trim());

          if (mark == null || !mark.isFinite ||
              mark < 0 || mark > 100) {
            return 'Enter a mark between 0 and 100';
          }

          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.school,
                size: 80,
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 15),

              const Text(
                'Enter Student Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // STUDENT NAME
              buildTextField(
                nameController,
                'Student Name',
              ),

              // REGISTRATION NUMBER
              buildTextField(
                regNoController,
                'Registration Number',
              ),

              // SUBJECT MARKS
              buildMarkField(
                mark1Controller,
                'Subject 1 Mark',
              ),

              buildMarkField(
                mark2Controller,
                'Subject 2 Mark',
              ),

              buildMarkField(
                mark3Controller,
                'Subject 3 Mark',
              ),

              const SizedBox(height: 15),

              // VIEW RESULT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: navigateToResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View Result >>',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SECOND SCREEN - STUDENT RESULT
class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,

      appBar: AppBar(
        title: const Text('Student Result'),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const Icon(
              Icons.workspace_premium,
              size: 75,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 15),

            const Text(
              'Academic Performance',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // RESULT CARD
            Card(
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Student Name'),
                      subtitle: Text(user.name),
                    ),

                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('Registration Number'),
                      subtitle: Text(user.registrationNumber),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.book),
                      title: const Text('Subject 1'),
                      trailing: Text(
                        user.mark1.toStringAsFixed(2),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.book),
                      title: const Text('Subject 2'),
                      trailing: Text(
                        user.mark2.toStringAsFixed(2),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.book),
                      title: const Text('Subject 3'),
                      trailing: Text(
                        user.mark3.toStringAsFixed(2),
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      leading: const Icon(Icons.calculate),
                      title: const Text('Total Marks'),
                      trailing: Text(
                        user.total.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.analytics),
                      title: const Text('Average'),
                      trailing: Text(
                        user.average.toStringAsFixed(2),
                      ),
                    ),

                    ListTile(
                      leading: const Icon(Icons.percent),
                      title: const Text('Percentage'),
                      trailing: Text(
                        '${user.percentage.toStringAsFixed(2)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // BACK BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 17),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}