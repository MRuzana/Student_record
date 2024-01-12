import 'dart:typed_data';

import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:project3/db/model/data_model.dart';
import 'package:project3/db/functions/db_functions.dart';
import 'package:project3/screens/edit_profile.dart';
import 'package:project3/screens/screen_add_details.dart';
import 'package:project3/screens/screen_profile.dart';

class ListDetails extends StatelessWidget {
  late StudentModel studentModel;
  final ValueNotifier<bool>isGridViewNotifier =ValueNotifier(false);

  ListDetails({super.key});

  @override
  Widget build(BuildContext context) {

    getAllStudents();
  
    return Scaffold(
      appBar: EasySearchBar(
        actions: [
          IconButton(onPressed: (){
            
           
            isGridViewNotifier.value = !isGridViewNotifier.value;
            getAllStudents();
            print('Grid icon pressed');
          }, icon: const Icon(Icons.view_module))
        ],
       
          title: const Text(
            'Student list',
            style: TextStyle(color: Colors.white),
          ),
          
          iconTheme: const IconThemeData(color: Colors.white),
          
          onSearch: (value)async {
            List<StudentModel> students = await searchPersons(value);
            print('the result $students');
            studentlistNotifier.value = students;

          },
          
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          
          valueListenable: studentlistNotifier,
          builder: (BuildContext ctx, List<StudentModel> studentList,
              Widget? child) {
                if(studentList.isEmpty){
                  return  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15) ,
                          color: const Color.fromARGB(255, 126, 202, 128),
                        ),
                        
                        width: double.infinity,
                        height: 50,
                        
                        child: const Center(child: Text('No student',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 19),
                        
                        ))),
                    ),
                  );
                }
            else  {  
                 return isGridViewNotifier.value?
                
                GridView.builder(
                
                  gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(
                   
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 220
                  
                    ),
                    padding: const EdgeInsets.all(10),
                  itemBuilder: (context,index){
                    final data = studentList[index];
                    return  GestureDetector(
                      onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Profile(
                           studentModel: studentList[index],
                          )));
                        
                      },
                      child: GridTile(
                        child: Container(
                          color: Colors.grey,
                          
                          child:   Column(
                            children: [
                               Padding(
                                padding:  const EdgeInsets.all(8.0),
                                child:  CircleAvatar(
                                  backgroundImage:MemoryImage(data.image!),
                                  radius: 40,
                                ),
                              ),
                               Text(data.name,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white
                              ),),
                               Text(data.age,
                              style:const  TextStyle(
                                fontSize: 20,
                                color: Colors.white
                              ),),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(onPressed: (){
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => EditProfile(studentModel: studentList[index])
                                        )
                                      );
                                  }, icon: Icon(Icons.edit,color: Colors.white,)),
                                  IconButton(onPressed: (){
                                    deleteAlert(context, studentList[index].id!);
                                    
                                  }, icon: Icon(Icons.delete,color: Colors.red,)),
                                ],
                              ),
                            ]
                          ),
                        ), 
                      ),
                    );
                  },
                  itemCount: studentList.length,
              
                )
            
             : ListView.separated(
                itemBuilder: (context, index) {
                  final data = studentList[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Profile(
                                studentModel: studentList[index],
                              )));
                    },
                   
                    leading:  CircleAvatar(
                      backgroundImage:MemoryImage(data.image!)
                     
                      
                      // backgroundImage: NetworkImage(
                      //     'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                      ,radius: 30,
                    ),
                    title: Text(data.name),
                    subtitle: Text(data.age),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                          
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditProfile(
                                      studentModel: studentList[index],
                                    )));
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 126, 202, 128),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            deleteAlert(context, studentList[index].id!);
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: studentList.length);
             

            }


          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddDetails()));
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}

deleteAlert(BuildContext context, int id) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Do you want to delete?'),
          actions: [
            TextButton(
                onPressed: () {
                  deleteStudent(id);
                  Navigator.of(context).pop();
                },
                child: const Text('YES')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('NO')),
          ],
        );
      });
}

editAlert(BuildContext context, int id, String name, String age, String place,
    String mobile,Uint8List image) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Do you want to edit?'),
          actions: [
            TextButton(
                onPressed: () {
                  editStudent(id, name, age, place, mobile,image);
                  Navigator.of(context).pop();
                },
                child: const Text('YES')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('NO')),
          ],
        );
      });
}






