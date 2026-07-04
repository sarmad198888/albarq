import 'package:flutter/material.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": "🍔", "title": "بركر"},
      {"icon": "🍕", "title": "بيتزا"},
      {"icon": "🍗", "title": "دجاج"},
      {"icon": "🥤", "title": "مشروبات"},
      {"icon": "🍰", "title": "حلويات"},
    ];

    return SizedBox(
      height: 95,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.red.shade50,
                  child: Text(
                    categories[index]["icon"]!,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(height: 8),
                Text(categories[index]["title"]!),
              ],
            ),
          );
        },
      ),
    );
  }
}