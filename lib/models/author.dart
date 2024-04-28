class Author {
  final String name;
  final String link;
  final bool isMe;
  final String i10nKey;

  Author({
    required this.name,
    required this.link,
    this.isMe = false,
    required this.i10nKey,
  });
}
