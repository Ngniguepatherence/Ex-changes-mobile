import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataFetcher extends StatelessWidget {
  final String selectedEmail;

  UserDataFetcher({required this.selectedEmail});

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserDataStream() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference usersRef = firestore.collection('profiles');

    return usersRef.where('email', isEqualTo: selectedEmail).snapshots()
        as Stream<QuerySnapshot<Map<String, dynamic>>>;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: getUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot =
              snapshot.data!.docs.first;
          Map<String, dynamic> userData = documentSnapshot.data();
          // Faire quelque chose avec les données récupérées
          return Column(
            children: [
              Text('Email: ${userData['Email']}'),
              Text('Nom: ${userData['Username']}'),
              // Autres champs...
            ],
          );
        } else if (snapshot.hasError) {
          return Text('Erreur de récupération des données.');
        } else {
          return Text('Aucune donnée disponible pour cet email.');
        }
      },
    );
  }
}

class UserModel {
  final String? id;
  final String fullname;
  final String email;
  final String phoneNo;

  const UserModel({
    this.id,
    required this.email,
    required this.fullname,
    required this.phoneNo,
  });

  toJson() {
    return {"Fullname": fullname, "Email": email, "Phone": phoneNo};
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        email: data["Email"],
        fullname: data["FullName"],
        phoneNo: data["PhoneNumber"]);
  }
}
