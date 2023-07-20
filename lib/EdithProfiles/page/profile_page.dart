import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/EdithProfiles/page/edith.dart';
import '../model/Profile.dart';
import '../model/user.dart';
import '../page/edit_profile_page.dart';
import '../utils/user_preferences.dart';
import '../widget/appbar_widget.dart';
import '../widget/button_widget.dart';
import '../widget/numbers_widget.dart';
import '../widget/profileW.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/database_manager.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User? user;
  late String username;
  late String profile = '';
  Future<void> downloadURLExample() async {
    var downloadURL = await FirebaseStorage.instance
        .ref()
        .child('images/imageName')
        .getDownloadURL();
    profile = downloadURL;
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .where('email', isEqualTo: email)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  XFile? image;
  final ImagePicker picker = ImagePicker();
  final email = FirebaseAuth.instance.currentUser?.email;
  final name = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;
    final firestore = FirebaseFirestore.instance;
    return Material(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: FutureBuilder(
            future: FireStoreDataBase().getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text(
                  "Something went wrong",
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final image = NetworkImage(snapshot.data.toString());
                return ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                image: image,
                                fit: BoxFit.cover,
                                width: 128,
                                height: 128,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildName(user),
                    const SizedBox(height: 24),
                    Center(child: buildUpgradeButton()),
                    const SizedBox(height: 24),
                    //
                    buildAbout(user),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget buildImage(images) {
    final image = NetworkImage(images);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }

  Widget buildName(Users user) => Column(
        children: [
          Text(
            name!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            email!,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildUpgradeButton() => ButtonWidget(
        text: 'Edith Profile',
        onClicked: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditProfilePages()),
          );
        },
      );

  Widget buildAbout(Users user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
