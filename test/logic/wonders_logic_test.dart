import 'package:flutter_test/flutter_test.dart';
import 'package:wonders/logic/data/wonder_type.dart';
import 'package:wonders/logic/wonders_logic.dart';

void main() {
  group('WondersLogic', () {
    late WondersLogic logic;

    setUp(() {
      logic = WondersLogic();
      logic.init();
    });

    test('init() populates all with 8 wonders', () {
      expect(logic.all.length, 8);
    });

    test('all wonders have distinct types', () {
      final types = logic.all.map((w) => w.type).toSet();
      expect(types.length, 8);
    });

    test('getData() returns the correct wonder for each type', () {
      for (final type in WonderType.values) {
        final data = logic.getData(type);
        expect(data.type, type);
      }
    });

    test('getData() throws when called before init()', () {
      final uninitialised = WondersLogic();
      expect(() => uninitialised.getData(WonderType.colosseum), throwsA(anything));
    });

    test('timelineStartYear and timelineEndYear are sane', () {
      expect(logic.timelineStartYear, lessThan(0));
      expect(logic.timelineEndYear, greaterThan(2000));
    });
  });
}
