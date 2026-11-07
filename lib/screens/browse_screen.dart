import 'package:flutter/material.dart';
import '/widgets/city_card.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/hobby_row.dart';
import '../widgets/book_row.dart';

enum ContentCategory { cities, hobbies, books }

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  ContentCategory selectedCategory = ContentCategory.cities;
  String searchText = "";

  String get searchHint => "Search ${selectedCategory.name}";

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SegmentedButton(
                segments: [
                  ButtonSegment(
                    value: ContentCategory.cities,
                    label: Text("Cities"),
                  ),
                  ButtonSegment(
                    value: ContentCategory.hobbies,
                    label: Text("Hobbies"),
                  ),
                  ButtonSegment(
                    value: ContentCategory.books,
                    label: Text("Books"),
                  ),
                ],
                selected: {selectedCategory},
                onSelectionChanged: (selection) {
                  setState(() {
                    selectedCategory = selection.first;
                  });
                },
              ),

              SizedBox(height: 16),

              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: searchHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),

              SizedBox(height: 16),

              Expanded(
                child: Builder(
                  builder: (context) 
                  {
                    final search = searchText.toLowerCase();
                    switch (selectedCategory) {
                      case ContentCategory.cities:
                        final cities = favoritesProvider.cities
                            .where((city) =>
                                city.cityName.toLowerCase().contains(search))
                            .toList();
                        return ListView.builder(
                          itemCount: cities.length,
                          itemBuilder: (context, index) {
                            return CityCard(city: cities[index]);
                          },
                        );

                      case ContentCategory.hobbies:
                        final hobbies = favoritesProvider.hobbies
                            .where((hobby) =>
                                hobby.hobbyName.toLowerCase().contains(search))
                            .toList();
                      
                        return ListView.builder(
                          itemCount: hobbies.length,
                          itemBuilder: (context, index) {
                            return HobbyRow(hobby: hobbies[index]);
                          },
                        );

                      case ContentCategory.books:
                        final books = favoritesProvider.books
                            .where((book) =>
                                book.bookTitle.toLowerCase().contains(search) ||
                                book.bookAuthor.toLowerCase().contains(search))
                            .toList();
                   
                        return ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            return BookRow(book: books[index]);
                          },
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
