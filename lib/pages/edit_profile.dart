import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petnaar/model/user.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  const EditProfile({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isLoading = false;
  late TextEditingController _displayNameController;
  late TextEditingController _bioController;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _bioController = TextEditingController();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    setState(() => _isLoading = true);
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(widget.currentUserId).get();
    _currentUser = User.fromDocument(userDoc);
    _displayNameController.text = _currentUser.displayName;
    _bioController.text = _currentUser.bio;
    setState(() => _isLoading = false);
  }

  Future<void> _updateProfileData() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    Map<String, dynamic> updateData = {
      "displayName": _displayNameController.text,
      "bio": _bioController.text,
    };

    if (_imageFile != null) {
      String filePath = 'userProfile_${_currentUser.id}.jpg';
      try {
        await FirebaseStorage.instance.ref(filePath).putFile(File(_imageFile!.path));
        String downloadUrl = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
        updateData["photoUrl"] = downloadUrl;
      } catch (e) {
        Fluttertoast.showToast(msg: "Image upload failed. Please try again.");
      }
    }

    await FirebaseFirestore.instance.collection('users').doc(widget.currentUserId).update(updateData);
    Fluttertoast.showToast(msg: "Profile updated successfully.", backgroundColor: Colors.green);
    setState(() => _isLoading = false);
  }

  Future<void> _handleImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() => _imageFile = pickedFile);
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Edit Profile", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done, size: 30.0, color: Colors.green),
            onPressed: _updateProfileData,
          )
        ],
      ),
      body: _isLoading ? linearProgress() : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildProfileImage(),
                _buildDisplayNameField(),
                _buildBioField(),
                _buildUpdateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _imageFile == null
            ? CachedNetworkImageProvider(_currentUser.photoUrl)
            : FileImage(File(_imageFile!.path)) as ImageProvider,
        child: IconButton(
          icon: Icon(FontAwesome.camera),
          onPressed: _handleImageFromGallery,
        ),
      ),
    );
  }

  Widget _buildDisplayNameField() {
    return TextFormField(
      controller: _displayNameController,
      decoration: InputDecoration(labelText: "Display Name"),
      validator: (value) {
        if (value!.trim().length < 3) return "Display name too short";
        return null;
      },
    );
  }

  Widget _buildBioField() {
    return TextFormField(
      controller: _bioController,
      decoration: InputDecoration(labelText: "Bio"),
      validator: (value) {
        if (value!.trim().length > 100) return "Bio cannot be longer than 100 characters";
        return null;
      },
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: _updateProfileData,
      child: Text("Update Profile"),
    );
  }
}
