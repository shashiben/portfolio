part of 'journey_screen.dart';

class JourneyScreenViewModel extends BaseViewModel {
  /// Current role first, then multi-role companies, then the rest in data order.
  List<Company> get companies => [
    ...experienceList.where((c) => c.isCurrent),
    ...experienceList.where((c) => !c.isCurrent && c.subEntries.isNotEmpty),
    ...experienceList.where((c) => !c.isCurrent && c.subEntries.isEmpty),
  ];
}
