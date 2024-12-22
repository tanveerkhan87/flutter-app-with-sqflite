
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseServices{
  static Database? db;

  // get data base or u name it anything function through we create data base
  Future <Database>getDatabase() async{
     final dbDirPath = await getDatabasesPath();

     //join function add two directories or directory and file  to make complete path
     final dbPath =  join( dbDirPath, "student_db.db");

     //for the creation of database we use open database function
    final database =  await openDatabase(
      dbPath,
      onCreate: (db , version){
        //first we have to create tables
        //like name of db is student and its info is  name ,reg no etc
         db.execute("CREATE TABLE students(reg_no TEXT, name TEXT, cell_no TEXT)");
      },
      version: 1
    );
  return database;
  }


 Future<Database> getDB() async {
    if(db== null)
      db= await getDatabase();
      return db!;
    }
  Future<void> addStudent(String name, String reg_no, String cell_no) async {
    final db = await getDB();
    await db.insert(
      "students",
      {"name": name, "reg_no": reg_no, "cell_no": cell_no},
    );
  }

  Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await getDB();
    final data = await db.query("students");
    return data;
  }


// we her euse regno as id because it will be unique of each students
  Future<void> deleteStudent(String regNo) async {
    final db = await getDB();
    await db.delete(
      'students',
      where: 'reg_no = ?',
      whereArgs: [regNo],
    );
  }


}