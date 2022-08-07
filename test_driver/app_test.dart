import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Testing App', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    test(
        'should display search movie when query typed, add watchlist, and remove watchlist',
        () async {
      final searchIcon = find.byValueKey('search_icon');
      final textField = find.byValueKey('query_input');

      await driver.tap(searchIcon);
      await Future.delayed(Duration(seconds: 2));

      await driver.tap(textField);
      await Future.delayed(Duration(seconds: 2));

      await driver.enterText('Venom');
      await Future.delayed(Duration(seconds: 2));
    });

    tearDownAll(() async {
      await driver.close();
    });
  });
}
