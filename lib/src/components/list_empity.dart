import 'package:flutter/material.dart';

class ListEmpityCard extends StatelessWidget {
  const ListEmpityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.restaurant_menu, size: 100, color: Colors.grey),
        SizedBox(height: 10),
        Text(
          'Nenhuma receita encontrado',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}