import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Creating a new DatabaseHelper class to use and manipulate to data
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // we are getting connection of database
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('food_database.db');
    return _database!;
  }

  // Starting function of database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Opens the database
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Invokes database while it's being created
  Future<void> _createDB(Database db, int version) async {
    // Table of foods
    await db.execute('''CREATE TABLE food (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      category TEXT,
      ingredients TEXT
    )''');

    // Table of diseases
    await db.execute('''CREATE TABLE diseases (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )''');

    // Table of disease restrictions
    await db.execute('''CREATE TABLE disease_restrictions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      disease_id INTEGER,
      restricted_food_id INTEGER,
      FOREIGN KEY (disease_id) REFERENCES diseases (id),
      FOREIGN KEY (restricted_food_id) REFERENCES food (id)
    )''');

    // Table of disease restricted foods
    await db.execute('''CREATE TABLE disease_restricted_foods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      disease_id INTEGER NOT NULL,
      food_name TEXT NOT NULL,
      FOREIGN KEY (disease_id) REFERENCES diseases (id)
    )''');

    // Adding sample data
    await _insertSampleData(db);
  }

  // Database upgrade function
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add food_id column to disease_restricted_foods
      await db.execute('''ALTER TABLE disease_restricted_foods 
        ADD COLUMN food_id INTEGER NOT NULL;''');

      // Write out the food_id for each food_name
      final List<Map<String, dynamic>> result = await db
          .rawQuery('''SELECT id, food_name FROM disease_restricted_foods;''');

      // Update the food_id for each food_name
      for (var row in result) {
        final foodName = row['food_name'];
        final foodId = await _getFoodIdByName(db, foodName);

        // If the food_id is found, update the row
        if (foodId != -1) {
          await db.rawUpdate('''UPDATE disease_restricted_foods
            SET food_id = ? 
            WHERE id = ?;''', [foodId, row['id']]);
        }
      }

      // Drop the food_name column
      await db.execute('''CREATE TABLE temp_disease_restricted_foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        disease_id INTEGER NOT NULL,
        food_id INTEGER NOT NULL,
        FOREIGN KEY (disease_id) REFERENCES diseases (id),
        FOREIGN KEY (food_id) REFERENCES food (id)
      );''');

      // Copy the data to the new table
      await db.rawInsert(
          '''INSERT INTO temp_disease_restricted_foods (id, disease_id, food_id)
        SELECT id, disease_id, food_id FROM disease_restricted_foods;''');

      // Drop the old table and rename the new table
      await db.execute('''DROP TABLE disease_restricted_foods;''');
      await db.execute(
          '''ALTER TABLE temp_disease_restricted_foods RENAME TO disease_restricted_foods;''');
    }
  }

  // Example data
  Future<void> _insertSampleData(Database db) async {
    await db.insert('food', {
      'name': 'Scrambled Eggs',
      'category': 'Breakfast',
      'ingredients': '2 eggs, Butter, Salt',
    });
    await db.insert('food', {
      'name': 'Egg Salad',
      'category': 'Breakfast',
      'ingredients':
          '6 eggs, Half a bunch of parsley, 1 handful of dill, Juice of half a lemon, 3–4 tablespoons olive oil, 1 teaspoon thyme, 1 teaspoon red pepper flakes, ½ teaspoon black pepper, Salt',
    });
    await db.insert('food', {
      'name': 'Oats with Yoghurt',
      'category': 'Breakfast',
      'ingredients':
          '½ cup oats, 1 cup yoghurt, 1 tablespoon honey (optional), Fresh fruit (e.g., banana, berries), Nuts or seeds (optional)',
    });
    await db.insert('food', {
      'name': 'Menemen',
      'category': 'Breakfast',
      'ingredients':
          '2 eggs, 2 medium tomatoes, diced, 1 green pepper, chopped, 1 tablespoon olive oil or butter, Salt, Black pepper',
    });
    await db.insert('food', {
      'name': 'Boiled Potatoes',
      'category': 'Breakfast',
      'ingredients':
          '4 medium potatoes, Water, Salt, Optional: Butter, herbs, or seasonings',
    });
    // Lunch/Dinner verileri
    await db.insert('food', {
      'name': 'Red Lentil Soup',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup red lentils, 1 onion, finely chopped, 1 carrot, diced, 1 tablespoon olive oil or butter, 5 cups water or vegetable stock, 1 teaspoon paprika, ½ teaspoon cumin, Salt and black pepper, Optional: Lemon wedges for serving',
    });
    await db.insert('food', {
      'name': 'Broccoli Soup',
      'category': 'Lunch/Dinner',
      'ingredients':
          '2 cups broccoli florets, 1 small onion, chopped, 1 medium potato, peeled and diced, 2 cups vegetable stock or water, 1 tablespoon olive oil or butter, ½ cup milk or cream (optional), Salt and black pepper',
    });
    await db.insert('food', {
      'name': 'Tomato Soup',
      'category': 'Lunch/Dinner',
      'ingredients':
          '4 medium tomatoes, chopped, 1 small onion, chopped, 1 clove garlic, minced, 1 tablespoon olive oil or butter, 2 cups vegetable stock or water, ½ teaspoon sugar (optional, to balance acidity), Salt and black pepper, Optional: 2 tablespoons cream or milk',
    });
    await db.insert('food', {
      'name': 'Chicken Soup',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 chicken breast or 2 chicken thighs, 1 small onion, chopped, 1 carrot, sliced, 1 stalk celery, chopped, 4 cups water or chicken stock, Salt and black pepper, Optional: Fresh parsley for garnish',
    });
    await db.insert('food', {
      'name': 'Creamy Mushroom Soup',
      'category': 'Lunch/Dinner',
      'ingredients':
          '2 cups mushrooms, sliced, 1 small onion, chopped, 1 tablespoon butter or olive oil, 2 cups vegetable or chicken stock, 1 cup milk or cream, 1 tablespoon flour (optional, for thickening), Salt and black pepper'
    });
    await db.insert('food', {
      'name': 'Yogurt Soup',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup yogurt, 1 tablespoon flour, 1 egg, 1 clove garlic, minced, 1 tablespoon butter, 4 cups water or chicken stock, Salt and black pepper, Optional: Fresh mint or dill for garnish'
    });
    await db.insert('food', {
      'name': 'Roasted Chicken',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 whole chicken, 1 lemon, 1 onion, 1 carrot, 1 potato, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Ratatouille',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 eggplant, 1 zucchini, 1 bell pepper, 2 tomatoes, 1 onion, 2 cloves garlic, 2 tablespoons olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Chicken Sauté',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 chicken breast, 1 bell pepper, 1 onion, 1 clove garlic, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Stuffed Peppers',
      'category': 'Lunch/Dinner',
      'ingredients':
          '4 bell peppers, 1 cup rice, 1 onion, 1 clove garlic, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Turkish Bean Stew',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup white beans, 1 onion, 1 carrot, 1 potato, 1 tablespoon tomato paste, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Steak',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 steak, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Roasted Fish',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 fish fillet, 1 lemon, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Steamed Vegetables',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup mixed vegetables, 1 tablespoon olive oil, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Turkish Dumplings',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup flour, 1 egg, 1 tablespoon olive oil, Salt and black pepper, Optional: Yogurt or garlic yogurt sauce'
    });
    await db.insert('food', {
      'name': 'Vegetable Gratin',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 zucchini, 1 eggplant, 1 bell pepper, 2 tomatoes, 1 onion, 2 cloves garlic, 1 cup milk or cream, 1 tablespoon flour, 1 tablespoon butter, Salt and black pepper, Optional: Cheese for topping'
    });
    await db.insert('food', {
      'name': 'Pilaf',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup rice, 1 onion, 1 carrot, 1 tablespoon butter, 2 cups water or chicken stock, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Bulgur Pilaf',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup bulgur, 1 onion, 1 bell pepper, 1 tomato, 1 tablespoon olive oil, 2 cups water or vegetable stock, Salt and black pepper, Optional: Herbs or seasonings'
    });
    await db.insert('food', {
      'name': 'Salad',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cucumber, 1 tomato, 1 bell pepper, 1 onion, 1 tablespoon olive oil, Salt and black pepper, Optional: Lemon juice or vinegar'
    });
    await db.insert('food', {
      'name': 'Pasta',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup pasta, 1 tablespoon olive oil, Salt and black pepper, Optional: Tomato sauce or cheese'
    });
    await db.insert('food', {
      'name': 'Falafel',
      'category': 'Lunch/Dinner',
      'ingredients':
          '1 cup chickpeas, 1 onion, 1 clove garlic, 1 tablespoon flour, 1 teaspoon cumin, 1 teaspoon coriander, Salt and black pepper, Optional: Tahini sauce or yogurt sauce'
    });
    await db.insert('food', {
      'name': 'Zucchini Hash Browns',
      'category': 'Lunch/Dinner',
      'ingredients':
          '2 zucchinis, 1 onion, 1 egg, 1 tablespoon flour, Salt and black pepper, Optional: Yogurt or garlic yogurt sauce'
    });

    // Example diseases table data
    await db.insert('diseases', {'name': 'Celiac'});
    await db.insert('diseases', {'name': 'Diabetes'});
    await db.insert('diseases', {'name': 'Obesity'});
    await db.insert('diseases', {'name': 'Pregnancy'});

    // Example disease restrictions table data
    await db.insert('disease_restricted_foods',
        {'disease_id': 1, 'food_name': 'Menemen'}); // Celiac - Menemen
    await db.insert('disease_restricted_foods', {
      'disease_id': 2,
      'food_name': 'Scrambled Eggs'
    }); // Diabetes - Scrambled Eggs
    await db.insert('disease_restricted_foods',
        {'disease_id': 3, 'food_name': 'Egg Salad'}); // Obesity - Egg Salad
    await db.insert('disease_restricted_foods', {
      'disease_id': 4,
      'food_name': 'Scrambled Eggs'
    }); // Pregnancy - Scrambled Eggs
  }

  // Checking the validity of the database connection
  Future<void> checkDatabaseConnection() async {
    var db = await database;
    if (db == Null) {
      print("Veritabanı bağlantısı başarısız!");
    } else {
      print("Veritabanı bağlantısı başarılı!");
    }
  }

  // Deleting Database
  Future<void> deleteDatabaseFile() async {
    final db = await instance.database;
    _database = null;
    String path = await getDatabasesPath();
    await db.close();
    deleteDatabase(path);
  }

  // To take food that is prohibited from getting sick
  Future<List<Map<String, dynamic>>> getFoodByRestrictions(
      List<int> diseaseIds) async {
    final db = await instance.database;

    // If there is no disease, return all foods
    if (diseaseIds.isEmpty) {
      return await db.query('food');
    }

    // Get the food ids that are restricted for the given diseases
    final restrictedIds = await db.rawQuery(
        '''SELECT DISTINCT food_id FROM disease_restricted_foods
      WHERE disease_id IN (${List.generate(diseaseIds.length, (index) => '?').join(', ')})''',
        diseaseIds);

    // Get the food data for the restricted ids
    final idsToExclude = restrictedIds.map((e) => e['food_id']).toList();

    // If there are no restricted foods, return all foods
    if (idsToExclude.isEmpty) {
      return await db.query('food');
    }

    // Return the foods that are not restricted
    return await db.query(
      'food',
      where:
          'id NOT IN (${List.generate(idsToExclude.length, (index) => '?').join(', ')})',
      whereArgs: idsToExclude,
    );
  }

  // Helper function to get food_id by food_name
  Future<int> _getFoodIdByName(Database db, String foodName) async {
    final result = await db
        .rawQuery('''SELECT id FROM food WHERE name = ? LIMIT 1''', [foodName]);

    if (result.isNotEmpty) {
      return result.first['id'] as int; // Returns Id(String) to Integer
    } else {
      return -1; // If result is empty it returns -1
    }
  }
}
