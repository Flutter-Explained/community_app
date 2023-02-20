import 'package:community_app/app/app.dart';
import 'package:community_app/bootstrap.dart';

void main() {
  bootstrap(() => const App(), Environment.prod);
}
