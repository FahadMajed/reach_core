import 'package:flutter/foundation.dart';
import 'package:reach_core/core/core.dart';

class Researcher {
  final String name;
  final String organization;
  final String bio;
  final String researcherId;
  final String imageUrl;
  final int defaultColor;
  final String city;
  final int numberOfResearches;
  final List<dynamic> currentResearchsIds;

  Researcher(
      {required this.researcherId,
      required this.organization,
      required this.bio,
      required this.name,
      required this.defaultColor,
      required this.city,
      required this.currentResearchsIds,
      required this.numberOfResearches,
      required this.imageUrl});

  factory Researcher.fromFirestore(Map data) {
    return Researcher(
        researcherId: data['researcherId'],
        name: data["name"] ?? '',
        bio: data["bio"] ?? '',
        organization: data["organization"] ?? '',
        city: data["city"] ?? 'Riyadh',
        currentResearchsIds: data["currentResearchsIds"] ?? [],
        numberOfResearches: data["numberOfResearches"] ?? 0,
        defaultColor: data['defaultColor'] ?? 0xFF607BCA,
        imageUrl: data["imageUrl"] ?? '');
  }

  void addResearch(String researchId) => currentResearchsIds.add(researchId);

  Map<String, dynamic> toMap() {
    return {
      'organization': organization,
      'bio': bio,
      'name': name,
      'researcherId': researcherId,
      'currentResearchsIds': currentResearchsIds,
      'imageUrl': imageUrl,
      'defaultColor': defaultColor,
      'city': city,
      'numberOfResearches': numberOfResearches,
    };
  }

  toPartialMap() {
    return {
      'name': name,
      'organization': organization,
      'city': city,
      'bio': bio,
      'numberOfResearches': numberOfResearches,
      'researcherId': researcherId,
      'imageUrl': imageUrl,
      'defaultColor': defaultColor,
    };
  }

  Researcher copyWith({
    String? organization,
    String? bio,
    String? name,
    String? researcherId,
    String? imageUrl,
    int? defaultColor,
    String? city,
    int? numberOfResearches,
    List<dynamic>? currentResearchsIds,
  }) {
    return Researcher(
      organization: organization ?? this.organization,
      bio: bio ?? this.bio,
      name: name ?? this.name,
      researcherId: researcherId ?? this.researcherId,
      imageUrl: imageUrl ?? this.imageUrl,
      defaultColor: defaultColor ?? this.defaultColor,
      city: city ?? this.city,
      numberOfResearches: numberOfResearches ?? this.numberOfResearches,
      currentResearchsIds: currentResearchsIds ?? this.currentResearchsIds,
    );
  }

  factory Researcher.empty() => Researcher(
      name: '',
      bio: '',
      city: '',
      currentResearchsIds: [],
      defaultColor: ColorGenerator.getRandomColor().value,
      imageUrl: '',
      numberOfResearches: 0,
      organization: '',
      researcherId: '');

  @override
  String toString() {
    return 'Researcher(name: $name, organization: $organization, bio: $bio, researcherId: $researcherId, imageUrl: $imageUrl, defaultColor: $defaultColor, city: $city, numberOfResearches: $numberOfResearches, currentResearchsIds: $currentResearchsIds)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Researcher &&
        other.name == name &&
        other.organization == organization &&
        other.bio == bio &&
        other.researcherId == researcherId &&
        other.imageUrl == imageUrl &&
        other.defaultColor == defaultColor &&
        other.city == city &&
        other.numberOfResearches == numberOfResearches &&
        listEquals(other.currentResearchsIds, currentResearchsIds);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        organization.hashCode ^
        bio.hashCode ^
        researcherId.hashCode ^
        imageUrl.hashCode ^
        defaultColor.hashCode ^
        city.hashCode ^
        numberOfResearches.hashCode ^
        currentResearchsIds.hashCode;
  }
}
