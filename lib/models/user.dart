class AppUser {

  final String email;
  final String userId;
  final String username;
  final bool isAdmin;

  AppUser({this.email, this.userId, this.username, this.isAdmin = false});

  AppUser.fromMap(Map snapshot, String userId)
      : userId = userId ?? "",
        username = snapshot['username'],
        email = snapshot['email'],
        isAdmin = snapshot['isAdmin'];

  toJson() {
    return {
      "userId": userId,
      "username": username,
      "email": email,
      "isAdmin": isAdmin
    };
  }
}
