import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String label;
  final Function()? onTap;
  final IconData icon;

  CustomButtom({required this.label, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 130.0,
          height: 60.0,
          decoration: BoxDecoration(
              color: Color(0xFF4e5ae8),
              borderRadius: BorderRadius.circular(15.0)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  label,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }
}
