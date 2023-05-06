import 'package:flutter/material.dart';
import 'package:technician_rensys/widgets/custom_badge.dart';

class ActionCard extends StatelessWidget {
  final Color color;
  final Icon ActionIcon;
  final String title;
  final String description;
  final VoidCallback goTo;
  final Widget? custom_badge;

  const ActionCard({
    super.key,
    required this.color,
    required this.title,
    required this.description,
    required this.ActionIcon,
    required this.goTo,
    required this.custom_badge,
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
              Stack(
                alignment: Alignment.center,
                children: [
                  ActionIcon,
                  custom_badge != null
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: custom_badge!,
                        )
                      : Container()
                ],
              ),
              Text(description),
            ],
          ),
        ),
      ),
    );
  }
}
