import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/theme_cubit.dart';
import '../models/producto.dart';
import '../services/producto_service.dart';

class EditProductoScreen extends StatefulWidget {
  const EditProductoScreen({super.key});

  @override
  State<EditProductoScreen> createState() => _EditProductoScreenState();
}

class _EditProductoScreenState extends State<EditProductoScreen> {
  
  @override
  Widget build(BuildContext context) {

  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtCodigoBarras = TextEditingController();
  TextEditingController txtStock = TextEditingController();
  TextEditingController txtPrecio = TextEditingController();

  bool activo = true;
  final Producto producto = ModalRoute.of(context)!
                          .settings.arguments as Producto;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actuaizar producto'),
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
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
              TextFormField(
                controller: txtCodigoBarras,
                decoration: InputDecoration(
                  labelText: 'Código de barras',
                  hintText: '55610688151',
                  helperText: 'Ingrese o escanee el código',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),

              const SizedBox(height: 12),
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
                  if (int.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: txtPrecio,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Precio del producto',
                  hintText: '50.00',
                  suffixIcon: const Icon(Icons.money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo requerido';
                  if (double.tryParse(value) == null) return 'Ingrese un número válido';
                  return null;
                },
              ),

              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Producto activo'),
                subtitle: Text(activo ? 'Disponible para venta' : 'No está disponible para venta'),
                value: activo,
                onChanged: (value) => setState(() => activo = value),
              ),

              const SizedBox(height: 12),
              OutlinedButton.icon(
                  onPressed: () async {
                    if(formKey.currentState!.validate()){
                      Producto p = Producto(
                        id: producto.id,
                        nombre: txtNombre.text,
                        codigoBarras: txtCodigoBarras.text,
                        stock: int.parse(txtStock.text),
                        activo: activo,
                        fecha: producto.fecha,
                        pago: producto.pago,
                       // precio: int.parse(txtPrecio.text),
                      );
                      int code = await editProducto(p);
                    // Navigator.pop(context);//cuadro de dialogo
                    Navigator.of(
                      context,
                      ).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                  icon: Icon(Icons.airplay_rounded),
                  label: Text("Aceptar"),
              ),

              OutlinedButton(onPressed: (){
                  Navigator.pushNamed(
                    context,
                    '/deleteProducto',
                    arguments: producto);
                },
                child: Text("Ir a eliminar"))

            ],
          ),
        ),
      ),
    );
  }
}
