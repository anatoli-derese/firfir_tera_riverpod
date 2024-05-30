import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firfir_tera/models/presentation/widgets/recipe_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firfir_tera/providers/discover_provider.dart';

class Discover extends ConsumerWidget {
  const Discover({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _searchController = TextEditingController();
    final selectedOption = ref.watch(selectedOptionProvider);

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text("Search", style: GoogleFonts.dancingScript(fontSize: 30)),
              Text("for Recipes", style: GoogleFonts.firaSans(fontSize: 40)),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "recipe name",
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onChanged: (val) {},
                onSubmitted: (val) {},
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                children: [
                  buildOptionButton(ref, "All", "food"),
                  buildOptionButton(ref, "Breakfast", "breakfast"),
                  buildOptionButton(ref, "Lunch", "lunch"),
                  buildOptionButton(ref, "Dinner", "dinner"),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Trending",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recipeList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: RecipeCard(
                        imagePath: recipeList[index].imagePath,
                        recipeName: recipeList[index].recipeName,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOptionButton(WidgetRef ref, String option, String iconName) {
    Map<String, String> iconMap = {
      "food": "assets/icons/all_food.png",
      "breakfast": "assets/icons/breakfast.png",
      "lunch": "assets/icons/lunch.png",
      "dinner": "assets/icons/dinner.png"
    };

    String iconPath = iconMap[iconName] ?? '';
    final selectedOption = ref.watch(selectedOptionProvider);

    return InkWell(
      onTap: () {
        ref.read(selectedOptionProvider.notifier).setOption(option);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: selectedOption == option ? Colors.grey[200] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Image.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
            Text(
              option,
              style: TextStyle(
                fontSize: selectedOption == option ? 18 : 16,
                fontWeight: selectedOption == option
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: selectedOption == option ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}