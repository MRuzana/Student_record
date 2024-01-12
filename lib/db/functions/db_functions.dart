

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project3/db/model/data_model.dart';
import 'package:sqflite/sqflite.dart';


ValueNotifier<List<StudentModel>> studentlistNotifier = ValueNotifier([]);
late Database _db;

Future<void> openDb()async{
_db= await openDatabase('student.db',version: 1,onCreate: (Database db, int version) async {

 await db.execute('CREATE TABLE student (id INTEGER PRIMARY KEY,name TEXT,age TEXT,place TEXT,mobile TEXT,image BLOB)');
   
 },);


}
Future <void> addstudent(StudentModel value)async{
  await _db.rawInsert(
  'INSERT INTO student (name,age,place,mobile,image) VALUES (?,?,?,?,?)',[value.name,value.age,value.place,value.mobile,value.image]);
  getAllStudents();
  studentlistNotifier.notifyListeners();
}

Future<List<StudentModel>> searchPersons(String searchText) async {
  
  final result = await _db.query('student',
      where: 'name LIKE ?', whereArgs: ['%$searchText%']);
      return result.map((e) {
       return StudentModel.fromMap(e);
      }).toList();

     
}

Future <void>getAllStudents()async{
 
  final _values = await _db.rawQuery('SELECT * FROM student');
 // print(' values $_values');

  studentlistNotifier.value.clear();
  for (var map in _values) {
    final student=StudentModel.fromMap(map);
    studentlistNotifier.value.add(student);
    studentlistNotifier.notifyListeners();
    
   }
}


Future<void> editStudent(int id,String name, String age ,String place ,String mobile,Uint8List image) async {
	await _db.rawUpdate('UPDATE student SET name = ?, age = ? ,place = ?, mobile= ?,image =? WHERE id = ?',[name, age,place,mobile,image,id]);
	getAllStudents();
  studentlistNotifier.notifyListeners();
}

Future<void> deleteStudent(int id) async {
	await _db.rawDelete('DELETE FROM student WHERE id = ?', [id]); 
	getAllStudents();
  studentlistNotifier.notifyListeners();
}

