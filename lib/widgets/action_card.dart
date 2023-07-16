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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: () {
            goTo();
          },
          child: Container(
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: colors, begin: Alignment.topCenter)),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  width: 20,
                ),

                // Expanded(child: Container()),
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
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    // Expanded(child: Container()),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                // Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
