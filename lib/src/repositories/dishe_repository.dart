import 'package:forkify_app/src/exceptions/exceptions_message.dart';
import 'package:forkify_app/src/fp/either.dart';
import 'package:forkify_app/src/model/dishe.dart';

abstract interface class DisheRepository {

  Future<Either<AuthException,List<Dishes>>> getDishes(String food);

}