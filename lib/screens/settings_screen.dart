import 'package:favorites/providers/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

    void confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Clear all favorites?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<FavoritesProvider>().clearFavorites();
              Navigator.pop(dialogContext);
            },
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final favoritesProvider = Provider.of<FavoritesProvider>(context); 
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  Switch(
                    value: favoritesProvider.isDarkMode,
                    onChanged: (value) {
                      favoritesProvider.toggleDarkMode(value);
                    },
                  ),
                ],
              ),
                 const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () => confirmClear(context),
                child: const Text("Clear Favorites"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}