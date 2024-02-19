import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchController {
  final FirebaseFirestore _firestore;

  SearchController({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Function to search users by display name
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final searchResults = await _firestore
        .collection('users')
        .where('searchKey', isEqualTo: query.substring(0, 1).toUpperCase())
        .get();

    List<Map<String, dynamic>> users = [];
    for (var doc in searchResults.docs) {
      var userData = doc.data();
      // Add document ID to user data
      userData['id'] = doc.id;
      users.add(userData);
    }
    return users;
  }

  // Optional: Function to fetch recent search suggestions or users
  Future<List<Map<String, dynamic>>> fetchRecentSearchSuggestions() async {
    // Implement your logic to fetch recent search suggestions
    // This could be based on user's past searches, popular searches, etc.
    return [];
  }
}
