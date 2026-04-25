import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class DeleteProductoScreen extends StatelessWidget {
  const DeleteProductoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Producto producto = ModalRoute.of(context)!.settings.arguments as Producto;

    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Producto')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Text(
            '¿Estás seguro de querer eliminar el producto: ${producto.nombre}?',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Código: ${producto.codigoBarras},    Stock: ${producto.stock}',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 50),
          OutlinedButton.icon(
            onPressed: () async {
              int code = await deleteProducto(producto.id!);
              if (code == 200 && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado')),
                );
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            icon: const Icon(Icons.delete, color: Colors.red),
            label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}