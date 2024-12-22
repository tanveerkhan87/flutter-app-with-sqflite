import 'package:database/services/database_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseServices dbService = DatabaseServices();
  TextEditingController nCon = TextEditingController();
  TextEditingController regCon = TextEditingController();
  TextEditingController pCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Database"),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: "Name"),
            controller: nCon,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Reg No"),
            controller: regCon,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Phone"),
            controller: pCon,
          ),
          ElevatedButton(onPressed: addRecords, child: Text("Add")),
          Expanded(child: StudentsList())
        ],
      ),
    );
  }

  Widget StudentsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: dbService.getStudents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("No Records Found"),
            );
          } else {
            final students = snapshot.data!;
            return ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final std = students[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          std["name"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(std["reg_no"]),
                        Text(std["cell_no"]),

                         Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             IconButton(
                               onPressed: () {
                                 deleteRecord(std["reg_no"]);
                               },
                               icon: Icon(Icons.delete),
                             ),



                           ],
                         )
                      ],
                    ),
                  );
                });
          }
        });
  }

  void addRecords() async {
    await dbService.addStudent(nCon.text, regCon.text, pCon.text);
    nCon.clear();
    pCon.clear();
    regCon.clear();
    setState(() {}); // Refresh the UI after adding a record
    print("added");
  }

  void deleteRecord(String regNo) async {
    await dbService.deleteStudent(regNo);
    setState(() {}); 
    print("DElelted");// Refresh UI after deletion
  }


  void printRecords() async {
    await dbService.getStudents();
  }
}