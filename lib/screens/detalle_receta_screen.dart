import 'package:flutter/material.dart';
import 'package:recetas_app/data/resenas_db.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/models/resena.dart';
import 'package:recetas_app/widgets/resena_card.dart';
import 'package:recetas_app/widgets/resena_form.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  List<Resena> _resenas = [];

  @override
  void initState() {
    super.initState();
    _cargarResenas();
  }

  Future<void> _cargarResenas() async {
    final datos = await ResenasDb.instancia.obtenerPorReceta(widget.receta.id);
    if (!mounted) return;
    setState(() => _resenas = datos);
  }

  void _abrirFormulario() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ResenaForm(
        onGuardar: (nombre, texto, calificacion) async {
          await ResenasDb.instancia.insertar(
            Resena(
              recetaId: widget.receta.id,
              nombre: nombre,
              texto: texto,
              calificacion: calificacion,
              fecha: DateTime.now(),
            ),
          );
          await _cargarResenas();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de la receta")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormulario,
        icon: const Icon(Icons.rate_review),
        label: const Text('Reseña'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              receta.imagenURL,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/Error.png",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Preparación: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      '${entrada.key + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Reseñas (${_resenas.length}):',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_resenas.isEmpty)
            const Text('Aún no hay reseñas. ¡Sé el primero!')
          else
            ..._resenas.map((r) => ResenaCard(resena: r)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}