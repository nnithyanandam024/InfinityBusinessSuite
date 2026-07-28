import 'package:flutter_test/flutter_test.dart';
import 'package:ibs_mobile/main.dart';

void main() {
  testWidgets('App renders test', (WidgetTester tester) async {
    await tester.pumpWidget(const InfinityBusinessSuiteApp());
    expect(find.text('Infinity Business Suite'), findsNothing);
  });
}
