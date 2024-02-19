import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';


class Upload extends StatefulWidget {
  final User currentUser;

  const Upload({Key? key, required this.currentUser}) : super(key: key);

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController _captionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  File? _mediaFile;
  bool _isUploading = false;
  bool _isVideo = false;
  String _postId = Uuid().v4();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleMedia(File file, bool isVideo) async {
    setState(() {
      _mediaFile = file;
      _isVideo = isVideo;
    });
  }

  Future<void> _selectMedia(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Create Post", style: TextStyle(fontWeight: FontWeight.bold)),
        children: <Widget>[
          SimpleDialogOption(
            child: Text("Take a picture!"),
            onPressed: () async {
              Navigator.pop(context);
              final PickedFile? pickedFile = await _picker.getImage(source: ImageSource.camera, maxHeight: 675, maxWidth: 960);
              if (pickedFile != null) {
                _handleMedia(File(pickedFile.path), false);
              }
            },
          ),
          SimpleDialogOption(
            child: Text("Upload Image from Gallery"),
            onPressed: () async {
              Navigator.pop(context);
              final PickedFile? pickedFile = await _picker.getImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                _handleMedia(File(pickedFile.path), false);
              }
            },
          ),
          SimpleDialogOption(
            child: Text("Upload Video from Gallery"),
            onPressed: () async {
              Navigator.pop(context);
              final PickedFile? pickedFile = await _picker.getVideo(source: ImageSource.gallery);
              if (pickedFile != null) {
                _handleMedia(File(pickedFile.path), true);
              }
            },
          ),
          SimpleDialogOption(
            child: Text("Cancel", style: TextStyle(color: Colors.blueAccent)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashScreen() {
    return Container(
      color: Colors.orangeAccent,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/images/upload.svg', height: 260),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Text("Upload Image", style: TextStyle(fontSize: 22.0, color: Colors.white, fontWeight: FontWeight.bold)),
              color: Colors.deepOrange,
              onPressed: () => _selectMedia(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadPost() async {
    setState(() => _isUploading = true);
    // Call your upload function here
    // After upload
    setState(() {
      _isUploading = false;
      _mediaFile = null; // Reset the file
      _captionController.clear();
      _locationController.clear();
      _postId = Uuid().v4(); // Generate a new post ID for next post
    });
    Fluttertoast.showToast(msg: "Post uploaded successfully!");
  }

  Widget _buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: () => setState(() => _mediaFile = null)),
        title: Text("Caption Post", style: TextStyle(color: Colors.black)),
        actions: [
          FlatButton(
            onPressed: _isUploading ? null : _uploadPost,
            child: Text("Post", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 20.0)),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _isUploading ? linearProgress() : SizedBox.shrink(),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: _captionController,
                decoration: InputDecoration(hintText: "Write a caption..."),
              ),
            ),
          ),
          // Include other fields and the media preview
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _mediaFile == null ? _buildSplashScreen() : _buildUploadForm();
  }

  @override
  void dispose() {
    _captionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
