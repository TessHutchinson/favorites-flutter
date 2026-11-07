import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sample_data.dart';

class FavoritesProvider extends ChangeNotifier {
  bool isDarkMode = false;

  final cities = sampleCities;
  final hobbies = sampleHobbies;
  final books = sampleBooks;

  FavoritesProvider() {
    loadFavorites();
    loadHobbiesFavorites();
    loadBooksFavorites();
    loadDarkMode();
  }

  void toggleHobbyFavorite(int hobbyId) {
    final hobby = hobbies.firstWhere((hobby) => hobby.id == hobbyId);
    hobby.isFavorite = !hobby.isFavorite;
    saveHobbieFavorites();
    notifyListeners();
  }

  void toggleBookFavorite(int bookId) {
    final book = books.firstWhere((book) => book.id == bookId);
    book.isFavorite = !book.isFavorite;
    saveBooksFavorites();
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    isDarkMode = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void toggleCityFavorite(int cityId) {
    final city = cities.firstWhere((city) => city.id == cityId);

    city.isFavorite = !city.isFavorite;

    saveFavorites();

    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteIds = cities
        .where((city) => city.isFavorite)
        .map((city) => city.id.toString())
        .toList();

    await prefs.setStringList('favoriteCities', favoriteIds);
  }

  Future<void> saveHobbieFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteHobbiesIds = hobbies
        .where((hobby) => hobby.isFavorite)
        .map((hobby) => hobby.id.toString())
        .toList();

    await prefs.setStringList('favoriteHobbies', favoriteHobbiesIds);
  }

  Future<void> saveBooksFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteBooksIds = books
        .where((book) => book.isFavorite)
        .map((book) => book.id.toString())
        .toList();

    await prefs.setStringList('favoriteBooks', favoriteBooksIds);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteIds = prefs.getStringList('favoriteCities') ?? [];

    for (final city in cities) {
      city.isFavorite = favoriteIds.contains(city.id.toString());
    }

    notifyListeners();
  }

  Future<void> loadBooksFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteBooksIds = prefs.getStringList('favoriteBooks') ?? [];

    for (final book in books) {
      book.isFavorite = favoriteBooksIds.contains(book.id.toString());
    }

    notifyListeners();
  }

  Future<void> loadHobbiesFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final favoriteHobbiesIds = prefs.getStringList('favoriteHobbies') ?? [];

    for (final hobby in hobbies) {
      hobby.isFavorite = favoriteHobbiesIds.contains(hobby.id.toString());
    }

    notifyListeners();
  }

   Future<void> clearFavorites() async {
    for (final city in cities) {
      city.isFavorite = false;
    }
    for (final hobby in hobbies) {
      hobby.isFavorite = false;
    }
    for (final book in books) {
      book.isFavorite = false;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favoriteCities');
    await prefs.remove('favoriteHobbies');
    await prefs.remove('favoriteBooks');
  }
}
