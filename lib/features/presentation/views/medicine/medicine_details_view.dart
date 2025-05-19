import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/app_colors.dart';

class MedicineSearchView extends StatefulWidget {
  final http.Client client;


  @override
  State<MedicineSearchView> createState() => _MedicineSearchViewState();

  MedicineSearchView({Key? key, http.Client? client})
      : client = client ??  http.Client(),
        super(key: key);
}

class _MedicineSearchViewState extends State<MedicineSearchView> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _medicineData;
  bool _isLoading = false;
  String? _error;

  Future<void> _searchMedicine() async {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _medicineData = null;
    });

    final url = Uri.parse('https://api.fda.gov/drug/label.json?search=$query');

    try {
      final response = await widget.client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['results'] != null && data['results'].isNotEmpty) {
          setState(() {
            _medicineData = data['results'][0];
          });
        } else {
          setState(() {
            _error = "No data found for '$query'";
          });
        }
      } else {
        setState(() {
          _error = "Failed to fetch data. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _error = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6),
        Text(content, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildMedicineDetails() {
    if (_medicineData == null) return const SizedBox();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _medicineData!['openfda']?['brand_name']?.join(', ') ?? "Unknown Medicine",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const Divider(height: 30),
            if (_medicineData!['purpose'] != null)
              _buildSection("Purpose", _medicineData!['purpose']?.join(' ') ?? ''),
            if (_medicineData!['indications_and_usage'] != null)
              _buildSection("Usage", _medicineData!['indications_and_usage']?.join(' ') ?? ''),
            if (_medicineData!['dosage_and_administration'] != null)
              _buildSection("Dosage", _medicineData!['dosage_and_administration']?.join(' ') ?? ''),
            if (_medicineData!['warnings'] != null)
              _buildSection("Warnings", _medicineData!['warnings']?.join(' ') ?? ''),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appWhiteColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.appWhiteColor),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Search Medicine"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.appWhiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _searchMedicine(),
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Enter medicine name",
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchMedicine,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading) const CircularProgressIndicator(),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                ),
              if (_medicineData != null) _buildMedicineDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
