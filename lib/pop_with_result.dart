import 'package:meta/meta.dart';

class PopWithResults<T> {
  final String fromPage;
  final String toPage;
  final Map<String, T> results;

  PopWithResults(
      {@required this.fromPage, @required this.toPage, this.results});
}
