import 'dart:html';

import 'package:vizdom_select/uitls/namespace.dart';

Element createElement(String tag) {
  final name = Namespaced.parse(tag);

  if(!name.hasSpace) return Element.tag(tag);

  return document.createElementNS(name.space, name.local);
}