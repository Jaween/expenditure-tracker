import 'package:expenditure_tracker/interface/expenditure.dart';
import 'package:expenditure_tracker/interface/location.dart';
import 'package:expenditure_tracker/interface/navigation_router.dart';
import 'package:expenditure_tracker/interface/repository.dart';
import 'package:expenditure_tracker/screens/create/create_bloc.dart';
import 'package:expenditure_tracker/util/category_icons.dart';
import 'package:mockito/mockito.dart';
import 'package:quiver/time.dart';
import 'package:test/test.dart';

void main() {
  group("CreateBloc initialization", () {
    test("constructor without initial expenditure should stream defaults", () {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();

      final bloc = CreateBloc(mockNavigationRouter, mockRepository,
          mockLocation, mockClock, null);

      final categoryNamesList = categoryNameIconList.map((pair) => pair.item1);
      expect(bloc.expenditureId, isNull);
      expect(bloc.categoryStream, emitsAnyOf(categoryNamesList));
      expect(bloc.descriptionStream, emits(isEmpty));
      expect(bloc.dateStream, emits(mockClock.now()));
      expect(bloc.formattedDateStream, emits("Dec 1, 2018"));
      expect(bloc.locationStream, emitsInOrder(["", "Pizza Parlor"]));
      expect(bloc.amountStream, emits(isEmpty));
      expect(bloc.currencyStream, emitsAnyOf(CreateBloc.currencies));
    });

    test("constructior with initial expenditure should stream it", () {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();
      final initialExpenditure = Expenditure(
        categoryNameIconList[2].item1,
        "Useful expenditure",
        DateTime(2018, 03, 14, 12, 34, 0),
        "Fancy restaurant",
        "20",
        "AUD",
        "SomeId123",
      );

      final bloc = CreateBloc(mockNavigationRouter, mockRepository,
          mockLocation, mockClock, initialExpenditure);

      expect(bloc.expenditureId, equals(initialExpenditure.id));
      expect(bloc.categoryStream, emits(initialExpenditure.category));
      expect(bloc.descriptionStream, emits(initialExpenditure.description));
      expect(bloc.dateStream, emits(initialExpenditure.date));
      expect(bloc.formattedDateStream, emits("Mar 14, 2018"));
      expect(bloc.locationStream, emits(initialExpenditure.locationName));
      expect(bloc.amountStream, emits(initialExpenditure.amount));
      expect(bloc.currencyStream, emits(initialExpenditure.currency));
    });
  });
}

class MockNavigationRouter extends Mock implements NavigationRouter {}

class MockRepository extends Mock implements Repository {}

class MockLocation extends Mock implements Location {
  Future<String> getCurrentPlaceName() async {
    return "Pizza Parlor";
  }
}

class MockClock extends Mock implements Clock {
  DateTime now() {
    return DateTime(2018, 12, 1, 15, 19, 0);
  }
}