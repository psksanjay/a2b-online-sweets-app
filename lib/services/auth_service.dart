import '../models/user.dart';

List<User> mockUsers = [];

User? currentUser;

bool registerUser(String username, String password) {
  if (mockUsers.any((u) => u.username == username)) return false;
  mockUsers.add(User(username: username, password: password));
  return true;
}

bool loginUser(String username, String password) {
  final user = mockUsers.firstWhere(
    (u) => u.username == username && u.password == password,
    orElse: () => User(username: '', password: ''),
  );
  if (user.username.isEmpty) return false;
  currentUser = user;
  return true;
}
