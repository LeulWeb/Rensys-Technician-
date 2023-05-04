import 'package:flutter/material.dart';

class ActionCard extends StatelessWidget {
  final Color color;
  final Icon ActionIcon;
  final String title;
  final String description;
  final VoidCallback goTo;

  const ActionCard({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.ActionIcon,
    required this.goTo,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () {
          goTo();
        },
        child: Container(
          decoration: BoxDecoration(
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title),
              ActionIcon,
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
