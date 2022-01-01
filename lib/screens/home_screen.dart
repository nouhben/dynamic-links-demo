import 'dart:math';

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
    print('HomeScreen | re-build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
        leadingWidth: 50.0,
        elevation: 0.0,
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
              onPressed: () => _createRandomPost(context),
              child: const Text('add random post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createRandomPost(BuildContext context) async {
    final user = Provider.of<MyUser>(context, listen: false);
    Random rnd = Random();
    int n = rnd.nextInt(100);
    final fs = Provider.of<FirestoreService>(context, listen: false);
    final Post post = Post(
      title: 'Title Random $n',
      owner: user.uid,
      content: 'random content $n',
      image: 'https://picsum.photos/200',
    );
    await fs.createPost(post: post);
  }
}
