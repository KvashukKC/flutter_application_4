import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/equation_cubit.dart';
import '../cubit/equation_state.dart';

class EquationScreen extends StatelessWidget {
  // Контроллеры для текстовых полей ввода
  final aController = TextEditingController();
  final bController = TextEditingController();
  final cController = TextEditingController();

  EquationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Квадратное уравнение (Cubit)'),
      ),
      // BlocBuilder перестраивает UI при изменении состояния
      body: BlocBuilder<EquationCubit, EquationState>(
        builder: (context, state) {
          if (state is EquationInput) {
            // Состояние ввода данных
            return _buildInputForm(context, state);
          } else if (state is EquationResult) {
            // Состояние с результатами
            return _buildResult(context, state);
          }
          // Заглушка на случай неизвестного состояния
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // Построение формы ввода
  Widget _buildInputForm(BuildContext context, EquationInput state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Поле ввода коэффициента A
          TextFormField(
            controller: aController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент a',
              hintText: 'Введите коэффициент a',
              errorText: state.aError, // Показываем ошибку, если есть
            ),
          ),
          const SizedBox(height: 16),
          
          // Поле ввода коэффициента B
          TextFormField(
            controller: bController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент b',
              hintText: 'Введите коэффициент b',
              errorText: state.bError,
            ),
          ),
          const SizedBox(height: 16),
          
          // Поле ввода коэффициента C
          TextFormField(
            controller: cController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент c',
              hintText: 'Введите коэффициент c',
              errorText: state.cError,
            ),
          ),
          const SizedBox(height: 16),
          
          // Чекбокс согласия
          CheckboxListTile(
            title: const Text('Я согласен на обработку данных'),
            value: state.isAgreed,
            onChanged: (value) {
              // При изменении чекбокса уведомляем Cubit
              context.read<EquationCubit>().toggleAgreement(value);
            },
          ),
          const SizedBox(height: 24),
          
          // Кнопка расчета
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Сначала валидируем ввод
                context.read<EquationCubit>().validateInput(
                  aController.text,
                  bController.text,
                  cController.text,
                );
                
                // Если нет ошибок и есть согласие - вычисляем
                if (state.aError == null &&
                    state.bError == null &&
                    state.cError == null &&
                    state.isAgreed) {
                  context.read<EquationCubit>().calculate(
                    aController.text,
                    bController.text,
                    cController.text,
                  );
                } else if (!state.isAgreed) {
                  // Показываем ошибку если нет согласия
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Необходимо согласие на обработку данных'),
                    ),
                  );
                }
              },
              child: const Text('Решить уравнение'),
            ),
          ),
        ],
      ),
    );
  }

  // Построение экрана результатов
  Widget _buildResult(BuildContext context, EquationResult state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Отображаем уравнение
          Text(
            'Уравнение: ${state.a}x² + ${state.b}x + ${state.c} = 0',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          
          // Отображаем результаты вычислений
          Text(
            state.result,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          
          // Кнопка возврата
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Возвращаемся к форме ввода
                context.read<EquationCubit>().returnToInput();
              },
              child: const Text('Решить новое уравнение'),
            ),
          ),
        ],
      ),
    );
  }
}