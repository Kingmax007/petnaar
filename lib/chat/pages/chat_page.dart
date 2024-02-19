// Ensure all imports are correct and necessary packages are added to your pubspec.yaml.
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chat extends StatelessWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String receiverToken;

  Chat({Key? key, required this.receiverId, required this.receiverAvatar, required this.receiverName, required this.receiverToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppBar and body implementation remains the same.
  }
}

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverAvatar;
  final String receiverName;
  final String receiverToken;

  ChatScreen({Key? key, required this.receiverId, required this.receiverAvatar, required this.receiverName, required this.receiverToken}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String id; // Assuming this is the sender's ID
  late SharedPreferences preferences;
  bool isDisplaySticker = false;
  bool isLoading = false;
  String chatId = "";
  final ScrollController listScrollController = ScrollController();
  final TextEditingController chatTextController = TextEditingController();
  final FocusNode chatFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    chatFocusNode.addListener(onFocusChange);
    readLocal();
  }

  readLocal() async {
    preferences = await SharedPreferences.getInstance();
    id = /* Obtain from SharedPreferences or a global currentUser */;
    // Your logic to determine chatId remains unchanged.
  }

  onFocusChange() {
    if (chatFocusNode.hasFocus) {
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  Future getImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source:ImageSource.gallery);

    if (image != null) {
      setState(() {
        isLoading = true;
      });
      uploadImageFile(File(image.path));
    }
  }

  uploadImageFile(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = FirebaseStorage.instance.ref().child("Chat Images").child(fileName);
    UploadTask uploadTask = storageReference.putFile(imageFile);
    try {
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
      });
      sendMsg(downloadUrl, 1);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  sendMsg(String contentMsg, int type) {
    // Your message sending logic here.
  }

  @override
  Future<Widget> build (BuildContext context) async {
    // Your widget building logic here.
  }
}

// Widget methods like createItem, createInput, etc., and other helper methods remain largely unchanged but ensure they are correctly implemented according to the new Firebase and Flutter APIs.
