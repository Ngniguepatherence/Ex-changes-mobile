import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:start/screen/verification.dart';

import '../../widget/custom_Text_Form_fild.dart';
import '../model/user.dart';
import '../utils/user_preferences.dart';
import '../widget/appbar_widget.dart';

import '../widget/profileW.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../homw.dart';

class EditProfilePage extends StatefulWidget {
  late String image;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Users user = UserPreferences.myUser;
  late String image =
      'https://images.unsplash.com/photo-1554151228-14d9def656e4?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=333&q=80';
  final ImagePicker picker = ImagePicker();
  String _fileText = "";
  String profileImagePath = 'profile.jpeg';

  late final TextEditingController _phone = TextEditingController();
  final TextEditingController UserController = TextEditingController();
  final TextEditingController FullController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController CNIController = TextEditingController();
  final TextEditingController AboutController = TextEditingController();

  void myAlert(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Builder(
          builder: (context) => Scaffold(
            appBar: buildAppBar(context),
            body: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32),
              physics: BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                  imagePath: image != '' ? image : user.imagePath,
                  isEdit: true,
                  onClicked: () {
                    myAlert(context);
                    print(image);
                  },
                ),
                const SizedBox(height: 24),
                CostomTextFormFild(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your username";
                    } else {
                      return null;
                    }
                  },
                  hint: "Enter your Username",
                  controller: UserController,
                  prefixIcon: IconlyBroken.add_user,
                ),
                CostomTextFormFild(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your full name";
                    } else {
                      return null;
                    }
                  },
                  hint: "Enter Full Name",
                  controller: FullController,
                  prefixIcon: IconlyBroken.profile,
                ),
                const SizedBox(height: 10),
                CostomTextFormFild(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your email";
                    } else {
                      return null;
                    }
                  },
                  hint: "Email",
                  controller: EmailController,
                  prefixIcon: IconlyBroken.message,
                ),
                const SizedBox(height: 10),
                CostomTextFormFild(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter cni/passport";
                    } else {
                      return null;
                    }
                  },
                  hint: "CNI/PASS Number",
                  controller: CNIController,
                  prefixIcon: IconlyBroken.document,
                ),
                const SizedBox(height: 14),
                IntlPhoneField(
                  controller: _phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                  ),
                  initialCountryCode: 'CM',
                  onChanged: (phone) {
                    print(phone.completeNumber);
                  },
                ),
                const SizedBox(height: 0),
                CostomTextFormFild(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter about";
                    } else {
                      return null;
                    }
                  },
                  hint: "About you",
                  controller: AboutController,
                  prefixIcon: IconlyBroken.message,
                ),
                MaterialButton(
                  onPressed: () {
                    _pickMultipleFiles();
                  },
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Upload CNI/Pass",
                    style: TextStyle(
                        fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final username = UserController.text;
                    final fullname = FullController.text;
                    final email = EmailController.text;
                    final CNI = CNIController.text;
                    final phone = _phone.text;
                    final about = AboutController.text;
                    _addProfile(
                        username: username,
                        fullname: fullname,
                        email: email,
                        CNI: CNI,
                        phone: phone,
                        about: about);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerificationCode()));
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      );

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'pdf', 'doc', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      /// Load result and file details
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);

      /// normal file
      File _file = File(result.files.single.path!);
      setState(() {
        _fileText = _file.path;
      });
    } else {
      /// User canceled the picker
    }
  }

  void _pickMultipleFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      setState(() {
        _fileText = files.toString();
      });
    } else {
      // User canceled the picker
    }
  }

  void _pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        _fileText = selectedDirectory;
      });
    } else {
      // User canceled the picker
    }
  }

  /// currently only supported for Linux, macOS, Windows
  /// If you want to do this for Android, iOS or Web, watch the following tutorial:
  /// https://youtu.be/fJtFDrjEvE8
  void _saveAs() async {
    if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
      return;
    }

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'output-file.pdf',
    );

    if (outputFile == null) {
      // User canceled the picker
    }
  }

  Future _addProfile(
      {required String username,
      required String fullname,
      required String email,
      required String CNI,
      required String phone,
      required String about}) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('profiles').add(
      {
        'Username': username,
        'FullName': fullname,
        'Email': email,
        'CNI/Pass': CNI,
        'PhoneNumber': phone,
        'About': about
      },
    );
    String UserId = docRef.id;
    await FirebaseFirestore.instance.collection('profiles').doc(UserId).update(
      {'id': UserId},
    );
    // _clearAll();
  }

  Future getImage(ImageSource media) async {
    final _firebaseStorage = FirebaseStorage.instance;
    final ImagePicker _imagePicker = ImagePicker();
    PickedFile? photo;
    photo = await _imagePicker.getImage(source: media);
    var file = File(photo!.path);
    // XFile? _file = await _imagePicker.pickImage(source: media);

    if (photo != null) {
      var snapshot =
          await _firebaseStorage.ref().child('images/imageName').putFile(file);
      var downloadurl = await snapshot.ref.getDownloadURL();
      print(downloadurl);
      image = downloadurl;
    } else {
      print("No Image path received");
    }
  }
}
