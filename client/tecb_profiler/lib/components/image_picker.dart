import 'dart:io'; // For File class
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  final void Function(String? imagePath) onImagePicked;

  const CustomImagePicker({
    super.key,
    required this.onImagePicked,
  });

  @override
  CustomImagePickerState createState() => CustomImagePickerState();
}

class CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  final int _maxSizeInBytes = 1 * 1024 * 1024; // 1 MB in bytes

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final File imageFile = File(image.path);
      final int imageSizeInBytes = await imageFile.length();

      // Check if image size exceeds 1MB
      if (imageSizeInBytes > _maxSizeInBytes) {
        _showImageSizeError();
      } else {
        setState(() {
          _imagePath = image.path;
        });
        widget.onImagePicked(image.path); // Pass the image path to the parent widget
      }
    }
  }

  // Show a dialog if the image is too large
  void _showImageSizeError() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Image Too Large'),
        content: const Text('Please select an image smaller than 1MB.'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: CupertinoColors.inactiveGray, width: 1),
        ),
        child: _imagePath == null
            ? const Icon(CupertinoIcons.camera, size: 40)
            : ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  File(_imagePath!),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
