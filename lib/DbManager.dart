

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

 class Dbstudents
{
  Database database;

  Future opendb() async
  {
    if (database == null) {
      database = await openDatabase(
          join(await getDatabasesPath(), "student.db"),
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute("CREATE TABLE student (id INTEGER PRIMARY KEY autoincrement, name TEXT, course TEXT)" );
          }
      );
    }
  }

  Future<int> insertStudent(Student student) async
  {
    await opendb();

    return await  database.insert('student', student.tomap());
  }

   Future<List<Student>> getStudentlist() async
  {
    await opendb();

    final List<Map<String, dynamic>> maps = await database.query('student');

    return List.generate(maps.length, (i){
          return Student(
            id: maps[i]['id'],
            name: maps[i]['name'],
            course: maps[i]['course']
          );
        });
  }

  Future<int> updateStudent(Student student) async
  {
    await opendb();
    return await database.update('student',student.tomap(), where: "id = ?" ,whereArgs: [student.id]);
  }

  Future<void> deleteStudent(int id) async
  {
    await opendb();

    await database.delete('student', where: "id = ?" ,whereArgs: [id]);
  }

}

class Student
{
  int id;
  String name;
  String course;

  Student({@required this.name,@required this.course, @required this.id});
  Map<String,dynamic> tomap()
  {
    return{'id': id,'name': name,'course': course};
  }
}