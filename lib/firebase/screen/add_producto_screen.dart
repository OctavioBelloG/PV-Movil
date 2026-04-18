import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class AddProductoScreen extends StatefulWidget {
  const AddProductoScreen({super.key});

  @override
  State<AddProductoScreen> createState() => _AddProductoScreenState();
}
class _AddProductoScreenState extends State<AddProductoScreen> {

  @override
  Widget build(BuildContext context) {
    TextEditingController txtNombre = TextEditingController();
    TextEditingController txtCodigoBarras = TextEditingController();
    TextEditingController txtStock = TextEditingController();
    TextEditingController txtMetodoPago = TextEditingController();
    TextEditingController txtMontoRecibido = TextEditingController();
    TextEditingController txtCambio = TextEditingController();
    bool activo = true;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12),
            child: Form(
              child: Column(
                children: [
                  

              // String: nombre
              TextFormField(
                controller: txtNombre,
                decoration: InputDecoration(
                  labelText: 'Nombre del producto',
                  hintText: 'Leche nutri',
                  helperText: 'Ingrese el nombre del producto',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),

              // String: codigoBarras
              TextFormField(
                controller: txtCodigoBarras,
                decoration: InputDecoration(
                  labelText: 'codigo de barras',
                  hintText: '55610688151',
                  helperText: 'Ingrese o escanee el codigo',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),

              // Number: stock
              TextFormField(
                controller: txtStock,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  hintText: '24',
                  helperText: 'Unidades disponibles en inventario',
                  suffixIcon: const Icon(Icons.numbers),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (int.tryParse(value) == null) return 'ingrese un número valido';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Boolean: activo
              SwitchListTile(
                title: const Text('Producto activo'),
                subtitle: Text(activo ? 'Disponible para venta' : 'No esta disponible para venta ._.'),
                value: activo,
                onChanged: (value) => setState(() => activo = value),
              ),
              const SizedBox(height: 12),

              // Map: pago — subcampos
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Datos del pago', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: txtMetodoPago,
                decoration: InputDecoration(
                  labelText: 'metodo de pago',
                  hintText: 'efectivo / tarjeta / transferencia',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: txtMontoRecibido,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monto recibido',
                  hintText: '100.00',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (double.tryParse(value) == null) return 'ingrese un monto valido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: txtCambio,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cambio',
                  hintText: '14.50',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (double.tryParse(value) == null) return 'ingrese un valor vaido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Producto p = Producto(
                      nombre: txtNombre.text,
                      codigoBarras: txtCodigoBarras.text,
                      stock: int.parse(txtStock.text),
                      activo: activo,
                      fecha: DateTime.now(), // DateTime — se genera automáticamente
                      pago: {// el Map con los subcampos
                        'metodo': txtMetodoPago.text,
                        'montoRecibido': double.parse(txtMontoRecibido.text),
                        'cambio':double.parse(txtCambio.text),
                      },
                    );
                    int code = await addProducto(p);
                    if (code == 200 && context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
                ],
              ),
            )
          )
        ]
      )
    );
  }
}