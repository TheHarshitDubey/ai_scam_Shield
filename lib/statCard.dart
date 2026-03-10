import 'package:flutter/material.dart';

class StatCard extends StatelessWidget{
  final IconData icon;
  final Color color;
  final String value;
  final String label;

 StatCard({
  super.key,
  required this.icon,
  required this.color,
  required this.value,
  required this.label,
});
@override
  Widget build(BuildContext context) {
    return Container(
       padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),

   child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(icon, color: color, size: 28),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),

        ],
      ),
    );
  }
}