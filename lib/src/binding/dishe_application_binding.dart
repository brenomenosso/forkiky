import 'package:flutter_getit/flutter_getit.dart';
import 'package:forkify_app/src/core/env.dart';
import 'package:forkify_app/src/restClient/rest_client.dart';

class DisheaApplicationBinding extends ApplicationBindings {

  @override
  List<Bind<Object>> bindings() => [
    Bind.lazySingleton<RestClient>((i) => RestClient(Env.backendBaseUrl)),
  ];
  
}