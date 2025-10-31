import 'package:flutter/material.dart';

class CircleSelectedWidget extends StatelessWidget {
  const CircleSelectedWidget({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: selected ? Colors.green : Colors.grey.shade500,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            left: 0,
            child: ColoredBox(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ),
          ),
          if (selected)
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: ColoredBox(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: selected ? Colors.green : null,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
