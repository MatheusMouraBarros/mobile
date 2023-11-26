class UserProfile {
  final String name;
  String description;
  List<String> publishedArticles;
  List<String> readArticles;

  UserProfile({
    required this.name,
    required this.description,
    required this.publishedArticles,
    required this.readArticles,
  });
}
