import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  final String currentUserId;
  final String currentUserToken;

  const HomeScreen({Key? key, required this.currentUserId, required this.currentUserToken}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot>? searchResultsFuture;

  @override
  void initState() {
    super.initState();
    // authToken can be handled within class or through a dedicated auth management service
    // print(widget.currentUserToken); // If needed for debugging
  }

  void initiateSearch(String query) {
    if (query.isNotEmpty) {
      Future<QuerySnapshot> users = FirebaseFirestore.instance
          .collection('users')
          .where("searchKey", isEqualTo: query.substring(0, 1).toUpperCase())
          .get();

      setState(() {
        searchResultsFuture = users;
      });
    }
  }

  void handleSearch(String query) {
    initiateSearch(query);
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      searchResultsFuture = null;
    });
  }

  Widget buildSearchResults() {
    return FutureBuilder<QuerySnapshot>(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<UserResult> searchResults = [];
        snapshot.data!.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          if (widget.currentUserId != user.id) {
            searchResults.add(UserResult(user));
          }
        });

        return ListView(
          children: searchResults,
        );
      },
    );
  }

  AppBar buildSearchField() {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: "Search",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
          filled: true,
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: clearSearch,
          ),
        ),
        onSubmitted: handleSearch,
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget buildNoContent() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SvgPicture.asset('assets/images/search.svg', height: 300.0),
          Text(
            "Connect & Share",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildSearchField(),
      body: searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  const UserResult(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatPage(user: user))),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(user.displayName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              subtitle: Text(user.username, style: TextStyle(color: Colors.grey)),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
