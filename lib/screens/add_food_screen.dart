import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Comentado para Plan B
import '../config/app_colors.dart';
import '../main.dart'; // Para acceder a la clase FoodItem

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedExpiryDate;
  DateTime? _selectedPurchaseDate;
  String? _selectedCategory;

  final List<String> _categories = [
    'Lácteos', 'Frutas', 'Verduras', 'Carne', 'Pescado',
    'Panadería', 'Despensa', 'Congelados', 'Bebidas', 'Otros'
  ];

  Future<void> _pickDate(BuildContext context, {required bool isExpiryDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.verdeMedio,
              onPrimary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.verdeMedio,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isExpiryDate) {
          _selectedExpiryDate = picked;
        } else {
          _selectedPurchaseDate = picked;
        }
      });
    }
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedExpiryDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecciona una fecha de caducidad.'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    final newFoodItem = FoodItem(
      name: _nameController.text.trim(),
      expiryDate: _selectedExpiryDate!,
      purchaseDate: _selectedPurchaseDate,
      category: _selectedCategory,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      barcode: _barcodeController.text.trim().isNotEmpty ? _barcodeController.text.trim() : null,
    );

    Navigator.pop(context, newFoodItem);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Nuevo Alimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre del Producto'),
                  validator: (value) {
                    if (value == null || value.isEmpty) { return 'Por favor, introduce un nombre'; }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text("Fecha de Caducidad:", style: TextStyle(color: const Color.fromRGBO(22, 51, 71, 0.7), fontSize: 12)),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, color: AppColors.turquesa),
                  label: Text(
                    _selectedExpiryDate == null ? 'Seleccionar Fecha' : DateFormat('dd/MM/yyyy').format(_selectedExpiryDate!),
                    style: const TextStyle(color: AppColors.verdeMedio, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                  onPressed: () => _pickDate(context, isExpiryDate: true),
                ),
                const SizedBox(height: 12),
                Text("Fecha de Compra (opcional):", style: TextStyle(color: const Color.fromRGBO(22, 51, 71, 0.7), fontSize: 12)),
                TextButton.icon(
                  icon: const Icon(Icons.shopping_cart_checkout_outlined, color: AppColors.turquesa),
                  label: Text(
                    _selectedPurchaseDate == null ? 'Seleccionar Fecha' : DateFormat('dd/MM/yyyy').format(_selectedPurchaseDate!),
                    style: const TextStyle(color: AppColors.verdeMedio, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                  onPressed: () => _pickDate(context, isExpiryDate: false),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Categoría (opcional)'),
                  value: _selectedCategory,
                  hint: const Text('Selecciona una categoría'),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.turquesa),
                  items: _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? newValue) { setState(() { _selectedCategory = newValue; });},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(labelText: 'Código de Barras (opcional)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notas (opcional)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text('Guardar Alimento'),
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.verdeClaro,
                    foregroundColor: AppColors.azulOscuro,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}