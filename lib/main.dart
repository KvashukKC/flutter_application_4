import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Импорт библиотеки для работы с BLoC/Cubit

import 'cubit/equation_cubit.dart'; // Импорт нашего Cubit
import 'screens/equation_screen.dart'; // Импорт главного экрана

void main() {
  runApp(const MyApp()); // Точка входа в приложение
}

// Задание 4
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Конструктор виджета

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Квадратные уравнения (Cubit)', // Название приложения
      theme: ThemeData(
        primarySwatch: Colors.blue, // Цветовая схема
      ),
      home: BlocProvider(
        // BlocProvider делает наш Cubit доступным для всех виджетов в поддереве
        create: (context) => EquationCubit(), // Создаем экземпляр Cubit
        child: EquationScreen(), // Главный экран приложения
      ),
    );
  }
}
