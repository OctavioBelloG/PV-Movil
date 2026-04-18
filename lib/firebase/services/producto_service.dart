import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/producto.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Producto>> getProductos() async {
  CollectionReference coleccion = db.collection('Productos');

  QuerySnapshot queryProductos = await coleccion.get();

  return queryProductos.docs.map(
    (p) => Producto.fromFirebase(p.data() as Map<String, dynamic>)
  ).toList();
}


// Obtener todos los productos (con ID de documento para editar/eliminar)
Future<List<Producto>> getProductosDocId() async {
  CollectionReference coleccion = db.collection('Productos');
  QuerySnapshot queryProductos = await coleccion.get();

  return queryProductos.docs.map(
    (p) => Producto.fromFirebaseDoc(p.id, p.data() as Map<String, dynamic>)
  ).toList();
}

// Agregar un nuevo producto
Future<int> addProducto(Producto p) async {
  CollectionReference coleccion = db.collection('Productos');
  int code = 0;
  try {
    await coleccion.add(p.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}

// Actualizar un producto existente
Future<int> editProducto(Producto p) async {
  CollectionReference coleccion = db.collection('Productos');
  int code = 0;
  try {
    await coleccion.doc(p.id).update(p.toJson());
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}

// Eliminar un producto por su ID
Future<int> deleteProducto(String id) async {
  CollectionReference coleccion = db.collection('Productos');
  int code = 0;
  try {
    await coleccion.doc(id).delete();
    code = 200;
  } catch (e) {
    code = 500;
  }
  return code;
}
