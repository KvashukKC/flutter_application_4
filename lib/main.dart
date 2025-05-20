import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/equation_cubit.dart';
import 'screens/equation_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Квадратные уравнения (Cubit)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Обёртка для предоставления Cubit всему приложению
      home: BlocProvider(
        create: (context) => EquationCubit(),
        child:  EquationScreen(),
      ),
    );
  }
}
