abstract class AuthRepository {
  Future<void> signup(String name, String email, String password);
  Future<void> login(String email, String password);
}
