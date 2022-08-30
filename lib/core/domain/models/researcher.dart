import 'package:reach_core/core/core.dart';

class Researcher extends BaseModel<Researcher> {
  Researcher(Map<String, dynamic> json) : super(json);

  String get name => data['name'];
  String get organization => data['organization'];
  String get bio => data['bio'];
  String get researcherId => data['researcherId'];
  String get imageUrl => data['imageUrl'];
  int get defaultColor => data['defaultColor'];
  String get city => data['city'];
  int get numberOfResearches => data['numberOfResearches'];
  List<dynamic> get currentResearchsIds => data['currentResearchsIds'];

  @override
  Researcher copyWith(Map<String, dynamic> newData) => Researcher(
      {...data, ...newData..removeWhere((key, value) => value == null)});

  toPartialMap() {
    return {
      'name': name,
      'researcherId': researcherId,
      'imageUrl': imageUrl,
      'defaultColor': defaultColor,
    };
  }

  void addResearch(String researchId) => currentResearchsIds.add(researchId);

  factory Researcher.empty() => Researcher({
        'name': '',
        'bio': '',
        'city': '',
        'currentResearchsIds': const [],
        'defaultColor': ColorGenerator.getRandomColor().value,
        'imageUrl': '',
        'numberOfResearches': 0,
        'organization': '',
        'researcherId': ''
      });

  @override
  List<Object> get props => [toMap()];

  Researcher get partial => Researcher(toPartialMap());
}
