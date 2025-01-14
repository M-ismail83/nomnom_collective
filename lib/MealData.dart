// This class contains static maps for storing meal and patient information.
class MealData {
  // A map that stores the meal plan for each patient.
  // Key: Patient's name, Value: List of meals (Strings) for the day.
  static Map<String, List<String>> patientMealMap = {
    'Aslı': [
      'Scrambled Eggs',
      'Fruit Salad',
      'Tomato Soup',
      'Granola Bar',
      'Pilaf',
      'Yogurt with Berries'
    ],
    'Burcu': [
      'Egg Salad',
      'Fruit Salad',
      'Creamy Mushroom Soup',
      'Granola Bar',
      'Steak',
      'Yogurt with Berries'
    ],
    'Cengiz': [
      'Oats with Yoghurt',
      'Fruit Salad',
      'Red Lentil Soup',
      'Granola Bar',
      'Roasted Fish',
      'Yogurt with Berries'
    ],
    'Mahmut': [
      'Menemen',
      'Fruit Salad',
      'Chicken Sauté',
      'Granola Bar',
      'Ratatouille',
      'Yogurt with Berries'
    ],
  };

  // A map that stores past meals for each patient.
  // Key: Patient's name, Value: List of lists, where each list contains a set of meals for a day.
  static Map<String, List<List<String>>> patientPastMealMap = {
    'Aslı': [
      [
        'Egg Salad',
        'Fruit Salad',
        'Ratatouille',
        'Smoothie',
        'Tomato Soup',
        'Coffee'
      ],
      [
        'Menemen',
        'Sorbet',
        'Stuffed Peppers',
        'Fruit Salad',
        'Chicken Saute',
        'Mini Carrots'
      ]
    ],
    'Burcu': [
      [
        'Omlette',
        'Dates + Walnuts',
        'Tomato Soup',
        'Smoothie',
        'Turkish Dumplings',
        'Mini Carrots'
      ],
      [
        'Menemen',
        'Sorbet',
        'Yogurt Soup',
        'Fruit Salad',
        'Roasted Chicken',
        'Mixed Nuts'
      ]
    ],
    'Cengiz': [
      [
        'Menemen',
        'Dates + Walnuts',
        'Tomato Soup',
        'Smoothie',
        'Ratatouille',
        'Mini Carroots'
      ],
      [
        'Egg Salad',
        'Dates + Walnuts',
        'Yogurt Soup',
        'Fruid Salad',
        'Roasted Chicken',
        'Mixed Nuts'
      ]
    ],
    'Mahmut': [
      [
        'Omlette',
        'Mini Carrots',
        'Tomato Soup',
        'Hummus + Wasa',
        'Ratatouille',
        'Tea + Grissini'
      ],
      [
        'Menemen',
        'Mixed Nuts + Dried Fruits',
        'Chicken Soup',
        'Mini Carrots',
        'Turkish Bean Stew',
        'Hummus + Wasa'
      ]
    ],
  };

  // A map that stores the dates of the past meals for each patient.
  // Key: Patient's name, Value: List of meal dates (Strings) for each corresponding past meal.
  static Map<String, List<String>> patientPastMealDateMap = {
    'Aslı': ['07.11.2024', '14.07.2024'],
    'Burcu': ['06.11.2024', '25.09.2024'],
    'Cengiz': ['05.12.2024', '22.08.2024'],
    'Mahmut': ['30.11.2024', '18.06.2024']
  };

  // A map that stores general information for each patient.
  // Key: Patient's name, Value: List containing email, age, and disease (String).
  static Map<String, List<String>> patientInfo = {
    'Aslı': ['asligngrn56@hotmail.com', '23', 'Celiac'],
    'Cengiz': ['cngzturker26@hotmail.com', '52', 'Obese'],
    'Burcu': ['burcuckltas45@hotmail.com', '38', 'Pregnant'],
    'Mahmut': ['mahmutcftbkr86@hotmail.com', '73', 'Diabetic']
  };
}
