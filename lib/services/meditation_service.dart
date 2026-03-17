import 'package:cloud_firestore/cloud_firestore.dart';

class MeditationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all meditations
  Future<List<Map<String, dynamic>>> getAllMeditations() async {
    QuerySnapshot snapshot = await _firestore.collection('meditations').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Get meditations by category
  Future<List<Map<String, dynamic>>> getMeditationsByCategory(String category) async {
    QuerySnapshot snapshot = await _firestore.collection('meditations').where('category', isEqualTo: category).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Get a meditation by ID
  Future<Map<String, dynamic>?> getMeditationById(String id) async {
    DocumentSnapshot snapshot = await _firestore.collection('meditations').doc(id).get();
    return snapshot.data() as Map<String, dynamic>?;
  }

  // Add a meditation
  Future<void> addMeditation(Map<String, dynamic> meditationData) async {
    await _firestore.collection('meditations').add(meditationData);
  }

  // Update a meditation
  Future<void> updateMeditation(String id, Map<String, dynamic> meditationData) async {
    await _firestore.collection('meditations').doc(id).update(meditationData);
  }

  // Delete a meditation
  Future<void> deleteMeditation(String id) async {
    await _firestore.collection('meditations').doc(id).delete();
  }

  // Get categories
  Future<List<String>> getCategories() async {
    // Assuming categories are stored in a separate collection
    QuerySnapshot snapshot = await _firestore.collection('categories').get();
    return snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
        .toList();
  }
}