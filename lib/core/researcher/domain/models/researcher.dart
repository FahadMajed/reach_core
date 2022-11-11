import 'package:reach_core/core/core.dart';

class Researcher extends Equatable {
  final String name;
  final String organization;
  final String bio;
  final String researcherId;
  final String imageUrl;
  final int defaultColor;
  final String city;
  final int numberOfResearches;
  final List<dynamic> currentResearchsIds;

  const Researcher({
    required this.name,
    required this.organization,
    required this.bio,
    required this.researcherId,
    required this.imageUrl,
    required this.defaultColor,
    required this.city,
    required this.numberOfResearches,
    required this.currentResearchsIds,
  });

  void addResearch(String researchId) => currentResearchsIds.add(researchId);

  factory Researcher.empty() => Researcher(
      name: '',
      bio: '',
      city: '',
      currentResearchsIds: [],
      defaultColor: ColorGenerator.getRandomColor(),
      imageUrl: '',
      numberOfResearches: 0,
      organization: '',
      researcherId: '');

  Researcher copyWith({
    String? name,
    String? organization,
    String? bio,
    String? researcherId,
    String? imageUrl,
    int? defaultColor,
    String? city,
    int? numberOfResearches,
    List<dynamic>? currentResearchsIds,
  }) {
    return Researcher(
      name: name ?? this.name,
      organization: organization ?? this.organization,
      bio: bio ?? this.bio,
      researcherId: researcherId ?? this.researcherId,
      imageUrl: imageUrl ?? this.imageUrl,
      defaultColor: defaultColor ?? this.defaultColor,
      city: city ?? this.city,
      numberOfResearches: numberOfResearches ?? this.numberOfResearches,
      currentResearchsIds: currentResearchsIds ?? this.currentResearchsIds,
    );
  }

  @override
  List<Object?> get props => [
        name,
        numberOfResearches,
        currentResearchsIds,
        city,
        imageUrl,
        organization,
        bio,
      ];
}
