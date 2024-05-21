import 'package:flutter/material.dart';

class CardModalOption extends StatelessWidget {
  final String option;
  final VoidCallback onTap;

  const CardModalOption({
    super.key,
    required this.option,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade500,
      child: ListTile(
        selectedTileColor: Colors.purple,
        title: Text(
          option,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
