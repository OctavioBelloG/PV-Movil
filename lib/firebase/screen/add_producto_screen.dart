import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/theme_cubit.dart';
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
  bool activo = true;
  final formKey = GlobalKey<FormState>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Producto'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),
                tooltip: themeMode == ThemeMode.light
                    ? 'Cambiar a modo oscuro'
                    : 'Cambiar a modo claro',
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
      ),
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

              OutlinedButton.icon(
                onPressed: () async {
                  //FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    Producto p = Producto(
                      nombre: txtNombre.text,
                      codigoBarras: txtCodigoBarras.text,
                      stock: int.parse(txtStock.text),
                      activo: activo,
                      fecha: DateTime.now(), 
                      pago: {},
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
                icon: const Icon(Icons.airplay_rounded),
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