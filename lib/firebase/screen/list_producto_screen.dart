import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class ListProductosScreen extends StatelessWidget {
  const ListProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de los Productos')),
      body: FutureBuilder(
        future: getProductosDocId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                Producto producto = snapshot.data?[index] as Producto;
                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(producto.stock as String), //asoo asi no marca error
                  trailing: Icon(
                    Icons.circle, //como un if que mostrara un icono de color para producto en stock
                    color: producto.activo ? Colors.green : Colors.red,
                    size: 15,
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/editProducto',
                      arguments: producto,
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error, no cargan os productos'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addProducto');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}