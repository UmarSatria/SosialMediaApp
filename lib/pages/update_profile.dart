import 'dart:io'; // untuk file picker (hanya untuk mobile)
import 'dart:typed_data'; // untuk web
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // package untuk memilih gambar
import 'package:sosialmediaapp/components/my_textfield.dart'; // Komponen TextField custom

import 'display_profile.dart'; // Mengimpor halaman untuk menampilkan data yang telah diisi

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  // Controller untuk bio dan deskripsi
  TextEditingController bioController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? _image; // Untuk menyimpan gambar yang dipilih di mobile
  Uint8List? _webImage; // Untuk menyimpan gambar yang dipilih di web
  final ImagePicker _picker = ImagePicker(); // Untuk memilih gambar

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Pilih gambar untuk platform web
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Baca bytes dari file gambar
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes; // Simpan gambar sebagai Uint8List
        });
      }
    } else {
      // Pilih gambar untuk platform mobile
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Simpan file gambar untuk mobile
        });
      }
    }
  }

  // Fungsi untuk mengunggah data ke Firebase
  Future<void> _submitData() async {
    if ((_image == null && _webImage == null) || bioController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Unggah gambar ke Firebase Storage dan dapatkan URL
    String? imageUrl = await _uploadImage(_image, _webImage);

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error uploading image")),
      );
      return;
    }

    // Simpan data ke Firestore
    try {
      await FirebaseFirestore.instance.collection('Image').add({
        'bio': bioController.text,
        'description': descriptionController.text,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(), // Simpan waktu unggahan
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      // Pindah ke halaman DisplayProfile setelah berhasil disimpan
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DisplayProfile()),
      );

      // Kosongkan form setelah submit
      setState(() {
        bioController.clear();
        descriptionController.clear();
        _image = null;
        _webImage = null;
      });
    } catch (e) {
      print("Error saving data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving data!")),
      );
    }
  }

  // Fungsi untuk mengunggah gambar ke Firebase Storage
  Future<String?> _uploadImage(File? imageFile, Uint8List? webImage) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("images/$fileName");

      if (kIsWeb) {
        // Upload image for web using Uint8List
        UploadTask uploadTask = ref.putData(webImage!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        // Upload image for mobile using File
        UploadTask uploadTask = ref.putFile(imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar yang dipilih atau tombol untuk memilih gambar
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: kIsWeb
                    ? _webImage != null
                        ? MemoryImage(_webImage!)
                        : null
                    : _image != null
                        ? FileImage(_image!)
                        : null,
                child: (_image == null && _webImage == null) ? const Icon(Icons.add_a_photo, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),

            // TextField untuk bio
            MyTextfield(
              hintText: "Enter your bio",
              obscureText: false,
              controller: bioController,
            ),
            const SizedBox(height: 10),

            // TextField untuk deskripsi
            MyTextfield(
              hintText: "Enter a description",
              obscureText: false,
              controller: descriptionController,
            ),
            const SizedBox(height: 20),

            // Tombol untuk submit data
            ElevatedButton(
              onPressed: _submitData,
              child: const Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}