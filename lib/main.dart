import 'package:flutter/material.dart';
import 'package:student_dio/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
       appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff16E5Af),
       ),
      primaryColor: const Color(0xff16E5Af),
          inputDecorationTheme:
              const InputDecorationTheme(border: OutlineInputBorder()),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: const Color(0xff16E5Af))),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ressult = await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return _AddStudentForm();
            },
          ));
          setState(() {});
        },
        label: const Row(
          children: [Icon(Icons.add), Text('Add Student')],
        ),
      ),
      body: FutureBuilder<List<StudentData>>(
        future: getStudent(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
              
                return _Student(
                  studentData: snapshot.data![index],
                );
              },
            );
          } else {}
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _Student extends StatelessWidget {
  final StudentData studentData;
  const _Student({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05))
          ]),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xff16E5Af).withOpacity(0.1),
            ),
            child: Text(
              studentData.firstName.characters.first +
                  studentData.lastName.characters.first,
              style: const TextStyle(
                  color: Color(0xff16E5Af),
                  fontWeight: FontWeight.w900,
                  fontSize: 24),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(studentData.firstName + ' ' + studentData.lastName),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                  child: Text(
                    studentData.course,
                    style: const TextStyle(fontSize: 10),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.grey[200]),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: Colors.grey.shade400,
              ),
              Text(
                studentData.score.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}

class _AddStudentForm extends StatelessWidget {
  _AddStudentForm({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _scoreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Student'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            final newStudentData = await saveStudent(
                _firstNameController.text,
                _lastNameController.text,
                _courseController.text,
                int.parse(_scoreController.text));
            Navigator.pop(context, newStudentData);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        label: const Row(
          children: [Icon(Icons.check), Text('Save')],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(label: Text('First Name')),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(label: Text('Last Name')),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(label: Text('Course')),
            ),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _scoreController,
              decoration: const InputDecoration(label: Text('Score')),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
