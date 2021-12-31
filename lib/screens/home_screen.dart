import 'package:deep_link_social_share/models/my_user.dart';
import 'package:deep_link_social_share/models/post.dart';
import 'package:deep_link_social_share/services/firebase_auth_service.dart';
import 'package:deep_link_social_share/services/firestore_service.dart';
import 'package:deep_link_social_share/services/post_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/HomeScreen';
  @override
  Widget build(BuildContext context) {
    print('re-build');
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50.0,
        leading: IconButton(
          onPressed: () {
            final auth =
                Provider.of<FirebaseAuthService>(context, listen: false);
            auth.signOut().then((value) => print('good by!'));
          },
          icon: const Icon(Icons.logout),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  Provider.of<FirestoreService>(context, listen: true).posts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List<Post>;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (_, index) => PostCard(post: data[index]),
                    ),
                  );
                }
                return const Text('No Posts');
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final fs =
                    Provider.of<FirestoreService>(context, listen: false);
                final Post? post = await fs.getPostById(
                    docUID: 'ZoRc4q62wRTGsiL6CmYYt2x3NQX2');
                print(post);
              },
              child: const Text('create post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createRandomPost(String title, BuildContext context) async {
    final user = Provider.of<MyUser>(context, listen: false);
    final db = Provider.of<FirestoreService>(context, listen: false);
    await db.createPost(
      post: Post(
        owner: user.uid,
        title: title,
        content: 'Random Content 2',
        image: 'https://picsum.photos/200',
      ),
    );
  }
}
