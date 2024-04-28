import '../models/author.dart';

final Map<String, Author> authors = {
  'ofek': Author(
    name: 'Ofek Gila',
    link: 'https://ofek.phd',
    isMe: true,
    i10nKey: 'ofek',
  ),
  'mikeg': Author(
    name: 'Michael Goodrich',
    link: 'https://www.ics.uci.edu/~goodrich/',
    i10nKey: 'mikeg',
  ),
  'bob': Author(
    name: 'Robert Tarjan',
    link: 'https://www.cs.princeton.edu/~ret/',
    i10nKey: 'bob',
  ),
  'evrim': Author(
    name: 'Evrim Ozel',
    link: 'https://www.ics.uci.edu/~eozel/',
    i10nKey: 'evrim',
  ),
  'mikes': Author(
    name: 'Michael Shindler',
    link: 'https://www.ics.uci.edu/~mikes/',
    i10nKey: 'mikes',
  ),
  'miked': Author(
    name: 'Michael Dillencourt',
    link: 'https://www.ics.uci.edu/~dillenco/',
    i10nKey: 'miked',
  ),
};