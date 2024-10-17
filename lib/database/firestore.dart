/*content
 message email timestamp 
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDatabase {
  // current logout in user
  User? user = FirebaseAuth.instance.currentUser;
  // get collection of post
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  // post message
  Future<void> addPost(String message) {
    return posts.add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now()
    });
  }

  // read post
  Stream<QuerySnapshot> getPostStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}
