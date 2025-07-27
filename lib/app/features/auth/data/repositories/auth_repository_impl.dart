import 'package:hotelbooking/app/features/auth/domain/auth_repository.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hotelbooking/app/core/services/database.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final DatabaseMethods databaseMethods;

  AuthRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.databaseMethods,
  );

  @override
  Future<void> signup(String name, String email, String password) async {
    // Get Firebase UID
    String uid = await remoteDataSource.signup(email, password);

    Map<String, dynamic> userMap = {"Name": name, "Email": email, "Id": uid};

    await localDataSource.saveUser(name, email, uid);
    await databaseMethods.addUserInfo(userMap, uid);
  }

  @override
  Future<void> login(String email, String password) async {
    await remoteDataSource.login(email, password);
  }
}
