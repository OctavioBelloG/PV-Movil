import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/firebase/models/carrito.dart';
import 'package:punto_de_venta_movil/theme_cubit.dart';
import '../models/producto.dart';
import '../models/venta.dart';
import '../services/producto_service.dart';
import '../services/venta_service.dart';

class VentaScreen extends StatefulWidget {
  const VentaScreen({super.key});

  @override
  State<VentaScreen> createState() => _VentaScreenState();
}

class _VentaScreenState extends State<VentaScreen> {
  List<Carrito> carrito = [];

  void _agregarAlCarrito(Producto producto, int cantidad) {
    setState(() {
      // Si el producto ya está en el carrito, sumamos la cantidad
      int index = carrito.indexWhere((item) => item.id == producto.id);
      if (index != -1) {
        carrito[index].cantidad += cantidad;
      } else {
        carrito.add(Carrito(
          id: producto.id!,
          nombre: producto.nombre,
          cantidad: cantidad,
        ));
      }
    });
  }

  void _mostrarDialogoCantidad(Producto producto) {
    TextEditingController txtCantidad = TextEditingController();
    final formKeyDialog = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cantidad para ${producto.nombre}'),
          content: Form(
            key: formKeyDialog,
            child: TextFormField(
              controller: txtCantidad,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                hintText: 'Ej: 5',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Campo requerido';
                int? cant = int.tryParse(value);
                if (cant == null) return 'Ingrese un número válido';
                if (cant <= 0) return 'La cantidad debe ser mayor a 0';
                if (cant > producto.stock) return 'No hay suficiente stock (${producto.stock})';
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (formKeyDialog.currentState!.validate()) {
                  _agregarAlCarrito(producto, int.parse(txtCantidad.text));
                  Navigator.pop(context);
                }
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva venta'),
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
          Expanded(
            flex: 2, //tamaño del espacio de a pantala que se va a usar
            //se divide la pantalla en los productos y el carrito
            child: FutureBuilder(
              future: getProductosDocId(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Producto producto = snapshot.data![index];
                      return ListTile(
                        title: Text(producto.nombre),
                        subtitle: Text('Codigo de barras: ${producto.codigoBarras}, Stock: ${producto.stock}'),
                        onTap: producto.stock > 0  //vaida que hayga stock
                          ? () => _mostrarDialogoCantidad(producto) //if que permite seeccionar para comprar
                          : null,//si no hay datos no
                        enabled: producto.stock > 0,
                      );
                    },
                  );
                } else if (snapshot.hasError) { //en caso de haber algun error
                  return const Center(child: Text('Error al cargar productos'));
                } else {
                  return const Center(child: CircularProgressIndicator()); //Mostrara un circulo girando
                }
              },
            ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0), //Para centrar e texto
            child: Text('Carrito', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1, //tamaño del apartado de carrito
            child: carrito.isEmpty //en caso de que el carrito este vacio se muestra un mensaje
                ? const Center(child: Text('Compren Compren ^^'))
                : ListView.builder(
                    itemCount: carrito.length, //Productos en el carrito
                    itemBuilder: (context, index) {
                      Carrito item = carrito[index];
                      return ListTile(
                        title: Text(item.nombre), //nombre del producto en e carrito
                        trailing: Text('cantidad: ${item.cantidad}'), //cantidad del producto

                        leading: IconButton( //boton para eiminar el producto del carrito
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {//al presionarlo sequita
                            setState(() {
                              carrito.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () async {
                if (carrito.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El carrito ta vacio')),
                  );
                  return; //detiene la ejecucion en caso de no haber producto
                }

                //Muestra lla cantidad de productos que compra y se actuzaisa si se suma
                int totalUnidades = carrito.fold(0, (sum, item) => sum + item.cantidad);//e fold ahorra la cantidad de operaciones a mostrar
                Venta nuevaVenta = Venta(
                  items: carrito,
                  totalUnidades: totalUnidades,
                  fecha: DateTime.now(),
                );

                //agrega las ventas a firebase y actuaiza
                int code = await registrarVenta(nuevaVenta);
                if (code == 200 && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Venta registrada')),
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error al registrar la venta')),
                  );
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Comprar'),
            ),
          ),
        ],
      ),
    );
  }
}
