import "package:flutter/material.dart";
class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  

  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,

  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
        icon,
        size: 32,
        color: Color.fromARGB(255, 0, 149, 255),
        ),
        const SizedBox(height: 10,),
       Text(
          label
        ),
        const SizedBox(height: 10,),
        Text(
          value,
         style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ],
    );
  }
}