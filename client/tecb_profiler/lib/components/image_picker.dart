import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class CustomImagePicker extends StatefulWidget {
  final void Function(String? imagePath) onImagePicked;

  const CustomImagePicker({
    super.key,
    required this.onImagePicked,
  });

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
      widget.onImagePicked(image.path); // Pass the image path to the parent widget
    }
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
