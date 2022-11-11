import 'package:reach_core/core/core.dart';

class ResearcherMapper {
  static Researcher fromMap(Map<String, dynamic> data) {
    return Researcher(
        researcherId: data['researcherId'] ?? "",
        name: data['name'] ?? "",
        bio: data['bio'] ?? "",
        organization: data['organization'] ?? "",
        imageUrl: data['imageUrl'] ?? "",
        defaultColor: data['defaultColor'] ?? 0xFFFFFF,
        city: data['city'] ?? "",
        numberOfResearches: data['numberOfResearches'] ?? 0,
        currentResearchsIds: data['currentResearchsIds'] ?? []);
  }

  static Map<String, dynamic> toMap(Researcher researcher) {
    return {
      'researcherId': researcher.researcherId,
      'name': researcher.name,
      'city': researcher.city,
      'bio': researcher.bio,
      'organization': researcher.organization,
      'imageUrl': researcher.imageUrl,
      'defaultColor': researcher.defaultColor,
      'numberOfResearches': researcher.numberOfResearches,
      'currentResearchsIds': researcher.currentResearchsIds,
    };
  }

  static Map<String, dynamic> toResearchMap(Researcher researcher) {
    return {
      'researcherId': researcher.researcherId,
      'name': researcher.name,
      'city': researcher.city,
      'bio': researcher.bio,
      'organization': researcher.organization,
      'imageUrl': researcher.imageUrl,
      'defaultColor': researcher.defaultColor,
      'numberOfResearches': researcher.numberOfResearches,
    };
  }

  static Map<String, dynamic> toPartialMap(Researcher researcher) {
    return {
      'researcherId': researcher.researcherId,
      'name': researcher.name,
      'imageUrl': researcher.imageUrl,
      'defaultColor': researcher.defaultColor,
    };
  }
}
