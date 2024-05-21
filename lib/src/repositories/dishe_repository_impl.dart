import 'package:dio/dio.dart';
import 'package:forkify_app/src/exceptions/exceptions_message.dart';
import 'package:forkify_app/src/fp/either.dart';
import 'package:forkify_app/src/model/dishe.dart';
import 'package:forkify_app/src/repositories/dishe_repository.dart';
import 'package:forkify_app/src/restClient/rest_client.dart';

class DisheRepositoryImpl implements DisheRepository {

  final RestClient restClient;

  DisheRepositoryImpl({required this.restClient});

  @override
  Future<Either<AuthException, List<Dishes>>> getDishes() async {
    try {
      final response = await restClient.unAuth.get('/search', queryParameters: {'q': 'pizza'});
      final List<Dishes> dishes = (response.data['recipes'] as List).map((e) => Dishes.fromJson(e)).toList();
      return Right(dishes);
    } on DioException catch (e) {
      return Left(AuthError(message: e.message!));
    }
  }
}