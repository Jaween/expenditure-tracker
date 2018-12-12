abstract class User {
  String get userId;
  String get displayName;
  bool get isAnonymous;
  String get photoUrl;
  List<String> get linkedProviderIds;
}