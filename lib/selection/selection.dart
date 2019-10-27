import 'dart:html';

import 'package:vizdom_select/binding/binding.dart';

export '../selected/selected.dart';

Selection select(String selector) => Selection(querySelector(selector));

List<Selection> selectAll(String selector) =>
    querySelectorAll(selector).map((e) => Selection(e)).toList();

class Selection {
  final Element parent;

  Element _element;

  final data;

  Selection(Element element, {this.parent, this.data}) : _element = element {
    if (parent == null && _element == null) {
      throw Exception("Both parent and element cannot be null");
    }
  }

  Element get element => _element;

  Selection select(String selector, {void doo(Selection sel), Element init}) {
    final child = element.querySelector(selector);
    final ret = Selection(child, parent: element, data: data);
    if (child == null && init != null) {
      ret.replace(init);
    }
    if (doo != null) doo(ret);
    return ret;
  }

  List<Selection> selectAll(String select, {void doo(Selection sel)}) {
    final children = element.querySelectorAll(select);
    final ret = List<Selection>()..length = children.length;
    for (final child in children) {
      final sel = Selection(child, data: data);
      ret.add(sel);
      if (doo != null) doo(sel);
    }
    return ret;
  }

  Binding<DT> bind<DT>(String selector, List<DT> data, {List<String> keys}) {
    if (element == null) throw Exception("No parent element to bind to.");
    keys ??= List<String>.generate(data.length, (i) => i.toString());
    return Binding<DT>.keyed(selector, element, data, keys);
  }

  void replace(Element newElement, {bool ifAbsent = false}) {
    if (element != null) {
      if (ifAbsent) {
        element.replaceWith(newElement);
        _element = newElement;
      }
    } else {
      parent.children.add(newElement);
      _element = newElement;
    }
  }
}
