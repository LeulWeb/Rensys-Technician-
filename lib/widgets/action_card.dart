import 'package:flutter/material.dart';
import 'package:technician_rensys/widgets/custom_badge.dart';

class ActionCard extends StatelessWidget {
  final Color color;
  final Widget ActionIcon;
  final String title;
  final String description;
  final VoidCallback goTo;
  final Widget? custom_badge;
  final List<Color> colors;

  const ActionCard(
      {super.key,
      required this.color,
      required this.title,
      required this.description,
      required this.ActionIcon,
      required this.goTo,
      required this.custom_badge,
      required this.colors});

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
              gradient:
                  LinearGradient(colors: colors, begin: Alignment.topCenter)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              Expanded(child: Container()),
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
              Expanded(child: Container()),
              Text(
                description,
                style: TextStyle(color: Colors.white),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
