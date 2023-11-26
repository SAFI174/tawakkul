import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Import GetStorage

import '../../constants/cache_keys.dart';
import '../models/quran_bookmark.dart';

class BookmarkCache {
  // Observable list of bookmarks
  final bookmarks = <Bookmark>[].obs;

  final GetStorage _box = GetStorage('bookmarks');

  // Load bookmarks from GetStorage
  Future<void> loadBookmarks() async {
    // Retrieve bookmarks data from GetStorage
    final bookmarksData = await _box.read(bookmarksKey);

    if (bookmarksData != null) {
      // If there are saved bookmarks, decode and assign them to the observable list
      final List<dynamic> bookmarksList = json.decode(bookmarksData);
      bookmarks.assignAll(bookmarksList
          .map((bookmark) {
            return Bookmark.fromJson(bookmark);
          })
          .toList()
          .reversed
          .toList());
    }
  }

  // Add a bookmark to the list and save to GetStorage
  Future<void> addBookmark(Bookmark bookmark) async {
    bookmark.addedDate = DateTime.now();
    // Add the bookmark to the observable list
    bookmarks.add(bookmark);

    // Save the updated list of bookmarks to GetStorage
    await _saveBookmarks();
  }

  // Delete a bookmark from the list and save to GetStorage
  Future<void> deleteBookmark(Bookmark bookmark) async {
    // Remove the bookmark from the observable list
    bookmarks.removeWhere(
        (b) => b.surah == bookmark.surah && b.verse == bookmark.verse);

    // Save the updated list of bookmarks to GetStorage
    await _saveBookmarks();
  }

  // Save the current list of bookmarks to GetStorage
  Future<void> _saveBookmarks() async {
    // Convert the list of bookmarks to JSON format and store it in GetStorage
    final bookmarksList =
        bookmarks.map((bookmark) => bookmark.toJson()).toList();
    await _box.write(bookmarksKey, json.encode(bookmarksList));
  }

  // Check if a specific verse is bookmarked
  bool checkBookmark(Bookmark bookmark) {
    // Check if the provided bookmark exists in the list of bookmarks
    return bookmarks
        .any((b) => b.surah == bookmark.surah && b.verse == bookmark.verse);
  }
}
