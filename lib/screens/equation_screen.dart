import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/equation_cubit.dart';
import '../cubit/equation_state.dart';

class EquationScreen extends StatelessWidget {
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
      body: BlocBuilder<EquationCubit, EquationState>(
        builder: (context, state) {
          if (state is EquationInput) {
            return _buildInputForm(context, state);
          } else if (state is EquationResult) {
            return _buildResult(context, state);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildInputForm(BuildContext context, EquationInput state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: aController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Коэффициент a',
              hintText: 'Введите коэффициент a',
              errorText: state.aError,
            ),
          ),
          const SizedBox(height: 16),
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
          CheckboxListTile(
            title: const Text('Я согласен на обработку данных'),
            value: state.isAgreed,
            onChanged: (value) {
              context.read<EquationCubit>().toggleAgreement(value);
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<EquationCubit>().validateInput(
                  aController.text,
                  bController.text,
                  cController.text,
                );
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

  Widget _buildResult(BuildContext context, EquationResult state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Уравнение: ${state.a}x² + ${state.b}x + ${state.c} = 0',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            state.result,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
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