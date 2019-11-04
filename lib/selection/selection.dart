import 'dart:html';

import 'package:vizdom_select/binding/binding.dart';

export '../selected/selected.dart';

Selection select(/* String | Node */ selector) {
  if (selector is String) selector = querySelector(selector);
  return Selection(selector);
}

List<Selection> selectAll(String selector) =>
    querySelectorAll(selector).map((e) => Selection(e)).toList();

class Selection {
  final Element parent;

  Node _node;

  dynamic data;

  Selection(Node node, {this.parent, this.data}) : _node = node {
    if (parent == null && _node == null) {
      throw Exception("Both parent and element cannot be null");
    }
  }

  Node get node => _node;

  Element get element => _node as Element;

  Selection select(String selector,
      {void doo(Selection sel), Node init, dynamic data}) {
    final child = element.querySelector(selector);
    final ret = Selection(child, parent: element, data: data ?? this.data);
    if (child == null && init != null) {
      ret.replace(init);
    }
    if (doo != null) doo(ret);
    return ret;
  }

  List<Selection> selectAll(String select,
      {void doo(Selection sel), dynamic data}) {
    final children = element.querySelectorAll(select);
    final ret = List<Selection>()..length = children.length;
    for (final child in children) {
      final sel = Selection(child, data: data ?? this.data);
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

  void replace(Node newElement, {bool ifAbsent = false}) {
    if (node != null) {
      if (ifAbsent) {
        node.replaceWith(newElement);
        _node = newElement;
      }
    } else {
      parent.children.add(newElement);
      _node = newElement;
    }
  }
}
