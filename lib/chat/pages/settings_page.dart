import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:PetNaar/widgets/progress.dart';
import 'package:PetNaar/pages/home.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Account Settings",
          style: TextStyle(fontFamily: "Kalam", fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  File? _imageFileAvatar;
  bool _isLoading = false;
  bool _displayNameValid = true;
  bool _bioValid = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Consider implementing if there's data to load initially
  }

  Future<void> _getImage() async {
    File? newImgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (newImgFile != null) {
      setState(() => _imageFileAvatar = newImgFile);
    }
  }

  Future<void> _uploadImageToFirestore() async {
    if (_imageFileAvatar == null) return;
    setState(() => _isLoading = true);
    String fileName = currentUser.id;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(_imageFileAvatar!);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String newImageDownloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    Firestore.instance.collection('users').doc(currentUser.id).update({"photoUrl": newImageDownloadUrl});
    setState(() => _isLoading = false);
    Fluttertoast.showToast(msg: "Profile picture updated.");
  }

  void _updateData() {
    setState(() {
      _displayNameValid = _nicknameController.text.trim().length >= 3;
      _bioValid = _bioController.text.trim().length <= 50;
    });

    if (_displayNameValid && _bioValid) {
      usersRef.doc(currentUser.id).update({
        "displayName": _nicknameController.text,
        "bio": _bioController.text,
      });
      final snackbar = SnackBar(content: Text("Profile Updated!"), backgroundColor: Colors.orange);
      _scaffoldKey.currentState?.showSnackBar(snackbar);
    }
  }

  void _logout() {
    googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _isLoading ? linearProgress() : Container(),
            _profilePicture(),
            _buildTextField("Bio", _bioController, _bioValid),
            _buildTextField("Profile Name", _nicknameController, _displayNameValid),
            _updateProfileButton(),
            _logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _profilePicture() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage: _imageFileAvatar != null
                ? FileImage(_imageFileAvatar!)
                : (currentUser.photoUrl.isNotEmpty ? CachedNetworkImageProvider(currentUser.photoUrl) : null),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              icon: Icon(FontAwesome.camera),
              color: Colors.blue,
              onPressed: _getImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isValid) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          errorText: isValid ? null : "Field is not valid",
        ),
        onChanged: (value) => _updateData(),
      ),
    );
  }

  Widget _updateProfileButton() {
    return ElevatedButton(
      onPressed: _updateData,
      child: Text("Update Profile"),
      style: ElevatedButton.styleFrom(primary: Colors.orangeAccent),
    );
  }

  Widget _logoutButton() {
    return TextButton(
      onPressed: _logout,
      child: Text("Logout", style: TextStyle(color: Colors.red)),
    );
  }
}
