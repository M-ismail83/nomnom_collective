import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  factory DatabaseHelper() => instance;

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('patients.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database of any patients
  Future _createDB(Database db, int version) async {
    await db.execute('''CREATE TABLE PATIENTS (
      PATIENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      UID TEXT UNIQUE NOT NULL,
      PATIENT_NAME TEXT NOT NULL,
      PATIENT_SURNAME TEXT NOT NULL,
      AGE INTEGER NOT NULL
    )''');

    // Create the database of any diseases
    await db.execute('''CREATE TABLE DISEASES (
      DISEASE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
      DISEASE_NAME TEXT NOT NULL
    )''');

    // Create patient_disease table to map patients to diseases
    await db.execute('''CREATE TABLE PATIENT_DISEASE (
     ID INTEGER PRIMARY KEY AUTOINCREMENT,
     PATIENT_ID INTEGER NOT NULL,
     DISEASE_ID INTEGER NOT NULL,
     FOREIGN KEY (PATIENT_ID) REFERENCES PATIENTS (PATIENT_ID) ON DELETE CASCADE,
     FOREIGN KEY (DISEASE_ID) REFERENCES DISEASES (DISEASE_ID) ON DELETE CASCADE
    )''');

    // Prepopulate diseases table

    await db.insert('DISEASES', {'DISEASE_NAME': 'Celiac'});
    await db.insert('DISEASES', {'DISEASE_NAME': 'Pregnant'});
    await db.insert('DISEASES', {'DISEASE_NAME': 'Obese'});
    await db.insert('DISEASES', {'DISEASE_NAME': 'Diabetes'});

    // Prepopulate patients table

    await db.insert('PATIENTS', {
      'UID': 'CYqRu5jNsiUwWMZlmZDslowec6i1',
      'PATIENT_NAME': 'Aslı',
      'PATIENT_SURNAME': 'Güngören',
      'AGE': 23,
    });

    await db.insert('PATIENTS', {
      'UID': 'dgsiLDray0cBQS7cqqo3gzRS2Cm2',
      'PATIENT_NAME': 'Burcu',
      'PATIENT_SURNAME': 'Çakıltaş',
      'AGE': 38,
    });

    await db.insert('PATIENTS', {
      'UID': 'ZBSVuCteM2NHWyF0ZtgkbOZO9J22',
      'PATIENT_NAME': 'Cengiz',
      'PATIENT_SURNAME': 'Türker',
      'AGE': 52,
    });

    await db.insert('PATIENTS', {
      'UID': '0HSMXYfHqdSbZqCZbxkpHS1a0TI3',
      'PATIENT_NAME': 'Mahmut',
      'PATIENT_SURNAME': 'Çiftbakır',
      'AGE': 73,
    });

    // Prepopulate patient_disease table

    await db.insert('PATIENT_DISEASE', {
      'PATIENT_ID': 1, // Aslı Güngören
      'DISEASE_ID': 1, // Celiac
    });

    await db.insert('PATIENT_DISEASE', {
      'PATIENT_ID': 2, // Burcu Çakıltaş
      'DISEASE_ID': 2, // Pregnant
    });

    await db.insert('PATIENT_DISEASE', {
      'PATIENT_ID': 3, // Cengiz Türker
      'DISEASE_ID': 3, // Obese
    });

    await db.insert('PATIENT_DISEASE', {
      'PATIENT_ID': 4, // Mahmut Çiftbakır
      'DISEASE_ID': 4, // Diabetic
    });
  }

  // Fetch all information about a patient by UID
  Future<Map<String, dynamic>> getPatientByUID(String uid) async {
    final db = await database;

    // Fetch the patient details
    final patientResult = await db.query(
      'PATIENTS',
      where: 'UID = ?',
      whereArgs: [uid],
    );

    if (patientResult.isEmpty) {
      throw Exception('Patient with UID $uid is not found');
    }

    // Extract the patient information

    final patient = patientResult.first;

    // Fetch the diseases associated with the patient

    final diseaseResult = await db.rawQuery('''
      SELECT d.DISEASE_NAME
      FROM DISEASES d
      INNER JOIN PATIENT_DISEASE pd ON d.DISEASE_ID = pd.DISEASE_ID
      WHERE pd.PATIENT_ID = ?
    ''', [patient['PATIENT_ID']]);

    // Return the combined data
    return {
      'UID': patient['UID'],
      'PATIENT_NAME': patient['PATIENT_NAME'],
      'PATIENT_SURNAME': patient['PATIENT_SURNAME'],
      'AGE': patient['AGE'],
      'DISEASES': diseaseResult.map((row) => row['DISEASE_NAME']).toList(),
    };
  }

  // Adding a new patient to the database
  Future<void> addPatient({
    required String uid,
    required String name,
    required String surname,
    required int age,
  }) async {
    final db = await database;

    await db.insert(
      'PATIENTS',
      {
        'UID': uid,
        'PATIENT_NAME': name,
        'PATIENT_SURNAME': surname,
        'AGE': age,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a patient by UID
  Future<void> deletePatientByUID(String uid) async {
    final db = await database;

    final rowsDeleted = await db.delete(
      'PATIENTS',
      where: 'UID = ?',
      whereArgs: [uid],
    );

    if (rowsDeleted == 0) {
      throw Exception('Patient with UID $uid not found.');
    }
  }
}
