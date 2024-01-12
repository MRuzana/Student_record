import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project3/db/functions/db_functions.dart';
import 'package:project3/db/model/data_model.dart';
import 'package:project3/screens/screen_list_details.dart';

class EditProfile extends StatefulWidget {
  StudentModel studentModel;
  EditProfile({super.key, required this.studentModel});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _placeController = TextEditingController();
  final _phController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;

   void select_image()async{
    Uint8List img= await pick_image(ImageSource.gallery);
    if(img!=null){
      setState(() {
        _image=img;
      });
    }
  }
  
  @override
  void initState() {
    _nameController.text = widget.studentModel.name;
    _ageController.text = widget.studentModel.age;
    _placeController.text = widget.studentModel.place;
    _phController.text = widget.studentModel.mobile;
    _image=widget.studentModel.image;
  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int id = widget.studentModel.id!;
    return Scaffold(
      //resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: const Text(
          'Edit details',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 126, 202, 128),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                        IconButton(onPressed: (){
                          select_image();
                        },
                         icon:const  Icon(Icons.add_a_photo,color: Color.fromARGB(255, 126, 202, 128),)),
                        _image!=null ?
                          CircleAvatar(
                          radius: 80,
                           backgroundImage: MemoryImage(_image!),
                          ):

                         const CircleAvatar(
                         radius: 80,
                        backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                         )
                         

                       ],
                     ),
                   ),

                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 126, 202, 128))),
                        hintText: 'name',
                        hintStyle:  TextStyle(
                            color: Color.fromARGB(255, 126, 202, 128))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name should not be empty';
                      } 
                      else if(!RegExp(r"^[a-zA-Z'-\s]+$").hasMatch(value)){
                          return 'Enter valid name ';
                        }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 126, 202, 128))),
                        hintText: 'Age',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 126, 202, 128))),
                    validator: (value) {
                      //print('null');
                      if (value == null || value.isEmpty) {
                        return 'Age should not be empty';
                      }
                      else if(!RegExp(r'^[0-9]+$').hasMatch(value)){
                        return 'Enter valid age';

                      }
                       else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    controller: _placeController,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 126, 202, 128))),
                        hintText: 'place',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 126, 202, 128))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'place should not be empty';
                      }
                      else if(!RegExp(r"^[a-zA-Z'-\s]+$").hasMatch(value)){
                          return 'Enter valid place ';
                        }
                       else {
                        return null;
                      }
                    },
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phController,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 126, 202, 128))),
                        hintText: 'Mobile number',
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 126, 202, 128))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mobile number should not be empty';
                      } else if (!RegExp(r"^(?:\+91)?[0-9]{10}$")
                          .hasMatch(value)) {
                        return 'enter valid mobile number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          OnEdit(context, id);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 126, 202, 128),
                      ),
                      child: const Text(
                        'UPDATE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> OnEdit(BuildContext context, int id) async {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final place = _placeController.text.trim();
    final mobile = _phController.text.trim();

    if (name.isEmpty || age.isEmpty || place.isEmpty || mobile.isEmpty||_image==null) {
      return;
    }

   StudentModel(name: name, age: age, mobile: mobile, place: place, id: id,image: _image);
   editStudent(id, name, age, place, mobile, _image!);
    
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ListDetails()));
    print('name $name');
  }

pick_image(ImageSource source)async {
   final ImagePicker imagePicker=ImagePicker();
   XFile? _file=await imagePicker.pickImage(source: source);
   if(_file!=null){
    return await _file.readAsBytes();
   }
   else{
    
    print('no images');
    return null;
   }
  }
}
