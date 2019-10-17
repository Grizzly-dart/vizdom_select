import 'dart:html';
import 'dart:collection';
import 'dart:html' as prefix0;

import 'package:vizdom_select/binding/binding.dart';
import 'package:vizdom_select/uitls/collection.dart';
import 'package:vizdom_select/uitls/html.dart';

import '../selected/selected.dart';

export '../selected/selected.dart';

Selection select(String selector) => Selection(querySelector(selector));

List<Selection> selectAll(String selector) =>
    querySelectorAll(selector).map((e) => Selection(e)).toList();

class Selection {
  final Element element;

  final data;

  Selection(this.element, {this.data});

  Selection select(String selector, {void doo(Selection sel)}) {
    final child = element.querySelector(selector);
    final ret = Selection(child, data: data);
    if (doo != null) doo(ret);
    return ret;
  }

  List<Selection> selectAll(String select, {void doo(Selection sel)}) {
    final children = element.querySelectorAll(select);
    final ret = List<Selection>()..length = children.length;
    for(final child in children) {
      final sel = Selection(child, data: data);
      ret.add(sel);
      if (doo != null) doo(sel);
    }
    return ret;
  }

  Binding<DT> bind<DT>(String selector, List<DT> data, {List<String> keys}) {
    keys ??= List<String>.generate(data.length, (i) => i.toString());
    return Binding<DT>.keyed(selector, element, data, keys);
  }
}

/* TODO
abstract class Selectable {
  Selection select(String /* TODO String | Element */ select);

  BindableSelected selectAll(String select);
}
 */
