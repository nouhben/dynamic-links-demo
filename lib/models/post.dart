class Post {
  const Post({
    required this.owner,
    required this.title,
    required this.content,
    required this.image,
  });
  final String owner;
  final String title;
  final String content;
  final String image;

  Map<String, dynamic> toMap() => {
        'owner': owner,
        'title': title,
        'content': content,
        'image': image,
      };
  factory Post.fromMap(Map<String, dynamic>? data) => Post(
        owner: data!['owner'],
        title: data['title'],
        content: data['content'],
        image: data['image'],
      );

  @override
  String toString() {
    return super.toString() +
        ' By: ' +
        owner +
        ' | ' +
        title +
        ' | ' +
        content +
        '| $image';
  }
}
