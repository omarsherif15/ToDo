import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'Layouts/HomeLayout.dart';
import 'Shared/Components/blocObserver.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeLayout(),
        debugShowCheckedModeBanner: false,
      );
  }
}