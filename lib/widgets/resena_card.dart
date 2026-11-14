import 'package:flutter/material.dart';
import 'package:recetas_app/models/resena.dart';

class ResenaCard extends StatelessWidget {
  final Resena resena;

  const ResenaCard({super.key, required this.resena});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.deepOrange,
                  child: Text(
                    resena.nombre.isNotEmpty
                        ? resena.nombre[0].toUpperCase()
                        : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    resena.nombre,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  resena.fechaFormateada,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < resena.calificacion ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(resena.texto),
          ],
        ),
      ),
    );
  }
}