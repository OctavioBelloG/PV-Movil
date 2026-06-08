import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/venta.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Registrar una nueva venta y actualizar stock
Future<int> registrarVenta(Venta v) async {
  WriteBatch batch = db.batch();
  CollectionReference ventasColl = db.collection('Ventas');
  CollectionReference productosColl = db.collection('Productos');

  try {
    // Crear la venta
    DocumentReference nuevaVentaRef = ventasColl.doc();
    batch.set(nuevaVentaRef, v.toJson());

    // Actualizar el stock de cada producto
    for (var item in v.items) {
      DocumentReference productoRef = productosColl.doc(item.id);
      batch.update(productoRef, {
        'stock': FieldValue.increment(-item.cantidad)
      });
    }

    // Ejecutar el batch
    await batch.commit();
    return 200;
    } catch (e) {
        print("Error en registrarVenta: $e");
      return 500;
    }
}

// Obtener el historial de ventas
Future<List<Venta>> getVentas() async {
  CollectionReference coleccion = db.collection('Ventas');
  QuerySnapshot queryVentas = await coleccion.orderBy('fecha', descending: true).get();

  return queryVentas.docs.map(
    (v) => Venta.fromFirebaseDoc(v.id, v.data() as Map<String, dynamic>)
  ).toList();
}
