import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_nomnom_collective/DietHomePage.dart';
import 'package:the_nomnom_collective/HomePage.dart';
import 'datastorage.dart'; // Imports the DataBaseHelper class for database options

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  bool isBreakfastSelected =
      false; // Tracks if the breakfast filter is active or not
  bool isLunchDinnerSelected =
      false; // Tracks if the Lunch/Dinner filter is active or not
  final TextEditingController _searchController =
      TextEditingController(); // Controller for the search bar
  List<Map<String, dynamic>> _allFoodItems =
      []; // Stores all food items from the database
  List<Map<String, dynamic>> _filteredFoodItems =
      []; // Stores food items filtered by search and category
  List<String> restrictedFoods =
      []; // Stores food items restricted by selected disease
  List<Map<String, dynamic>> diseases =
      []; // Stores available diseases from the database
  List<int> selectedDiseaseIds = []; // Stores ID's of selected diseases
  String selectedCategory = ''; // Tracks the currently selected food category

  @override
  void initState() {
    super.initState();
    _loadFoodItems(); // Loads all food items from the database on initialization
    _loadDiseases(); // Loads disease data from the database on initialization
  }

  // Navigates to the HomePage
  void goToHomePage() {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
  }

  // Navigates to the DietHomePage
  void goToDietHomePage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DietHomePage()));
  }

  // Loads all food items from the database and updates states
  Future<void> _loadFoodItems() async {
    final db = await DatabaseHelper
        .instance.database; // Veritabanı bağlantısını bekleyin
    final result = await db.query('food');
    setState(() {
      _allFoodItems = result;
      _filteredFoodItems = result;
    });
  }

  // Loads diseases from the database and updates states
  Future<void> _loadDiseases() async {
    final db = await DatabaseHelper
        .instance.database; // Veritabanı bağlantısını bekleyin
    final result = await db.query('diseases');
    setState(() {
      diseases = result;
    });
  }

  // Loads restricted foods from the database and updates states
  Future<void> _loadRestrictedFoods() async {
    final db = await DatabaseHelper
        .instance.database; // Veritabanı bağlantısını bekleyin
    restrictedFoods.clear();

    for (var diseaseId in selectedDiseaseIds) {
      final result = await db.query(
        'disease_restricted_foods',
        where: 'disease_id = ?',
        whereArgs: [diseaseId],
      );
      restrictedFoods
          .addAll(result.map((item) => item['food_name'] as String).toList());
    }

    setState(() {
      _applyFilters();
    });
  }

  // Applies category and restricted food filters to the food items list
  void _applyFilters() {
    setState(() {
      _filteredFoodItems = _allFoodItems.where((item) {
        final isInCategory =
            selectedCategory.isEmpty || item['category'] == selectedCategory;
        final isNotRestricted = !restrictedFoods.contains(item['name']);
        return isInCategory && isNotRestricted;
      }).toList();
    });
  }

  // Filters food items based on the search query and updates state
  void _filterFoodItems(String query) {
    final lowerCaseQuery = query.toLowerCase();

    setState(() {
      _filteredFoodItems = _allFoodItems.where((item) {
        final isInCategory =
            selectedCategory.isEmpty || item['category'] == selectedCategory;
        final isNotRestricted = !restrictedFoods.contains(item['name']);
        final matchesQuery =
            (item['name'] as String?)?.toLowerCase().contains(lowerCaseQuery) ??
                false;
        return isInCategory && isNotRestricted && matchesQuery;
      }).toList();
    });
  }

  // Updates the category filter and applies filters
  void _updateCategoryFilter(String category) {
    setState(() {
      selectedCategory = category;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth =
        FirebaseAuth.instance; // FirebaseAuth instance to manage authentication
    final User? user = auth.currentUser; // Current logged-in user
    final String? uid = user?.uid; // User ID of the current logged-in user

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => uid == 'OP1vNwQeqValaF5kwarne35SZSW2'
              ? goToDietHomePage()
              : goToHomePage(),
        ),
        title: const Text('Food Search!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar for filtering food items by name
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search for Food...',
                border: OutlineInputBorder(),
              ),
              onChanged: _filterFoodItems,
            ),
            const SizedBox(height: 20),
            // Buttons for category and disease filtering
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isBreakfastSelected = !isBreakfastSelected;
                      if (isBreakfastSelected) {
                        isLunchDinnerSelected = false;
                        _updateCategoryFilter('Breakfast');
                      } else {
                        selectedCategory = '';
                        _applyFilters();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isBreakfastSelected ? Colors.blue : Colors.grey,
                  ),
                  child: Text(
                    'Breakfast',
                    style: TextStyle(
                      color: isBreakfastSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLunchDinnerSelected = !isLunchDinnerSelected;
                      if (isLunchDinnerSelected) {
                        isBreakfastSelected = false;
                        _updateCategoryFilter('Lunch/Dinner');
                      } else {
                        selectedCategory = '';
                        _applyFilters();
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isLunchDinnerSelected ? Colors.blue : Colors.grey,
                  ),
                  child: Text(
                    'Lunch/Dinner',
                    style: TextStyle(
                      color:
                          isLunchDinnerSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Select Diseases'),
                        content: SizedBox(
                          width: double.minPositive,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: diseases.length,
                            itemBuilder: (context, index) {
                              final disease = diseases[index];
                              final isSelected =
                                  selectedDiseaseIds.contains(disease['id']);
                              return CheckboxListTile(
                                title: Text(disease['name']),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedDiseaseIds.add(disease['id']);
                                    } else {
                                      selectedDiseaseIds.remove(disease['id']);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _loadRestrictedFoods(); // Loads restricted foods based on selected diseases
                            },
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDiseaseIds.isNotEmpty
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  child: const Text('Disease'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // List of filtered food items
            Expanded(
              child: ListView.builder(
                itemCount: _filteredFoodItems.length,
                itemBuilder: (context, index) {
                  final foodItem = _filteredFoodItems[index];
                  return ListTile(
                    title: Text(foodItem['name'] ?? 'No Name'),
                    subtitle: Text(foodItem['ingredients'] ?? 'No Ingredients'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
