import 'package:deep_link_social_share/models/post.dart';
import 'package:deep_link_social_share/services/firestore_service.dart';
import 'package:deep_link_social_share/services/post_card.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 2 cases: first one is when the app is opened from a dynamic link
/// the second one is when the app is brought from the background to the foreground using a dynamic link
/// like when the link is opened on the browser
/// [https://firebase.flutter.dev/docs/dynamic-links/usage]
class DynamicLinkService {
  Post _getPost({
    required PendingDynamicLinkData data,
    required BuildContext context,
  }) {
    // final fs = Provider.of<FirestoreService>(context, listen: false);

    // final Post? post = await fs.getPostById(docUID: uid);
    final Post post = Post(
      content: data.link.queryParameters['content']!,
      owner: data.link.queryParameters['post']!,
      title: data.link.queryParameters['title']!,
      image: data.link.queryParameters['image']!,
    );
    return post;
  }

  Future<void> handle(BuildContext context) async {
    // 1- Terminated State = get the initial dynamic link if the app is started from a dynamic link after being closed
    // i.e: allows us to retrieve the Dynamic Link that opened the application.
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print(
        'Dynamic links Cold: ' + deepLink.queryParameters.toString(),
      ); //Retrieve the target post
      // final Post post = _getPost(
      //   uid: deepLink.queryParameters['post']!,
      //   context: context,
      // ) as Post;
      // print(post);
    } else {
      print('deep link is null');
    }
    // 2 - Background / Foreground State = INTO FOREGROUND FROM A DYNAMIC LINK
    FirebaseDynamicLinks.instance.onLink.listen(
      (dynamicLinkData) {
        // handle link that has been retrieved
        print(
          'Dynamic links | Resume: ' +
              dynamicLinkData.link.queryParameters['screen']!,
        );
        //Retrieve the target post
        final Post post = _getPost(data: dynamicLinkData, context: context);
        print(post.toString());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostDetailsScreen(post: post),
          ),
        );
      },
    ).onError(
      (error) {
        print('Link Failed: ${error.message}');
      },
    );
  }
  //  final DynamicLinkService _dynamicLinkService = DynamicLinkService();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance?.addObserver(this);
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _handleDynamicLink();
  //   }
  // }

  // void _handleDynamicLink() async {
  //   await _dynamicLinkService.handle(context);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance?.removeObserver(this);
  // }

  // Map<String, String> _handleDeepLink(PendingDynamicLinkData? data) {
  //   return {};
  // }

  Future<Uri> create({required Post post}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      // The Dynamic Link URI domain. You can view created URIs on your Firebase console
      uriPrefix: 'https://deeplinksocialshare.page.link',
      // The deep Link passed to your application which you can use to affect change
      link: Uri.parse(
        'https://www.deeplinksocialshare.com?screen=PostDetailsScreen&post=${post.owner}',
      ),
      // Android application details needed for opening correct app on device/Play Store
      androidParameters: const AndroidParameters(
        packageName: 'com.nouhben.deep_link_social_share',
        minimumVersion: 1,
      ),
      // iOS application details needed for opening correct app on device/App Store
      iosParameters: const IOSParameters(
        bundleId: 'com.nouhben.deepLinkSocialShare',
        minimumVersion: '2',
      ),
    );

    final Uri uri = await FirebaseDynamicLinks.instance.buildLink(parameters);
    //TODO: Handle the Uri
    print(Uri.parse(uri.queryParameters['link']!).queryParameters);
    return uri;
  }
}
