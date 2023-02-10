import 'package:top_dash/app/app.dart';
import 'package:top_dash/bootstrap.dart';
import 'package:top_dash/firebase_options_development.dart';

void main() {
  bootstrap(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
    builder: () => const App(),
  );
}
