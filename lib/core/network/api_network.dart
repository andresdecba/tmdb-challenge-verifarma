import 'package:dartz/dartz.dart';
import 'package:tmdb_challenge/core/network/exceptions.dart';
import 'package:tmdb_challenge/core/network/failures.dart';

class ApiNetwork {
  static Future<Either<Failure, T>> call<T>(Function() function) async {
    try {
      T result = await function();
      return Right(result);
    } on InvalidApiKeyException {
      return Left(InvalidApiKeyFailure());
    } on InvalidFormatException {
      return Left(InvalidFormatFailure());
    } on InternalErrorException {
      return Left(InternalErrorFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
