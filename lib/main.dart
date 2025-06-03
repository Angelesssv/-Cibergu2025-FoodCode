import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart'; // Comentado
// import 'package:cloud_firestore/cloud_firestore.dart'; // Comentado

import 'config/app_colors.dart';
import 'screens/add_food_screen.dart';    // <-- ASEGÚRATE DE QUE ESTA IMPORTACIÓN ESTÉ BIEN
import 'screens/settings_screen.dart';
import 'screens/accessibility_settings_screen.dart'; // Para la navegación desde Settings
import 'screens/security_settings_screen.dart';    // Para la navegación desde Settings


// Clase FoodItem
class FoodItem {
  final String? id;
  final String name;
  final DateTime expiryDate;
  final DateTime? purchaseDate;
  final String? category;
  final String? notes;
  final String? barcode;
  final IconData icon;

  FoodItem({
    this.id,
    required this.name,
    required this.expiryDate,
    this.purchaseDate,
    this.category,
    this.notes,
    this.barcode,
    this.icon = Icons.hexagon_outlined,
  });
}

DateTime _parseDate(String dateStr) {
  try {
    final format = DateFormat('dd/MM/yyyy');
    return format.parseStrict(dateStr);
  } catch (e) {
    return DateTime.now();
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fresko App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.verdeMedio,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: AppColors.verdeMedio,
          onPrimary: Colors.white,
          secondary: AppColors.verdeClaro,
          onSecondary: AppColors.azulOscuro,
          surface: Colors.white,
          onSurface: AppColors.azulOscuro,
          error: Colors.red.shade700,
          onError: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.verdeMedio,
          foregroundColor: Colors.white,
          elevation: 4.0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.verdeClaro,
          foregroundColor: AppColors.azulOscuro,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.azulOscuro, fontSize: 16),
          bodyMedium: TextStyle(color: AppColors.azulOscuro, fontSize: 14),
          titleLarge: TextStyle(color: AppColors.azulOscuro, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Color.fromRGBO(22, 51, 71, 0.9)),
          hintStyle: const TextStyle(color: Color.fromRGBO(22, 51, 71, 0.6)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color.fromRGBO(56, 163, 165, 0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.verdeMedio, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color.fromRGBO(56, 163, 165, 0.7)),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  List<FoodItem> _foodItems = [
    FoodItem(name: 'Leche Freska', expiryDate: _parseDate('05/07/2025'), category: 'Lácteos'),
    FoodItem(name: 'Yogures de Fresa', expiryDate: _parseDate('15/06/2025'), category: 'Lácteos'),
    FoodItem(name: 'Queso Curado', expiryDate: _parseDate('03/06/2025'), category: 'Lácteos'),
    FoodItem(name: 'Manzanas Golden', expiryDate: _parseDate('30/08/2025'), icon: Icons.apple_outlined, category: 'Frutas'),
    FoodItem(name: 'Pan de Molde Integral', expiryDate: _parseDate('02/06/2025'), category: 'Panadería'),
    FoodItem(name: 'Tomates para Ensalada', expiryDate: _parseDate('28/05/2025'), category: 'Verduras'),
  ];

  late List<Widget> _widgetOptions;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Color _getExpiryIndicatorColor(DateTime expiryDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final differenceInDays = expiryDate.difference(today).inDays;

    if (differenceInDays < 0) { return Colors.grey.shade600; }
    else if (differenceInDays <= 3) { return Colors.red.shade400; }
    else if (differenceInDays <= 14) { return Colors.yellow.shade700;}
    else { return AppColors.verdeClaro; }
  }

  ListView _buildFoodListView() {
    List<FoodItem> displayedItems = _foodItems;
    if (_searchQuery.isNotEmpty) {
      displayedItems = _foodItems.where((item) {
        return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    displayedItems.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    if (displayedItems.isEmpty) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'No se encontraron alimentos que coincidan con "$_searchQuery".'
                    : 'No hay alimentos en tu inventario.\n¡Añade algunos con el botón +!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: AppColors.azulOscuro),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: displayedItems.length,
      itemBuilder: (BuildContext context, int index) {
        final item = displayedItems[index];
        final indicatorColor = _getExpiryIndicatorColor(item.expiryDate);
        final formattedDate = DateFormat('dd/MM/yyyy').format(item.expiryDate);
        final categoryText = item.category != null ? 'Categoría: ${item.category}' : 'Sin categoría';

        return Card(
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: indicatorColor, width: 5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            leading: Icon(item.icon, size: 40, color: AppColors.turquesa),
            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.azulOscuro)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Caduca: $formattedDate', style: TextStyle(color: AppColors.azulOscuro.withAlpha(180))),
                if (item.category != null)
                  Text(categoryText, style: TextStyle(fontSize: 12, color: AppColors.azulOscuro.withAlpha(150))),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.check_circle_outline, color: AppColors.verdeClaro),
              onPressed: () { /* TODO: Implementar lógica LOCAL para borrar o marcar */ },
            ),
            onTap: () { /* TODO: Implementar lógica LOCAL para ver/editar */ },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text;
          _updateWidgetOptions();
        });
      }
    });
    _updateWidgetOptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateWidgetOptions() {
    _widgetOptions = <Widget>[
      const Center(child: Text('Contenido de Comunidad', style: TextStyle(fontSize: 24, color: AppColors.azulOscuro))),
      _buildFoodListView(),
      const Center(child: Text('Contenido de Freskly', style: TextStyle(fontSize: 24, color: AppColors.azulOscuro))),
    ];
  }

  void _onItemTapped(int index) {
    setState(() { _selectedIndex = index; });
  }

  void _showAddOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Añadir Producto', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.azulOscuro, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.turquesa, size: 30),
                title: const Text('Agregar con la cámara', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro)),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Funcionalidad de cámara no implementada aún')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit_note_outlined, color: AppColors.turquesa, size: 30),
                title: const Text('Agregar manualmente', style: TextStyle(fontSize: 16, color: AppColors.azulOscuro)),
                onTap: () async {
                  Navigator.pop(sheetContext);

                  final newFoodItem = await Navigator.push<FoodItem>(
                    context,
                    MaterialPageRoute(builder: (context) => const AddFoodScreen()), // Llamada correcta
                  );

                  if (newFoodItem != null) {
                    setState(() {
                      _foodItems.add(newFoodItem);
                      _updateWidgetOptions();
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitleText;
    switch (_selectedIndex) {
      case 0: appBarTitleText = 'Comunidad Fresko'; break;
      case 1: appBarTitleText = 'Fresko - Mis Alimentos'; break;
      case 2: appBarTitleText = 'Freskly IA'; break;
      default: appBarTitleText = 'Fresko App';
    }

    return Scaffold(
      appBar: AppBar(
        leading: _selectedIndex == 1
            ? IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Ajustes',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()), // Llamada correcta
            );
          },
        )
            : null,
        title: _selectedIndex == 1
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: AppColors.verdeClaro,
            decoration: InputDecoration(
              hintText: 'Buscar productos...',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: const Color.fromRGBO(255, 255, 255, 0.7)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            ),
          ),
        )
            : Text(appBarTitleText),
        actions: _selectedIndex == 1
            ? <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: 'Filtros',
            onPressed: () { /* TODO: Mostrar filtros */ },
          ),
        ]
            : null,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
        onPressed: () {
          _showAddOptionsBottomSheet(context);
        },
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Comunidad',),
          BottomNavigationBarItem(icon: Icon(Icons.eco_outlined), label: 'Vida',),
          BottomNavigationBarItem(icon: Icon(Icons.psychology_outlined), label: 'Freskly',),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: AppColors.verdeMuyClaro,
        selectedItemColor: AppColors.verdeMedio,
        unselectedItemColor: const Color.fromRGBO(22, 51, 71, 0.6),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        iconSize: 28.0,
        selectedFontSize: 14.0,
        unselectedFontSize: 12.0,
      ),
    );
  }
}