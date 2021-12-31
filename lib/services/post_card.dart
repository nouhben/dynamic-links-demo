import 'package:flutter/material.dart';

import 'package:deep_link_social_share/models/post.dart';
import 'package:deep_link_social_share/services/dynamic_links_service.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PostDetailsScreen(post: post),
            ),
          );
        },
        onLongPress: () async {
          final ds = Provider.of<DynamicLinkService>(context, listen: false);
          final result = await ds.create(post: post);
          print(result.queryParameters);
          Share.share(result.toString());
        },
        leading: Image.network(post.image, width: 80.0),
        title: Text(post.title, style: Theme.of(context).textTheme.headline4),
        contentPadding: const EdgeInsets.all(10),
        subtitle: Text(
          post.content,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({
    Key? key,
    required this.post,
  }) : super(key: key);
  final Post post;
  static const String routeName = '/PostDetailsScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        margin: const EdgeInsets.all(20.0),
        elevation: 5.0,
        child: ListTile(
          onLongPress: () {},
          leading: Image.network(
            post.image,
            width: 80.0,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 80.0,
              height: 80.0,
              color: Colors.grey,
            ),
          ),
          title: Text(post.title, style: Theme.of(context).textTheme.headline4),
          contentPadding: const EdgeInsets.all(20),
          subtitle: Text(
            post.content,
            style: Theme.of(context).textTheme.caption,
          ),
          trailing: IconButton(
            onPressed: () {
              print('share post');
            },
            icon: const Icon(Icons.share),
          ),
        ),
      ),
    );
  }
}
