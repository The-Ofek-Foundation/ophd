enum SocialType {
  contact,
  research,
  personal,
  code,
  industry,
  other,
}

class SocialLink {
  final dynamic icon;
  final String url;
  final String label;
  final bool isMain;
  final Set<SocialType> types;
  final String? fileType;

  SocialLink({
    required this.icon,
    required this.url,
    required this.label,
    required this.isMain,
    required this.types,
    this.fileType,
  });
}