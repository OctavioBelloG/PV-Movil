import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:punto_de_venta_movil/theme_cubit.dart';

class Inicio_Screen extends StatefulWidget {
  const Inicio_Screen({super.key});

  @override
  State<Inicio_Screen> createState() => _Inicio_ScreenState(); 
}

class _Inicio_ScreenState extends State<Inicio_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Point'),
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
          const SizedBox(height: 30),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/ventaProducto');
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Ventas'),
          ),

          const SizedBox(height: 20),
          
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/listProducto');
            },
            icon: const Icon(Icons.inventory_rounded),
            label: const Text('Inventario de productos'),
          ),

          const SizedBox(height: 20),
          
          OutlinedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/listVenta');
            },
            icon: const Icon(Icons.featured_play_list_outlined),
            label: const Text('Lista de ventas'),
          ),

        ],
      ),
    );
  }
}