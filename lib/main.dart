import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:forkify_app/src/binding/dishe_application_binding.dart';
import 'package:forkify_app/src/modules/home/home_module.dart';
import 'package:forkify_app/src/pages/splash_page.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: DisheaApplicationBinding(),
      pages: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(),
          path: '/'
        ),
      ],
      modules: [
        HomeModule(),
      ],
      builder: (context, routes, flutterGetItNavObserver) {
        return AsyncStateBuilder(builder: (navigatorObserver) { 
          return MaterialApp(
            title: 'Dishe App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            navigatorObservers: [navigatorObserver],
            routes: routes,
          );
        });
      }
    );
  }
}