class Company {
  final String name;
  final String logo;
  final String tooltip;
  final String? url;

  Company({
    required this.name,
    required this.logo,
    required this.tooltip,
    this.url,
  });
}
