import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DisplayProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Display'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Image').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text("No data available"));
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;
              String imageUrl = data['imageUrl'] ?? '';
              String bio = data['bio'] ?? '';
              String description = data['description'] ?? '';
              String docId = documents[index].id;

              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                title: Text(bio),
                subtitle: Text(description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _navigateToUpdatePage(context, docId, bio, description, imageUrl);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteData(docId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _deleteData(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Image').doc(docId).delete();
      print("Data berhasil dihapus");
    } catch (e) {
      print("Error saat menghapus data: $e");
    }
  }

  void _navigateToUpdatePage(BuildContext context, String docId, String bio, String description, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(
          docId: docId,
          bio: bio,
          description: description,
          imageUrl: imageUrl,
        ),
      ),
    );
  }
}

class UpdateProfilePage extends StatefulWidget {
  final String docId;
  final String bio;
  final String description;
  final String imageUrl;

  const UpdateProfilePage({
    Key? key,
    required this.docId,
    required this.bio,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController bioController;
  late TextEditingController descriptionController;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    bioController = TextEditingController(text: widget.bio);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    bioController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return widget.imageUrl;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${widget.docId}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(_imageFile!);

      final newImageUrl = await storageRef.getDownloadURL();
      return newImageUrl;
    } catch (e) {
      print("Error saat mengupload gambar: $e");
      return null;
    }
  }

  void _updateData() async {
    String? newImageUrl = await _uploadImage();

    if (newImageUrl == null) return;

    try {
      await FirebaseFirestore.instance.collection('Image').doc(widget.docId).update({
        'bio': bioController.text,
        'description': descriptionController.text,
        'imageUrl': newImageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error saat mengupdate data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _imageFile != null
                    ? FileImage(_imageFile!)
                    : NetworkImage(widget.imageUrl) as ImageProvider,
                child: _imageFile == null ? const Icon(Icons.camera_alt) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(labelText: 'Bio'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              child: const Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
