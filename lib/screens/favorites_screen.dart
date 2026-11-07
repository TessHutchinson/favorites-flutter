import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorites_provider.dart';
import '../widgets/book_row.dart';
import '../widgets/city_card.dart';
import '../widgets/hobby_row.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final favoriteCities =
        favoritesProvider.cities.where((city) => city.isFavorite).toList();
    final favoriteHobbies =
        favoritesProvider.hobbies.where((hobby) => hobby.isFavorite).toList();
    final favoriteBooks =
        favoritesProvider.books.where((book) => book.isFavorite).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final city in favoriteCities) CityCard(city: city),
            for (final hobby in favoriteHobbies) HobbyRow(hobby: hobby),
            for (final book in favoriteBooks) BookRow(book: book),
          ],
        ),
      ),
    );
  }
}