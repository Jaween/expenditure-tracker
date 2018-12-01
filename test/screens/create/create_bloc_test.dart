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

    test("constructior with initial expenditure should stream values", () {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();
      final initialExpenditure = _createFakeExpenditure();

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

  group("CreateBloc editing form", () {
    test("without initial expenditure should update streams", () {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();

      final bloc = CreateBloc(mockNavigationRouter, mockRepository,
        mockLocation, mockClock, null);

      bloc.actionCategorySelect.add(categoryNameIconList[1].item1);
      expect(bloc.categoryStream, emitsThrough(categoryNameIconList[1].item1));

      bloc.actionDateUpdate.add(DateTime(2019, 12, 20));
      expect(bloc.dateStream, emitsThrough(DateTime(2019, 12, 20)));

      bloc.actionDescriptionUpdate.add("My item description");
      expect(bloc.descriptionStream, emitsThrough("My item description"));

      bloc.actionLocationUpdate.add("Dreamland");
      expect(bloc.locationStream, emitsThrough("Dreamland"));

      bloc.actionAmountUpdate.add("13.5");
      expect(bloc.amountStream, emitsThrough("13.5"));

      bloc.actionCategorySelect.add(CreateBloc.currencies[2]);
      expect(bloc.categoryStream, emitsThrough(CreateBloc.currencies[2]));
    });

    test("with initial expenditure should update streams", () {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();
      final initialExpenditure = _createFakeExpenditure();

      final bloc = CreateBloc(mockNavigationRouter, mockRepository,
        mockLocation, mockClock, initialExpenditure);

      bloc.actionCategorySelect.add(categoryNameIconList[1].item1);
      expect(bloc.categoryStream, emitsThrough(categoryNameIconList[1].item1));

      bloc.actionDateUpdate.add(DateTime(2019, 12, 20));
      expect(bloc.dateStream, emitsThrough(DateTime(2019, 12, 20)));

      bloc.actionDescriptionUpdate.add("My item description");
      expect(bloc.descriptionStream, emitsThrough("My item description"));

      bloc.actionLocationUpdate.add("Dreamland");
      expect(bloc.locationStream, emitsThrough("Dreamland"));

      bloc.actionAmountUpdate.add("13.5");
      expect(bloc.amountStream, emitsThrough("13.5"));

      bloc.actionCategorySelect.add(CreateBloc.currencies[2]);
      expect(bloc.categoryStream, emitsThrough(CreateBloc.currencies[2]));
    });
  });

  group("CreateBloc saving form", () {
    test("without initial expenditure should create new entry", () async {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();

      final bloc = CreateBloc(mockNavigationRouter, mockRepository,
        mockLocation, mockClock, null);
      bloc.actionCategorySelect.add(categoryNameIconList[3].item1);
      bloc.actionDateUpdate.add(DateTime(2018, 7, 6));
      bloc.actionDescriptionUpdate.add("Teriyaki chicken roll");
      bloc.actionLocationUpdate.add("Aka Sushi");
      bloc.actionAmountUpdate.add("2.5");
      bloc.actionCurrencyUpdate.add(CreateBloc.currencies[0]);
      bloc.actionSave.add(null);

      final expected = Expenditure(
        categoryNameIconList[3].item1,
        "Teriyaki chicken roll",
        DateTime(2018, 7, 6),
        "Aka Sushi",
        "2.5",
        CreateBloc.currencies[0]
      );

      await untilCalled(mockRepository.createExpenditure(any)).then((_) {
        verify(mockRepository.createExpenditure(expected)).called(1);
        verifyNever(mockRepository.updateExpenditure(any));
      });
    });

    test("with initial expenditure should update entry", () async {
      final mockNavigationRouter = MockNavigationRouter();
      final mockRepository = MockRepository();
      final mockLocation = MockLocation();
      final mockClock = MockClock();
      final initialExpenditure = _createFakeExpenditure();

      final bloc = CreateBloc(mockNavigationRouter, mockRepository,
        mockLocation, mockClock, initialExpenditure);
      bloc.actionDescriptionUpdate.add("Wonderful new expenditure");
      bloc.actionSave.add(null);

      final expected = Expenditure(
        categoryNameIconList[2].item1,
        "Wonderful new expenditure",
        DateTime(2018, 03, 14, 12, 34, 0),
        "Fancy restaurant",
        "20",
        "AUD",
        "SomeId123",
      );
      await untilCalled(mockRepository.updateExpenditure(any)).then((_) {
        verify(mockRepository.updateExpenditure(expected)).called(1);
        verifyNever(mockRepository.createExpenditure(any));
      });
    });
  });
}

Expenditure _createFakeExpenditure() => Expenditure(
  categoryNameIconList[2].item1,
  "Great expenditure",
  DateTime(2018, 03, 14, 12, 34, 0),
  "Fancy restaurant",
  "20",
  "AUD",
  "SomeId123",
);

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