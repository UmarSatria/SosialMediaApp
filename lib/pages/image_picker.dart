import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

// Halaman Image Picker Stateless
class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 35,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        title: const Text(
          "Image Picker",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 18),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: ((builder) => _ambilGambar()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.image_search),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFf2f2f2),
        child: Center(
          child: _imageBytes == null
              ? const Icon(
                  Icons.image_aspect_ratio,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 100,
                )
              : SizedBox(
                  width: 300, // Atur lebar gambar
                  height: 300, // Atur tinggi gambar
                  child: Image.memory(
                    _imageBytes!,
                    fit: BoxFit.cover, // Gambar akan menutupi seluruh area
                  ),
                ),
        ),
      ),
    );
  }

  Widget _ambilGambar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Wrap(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: const Text(
              "Ambil Gambar",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.camera);
                },
                child: Column(
                  children: [
                    const Icon(
                      Icons.camera,
                      size: 40,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Ambil dari Kamera"))
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  getImage(ImageSource.gallery);
                },
                child: Column(
                  children: [
                    const Icon(
                      Icons.image,
                      size: 40,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Ambil dari Galeri"))
                  ],
                ),
              ),
            ),
          ]),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(top: 20),
              color: Theme.of(context).colorScheme.primary,
              child: const Text(
                'TUTUP',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future getImage(ImageSource src) async {
    final XFile? image = await _picker.pickImage(source: src);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }
}
