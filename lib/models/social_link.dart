enum SocialType {
  contact,
  research,
  personal,
  code,
  other,
}

class SocialLink {
  final dynamic icon;
  final String url;
  final String label;
  final bool isMain;
  final SocialType type;

  SocialLink({
    required this.icon,
    required this.url,
    required this.label,
    required this.isMain,
    required this.type,
  });
}