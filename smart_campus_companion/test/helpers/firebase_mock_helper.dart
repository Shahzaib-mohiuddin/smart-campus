import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

// A fake Firebase App
class MockFirebaseApp extends Fake implements FirebaseApp {
  MockFirebaseApp({this.name = '[DEFAULT]', this.isAutomaticDataCollectionEnabled = false});
  
  @override
  final String name;
  
  @override
  final bool isAutomaticDataCollectionEnabled;
  
  @override
  FirebaseOptions get options => const FirebaseOptions(
        appId: '1:1234567890:ios:1234567890abcdef',
        apiKey: 'test-api-key',
        projectId: 'test-project',
        messagingSenderId: '1234567890',
      );
}

// A fake Firebase App Platform
class MockFirebaseAppPlatform extends Fake implements FirebaseAppPlatform {
  MockFirebaseAppPlatform(this._app);
  
  final FirebaseApp _app;
  
  @override
  FirebaseApp get delegate => _app;
  
  @override
  Future<FirebaseAppPlatform> setAutomaticDataCollectionEnabled(bool enabled) async {
    return this;
  }
  
  @override
  Future<FirebaseAppPlatform> setAutomaticResourceManagementEnabled(bool enabled) async {
    return this;
  }
  
  @override
  Future<FirebaseAppPlatform> delete() async {
    return this;
  }
}

// Helper to setup Firebase for testing
void setupFirebaseMocks() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  // Setup mock Firebase app
  final fakeApp = MockFirebaseApp();
  final fakeAppPlatform = MockFirebaseAppPlatform(fakeApp);
  
  // Setup Firebase Core Mocks
  TestFirebaseFirestore.setup();
  
  // Setup Firebase App
  FirebaseAppPlatform.instanceDelegates = {
    fakeApp.name: fakeAppPlatform,
  };
}

// Helper to mock Firestore
class TestFirebaseFirestore {
  static void setup() {
    // This would be replaced with actual Firestore mocks if needed
  }
}
