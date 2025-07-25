import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:studio_projects/Utiles/constants/api_constants.dart';
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final discountController = TextEditingController();

  List<String> categories = [];
  String? selectedCategory;
  List<Map<String, dynamic>> brands = [];
  String? selectedBrandId;
  bool showBrandForm = false;
  final brandNameController = TextEditingController();
  File? brandLogo;

  List<File> images = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchBrands();
  }

  Future<void> fetchCategories() async {
    final res = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/categories/categories'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        categories = List<String>.from(data['data'].map((c) => c['name']));
      });
    }
  }

  Future<void> fetchBrands() async {
    final res =
        await http.get(Uri.parse('${ApiConstants.baseUrl}/brands/brands'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        brands = List<Map<String, dynamic>>.from(data['data']);
      });
    }
  }

  Future<String?> createBrand() async {
    if (brandNameController.text.isEmpty || brandLogo == null) return null;
    var req = http.MultipartRequest(
        'POST', Uri.parse('${ApiConstants.baseUrl}/brands/brand'));
    req.fields['name'] = brandNameController.text;
    req.files.add(await http.MultipartFile.fromPath('logo', brandLogo!.path));
    var res = await req.send();
    if (res.statusCode == 201) {
      final resp = await res.stream.bytesToString();
      final data = json.decode(resp);
      return data['data']['_id'];
    }
    return null;
  }

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked != null) {
      setState(() {
        images = picked.map((x) => File(x.path)).toList();
      });
    }
  }

  Future<void> pickBrandLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        brandLogo = File(picked.path);
      });
    }
  }

  Future<void> submitProduct() async {
    if (!_formKey.currentState!.validate() ||
        images.isEmpty ||
        (showBrandForm &&
            (brandNameController.text.isEmpty || brandLogo == null))) return;

    String? brandId = selectedBrandId;
    if (showBrandForm) {
      brandId = await createBrand();
      if (brandId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Brand creation failed')));
        return;
      }
      await fetchBrands();
    }

    var req = http.MultipartRequest(
        'POST', Uri.parse('${ApiConstants.baseUrl}/products/product'));
    req.fields['name'] = nameController.text;
    req.fields['description'] = descController.text;
    req.fields['price'] = priceController.text;
    req.fields['stock'] = stockController.text;
    req.fields['discount'] =
        discountController.text.isEmpty ? '0' : discountController.text;
    req.fields['brandId'] = brandId!;
    req.fields['categories'] = selectedCategory!;

    for (var img in images) {
      req.files.add(await http.MultipartFile.fromPath('images', img.path));
    }

    var res = await req.send();
    if (res.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product added!')));
      Navigator.pop(context);
    } else {
      final resp = await res.stream.bytesToString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $resp')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: discountController,
                decoration:
                    const InputDecoration(labelText: 'Discount (optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => v == null ? 'Select a category' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedBrandId,
                      items: brands
                          .map((b) => DropdownMenuItem<String>(
                                value: b['_id'].toString(),
                                child: Text(b['name']),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() {
                        selectedBrandId = v;
                        showBrandForm = false;
                      }),
                      decoration: const InputDecoration(labelText: 'Brand'),
                      validator: (v) => v == null && !showBrandForm
                          ? 'Select a brand or add new'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () =>
                        setState(() => showBrandForm = !showBrandForm),
                    child: Text(showBrandForm ? 'Cancel' : 'Add Brand'),
                  ),
                ],
              ),
              if (showBrandForm) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: brandNameController,
                  decoration:
                      const InputDecoration(labelText: 'New Brand Name'),
                  validator: (v) => showBrandForm && (v == null || v.isEmpty)
                      ? 'Required'
                      : null,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: pickBrandLogo,
                      child: const Text('Pick Brand Logo'),
                    ),
                    const SizedBox(width: 8),
                    if (brandLogo != null)
                      Text('Logo selected',
                          style: TextStyle(color: Colors.green)),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: pickImages,
                child: const Text('Pick Product Images'),
              ),
              const SizedBox(height: 8),
              Wrap(
                children: images
                    .map((img) => Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.file(img,
                              width: 60, height: 60, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: submitProduct,
                  child: const Text('Save Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
