class AppUser {
  final String username;
  final String password; // simples: pode ser o próprio texto por enquanto

  AppUser({required this.username, required this.password});

  factory AppUser.fromJson(Map<String, dynamic> j) =>
      AppUser(username: j['username'], password: j['passwordHash']);

  Map<String, dynamic> toJson() =>
      {'username': username, 'password': password};
}