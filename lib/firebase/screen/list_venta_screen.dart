import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/theme_cubit.dart';
import '../models/venta.dart';
import '../services/venta_service.dart';
import 'package:intl/intl.dart';

class ListVentaScreen extends StatelessWidget {
  const ListVentaScreen({super.key});
  //POS NADAMAS SE PUEDEN VER LAS VENTAS ._.
  //en general

  String _formatDate(DateTime d) {
    //fecha de la venta
    return DateFormat('dd/MM/yyyy HH:mm').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ventas'),
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
      
            // aqui se van mostrar las ventas de firebase
      // antes de construir la pantalla
      body: FutureBuilder(
        future: getVentas(),
        builder: (context, snapshot) {

          // snapshot.hasData verifica que hay datos en firebase
          if (snapshot.hasData) {
            // ListView.builder construye solo los elementos visibles en pantalla como el listbuilder
            return ListView.builder(
              itemCount: snapshot.data?.length, // cuántas ventas hay en total
              itemBuilder: (context, index) {

                // agarra la venta de la posición actual de la lista
                Venta venta = snapshot.data![index];

                // convierte la lista de items en un texto legible
                // ejemplo: "Leche nutri (2), Sabritas (1)"
                String itemsText = venta.items.map((i) => '${i.nombre} (${i.cantidad}) ').
                join(' , '); //jaoin muestra todos los productos y cantidad separados por comas
                
                return ListTile(
                  title: Text(_formatDate(venta.fecha)),   // fecha de la venta con formato del inicio
                  subtitle: Text('Productos vendidos: $itemsText \nCantidad total de productos que se vendieron: ${venta.totalUnidades} '), //nadamas se muestra el producto y cantidad
                  trailing: const Icon(Icons.receipt_long),
                  isThreeLine: true, // permite que el subtitle ocupe hasta 3 líneas
                );
              },
            );

          // por si algo falla en la consulta a firebase
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar historial de ventas'));

          // si no tiene datos ni error, todavía está cargando
          } else {
            return const Center(child: CircularProgressIndicator()); // como que carga pa despistar
          }
        },
      ),

    );
  }
}
