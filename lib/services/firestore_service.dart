import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_link_social_share/models/post.dart';

class FirestoreService {
  FirestoreService({required this.uid});
  final String uid;
  final _posts = FirebaseFirestore.instance.collection('posts');
  Future<void> createPost({required Post post}) async {
    try {
      //final ref = FirebaseFirestore.instance.doc('posts/$uid');
      _posts.add(post.toMap());
      //ref.set(post.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.toList().map((doc) {
      return Post.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Stream<List<Post>> get posts => _posts.snapshots().map(_postListFromSnapshot);

  Future<Post?> getPostById({required String docUID}) async {
    try {
      _posts.doc(docUID).get().then(
        (DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Firestore | Document data: ${documentSnapshot.data()}');
            return Post.fromMap(
                documentSnapshot.data() as Map<String, dynamic>);
          } else {
            print('Firestore | Document does not exist on the database');
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }
}
