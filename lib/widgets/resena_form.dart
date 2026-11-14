import 'package:flutter/material.dart';

class ResenaForm extends StatefulWidget {
  final Future<void> Function(String nombre, String texto, int calificacion)
      onGuardar;

  const ResenaForm({super.key, required this.onGuardar});

  @override
  State<ResenaForm> createState() => _ResenaFormState();
}

class _ResenaFormState extends State<ResenaForm> {
  final _nombreCtrl = TextEditingController();
  final _textoCtrl = TextEditingController();
  int _calificacion = 0;
  String? _error;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _textoCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final nombre = _nombreCtrl.text.trim();
    final texto = _textoCtrl.text.trim();

    if (nombre.isEmpty || texto.isEmpty || _calificacion == 0) {
      setState(() => _error = 'Completa tu nombre, la reseña y la calificación.');
      return;
    }

    setState(() => _guardando = true);
    await widget.onGuardar(nombre, texto, _calificacion);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escribir reseña',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  onPressed: () => setState(() => _calificacion = i + 1),
                  icon: Icon(
                    i < _calificacion ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                ),
              ),
            ),
            TextField(
              controller: _textoCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Tu reseña',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _guardando ? null : _enviar,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                ),
                child: const Text('Publicar reseña'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}