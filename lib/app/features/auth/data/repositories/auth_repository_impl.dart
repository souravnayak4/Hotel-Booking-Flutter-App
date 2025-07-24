import 'package:hotelbooking/app/features/auth/domain/auth_repository.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hotelbooking/app/features/auth/data/datasources/database.dart';
import 'package:random_string/random_string.dart';

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
    await remoteDataSource.signup(email, password);
    String id = randomAlphaNumeric(10);

    Map<String, dynamic> userMap = {"Name": name, "Email": email, "Id": id};

    await localDataSource.saveUser(name, email, id);
    await databaseMethods.addUserInfo(userMap, id);
  }

  @override
  Future<void> login(String email, String password) async {
    await remoteDataSource.login(email, password);
  }
}
