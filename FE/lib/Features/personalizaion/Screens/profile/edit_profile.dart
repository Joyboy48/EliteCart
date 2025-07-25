import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Utiles/Helpers/helper_functions.dart';
import '../../../../Utiles/HTTP/http_client.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  const EditProfileScreen({super.key, required this.profileData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController phoneNumber;
  late TextEditingController dob;

  String? selectedGender;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    firstName = TextEditingController(text: widget.profileData['firstName'] ?? '');
    lastName = TextEditingController(text: widget.profileData['lastName'] ?? '');
    phoneNumber = TextEditingController(text: widget.profileData['phoneNumber'] ?? '');

    // Normalize gender
    final genderRaw = widget.profileData['gender']?.toString().toLowerCase();
    if (genderRaw == 'male') selectedGender = 'Male';
    else if (genderRaw == 'female') selectedGender = 'Female';
    else if (genderRaw == 'other') selectedGender = 'Other';
    else selectedGender = null;

    dob = TextEditingController(text: widget.profileData['dob'] ?? '');
  }


  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dob.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  Future<void> saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      HelperFunctions.showSnackBar("Missing token");
      return;
    }

    try {
      final response = await HttpHelper().updateUserProfile(token, {
        "firstName": firstName.text.trim(),
        "lastName": lastName.text.trim(),
        "phoneNumber": phoneNumber.text.trim(),
        "gender": selectedGender ?? '',
        "dob": dob.text.trim(),
      });

      if (response['statusCode'] == 200) {
        HelperFunctions.showSnackBar("Profile updated");
        Get.back(result: true);  // go back and notify ProfileScreen to refresh
      } else {
        HelperFunctions.showSnackBar("Update failed");
      }
    } catch (e) {
      HelperFunctions.showSnackBar("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),

                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                validator: (value) => value == null || value.isEmpty ? "Select gender" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: dob,
                readOnly: true,
                onTap: pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) => value!.isEmpty ? "Select DOB" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveChanges,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}