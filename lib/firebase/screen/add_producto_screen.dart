import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class AddProductoScreen extends StatefulWidget {
  const AddProductoScreen({super.key});

  @override
  State<AddProductoScreen> createState() => _AddProductoScreenState();
}
class _AddProductoScreenState extends State<AddProductoScreen> {
  final TextEditingController txtNombre = TextEditingController();
  final TextEditingController txtCodigoBarras = TextEditingController();
  final TextEditingController txtStock = TextEditingController();
  final TextEditingController txtMetodoPago = TextEditingController();
  final TextEditingController txtMontoRecibido = TextEditingController();
  final TextEditingController txtCambio = TextEditingController();
  bool activo = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    txtNombre.dispose();
    txtCodigoBarras.dispose();
    txtStock.dispose();
    txtMetodoPago.dispose();
    txtMontoRecibido.dispose();
    txtCambio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Producto')),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                child: Text('datos del pago', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),


              // TextFormField(
              //   controller: txtMetodoPago,
              //   decoration: InputDecoration(
              //     labelText: 'metodo de pago',
              //     hintText: 'efectivo - tarjeta - transferencia',
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              //   ),
              //   validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              // ),
              // const SizedBox(height: 8),
              // TextFormField(
              //   controller: txtMontoRecibido,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     labelText: 'Monto recibido',
              //     hintText: '100.00',
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) return 'Campo requerido';
              //     if (double.tryParse(value) == null) return 'ingrese un monto valido';
              //     return null;
              //   },
              // ),
              //const SizedBox(height: 8),
              // TextFormField(
              //   controller: txtCambio,
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //     labelText: 'Cambio',
              //     hintText: '14.50',
              //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              //   ),
              //   validator: (value) {
              //     if (value!.isEmpty) return 'Campo requerido';
              //     if (double.tryParse(value) == null) return 'ingrese un valor vaido';
              //     return null;
              //   },
              // ),
              // const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState?.validate() ?? false) {
                    Producto p = Producto(
                      nombre: txtNombre.text,
                      codigoBarras: txtCodigoBarras.text,
                      stock: int.parse(txtStock.text),
                      activo: activo,
                      fecha: DateTime.now(), // DateTime — se genera automáticamente
                      pago: {
                        'metodo': txtMetodoPago.text.trim(),
                        'montoRecibido': double.tryParse(txtMontoRecibido.text) ?? 0.0,
                        'cambio': double.tryParse(txtCambio.text) ?? 0.0,
                      },
                    );
                    int code = await addProducto(p);
                    if (code == 200 && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Producto guardado')), 
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('error al guardar')),
                      );
                    }
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('campos obligatorios')),
                    );
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