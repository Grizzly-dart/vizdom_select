import 'dart:html';
import 'dart:collection';
import 'dart:html' as prefix0;

import 'package:vizdom_select/binding/binding.dart';
import 'package:vizdom_select/selection/bindable_selection.dart';
import 'package:vizdom_select/uitls/collection.dart';
import 'package:vizdom_select/uitls/html.dart';

import '../selected/selected.dart';

export '../selected/selected.dart';
export 'bound.dart';

Selection select(String selector) => Selection([
      [querySelector(selector)]
    ], [
      document.documentElement
    ]);

Selection selectAll(String selector) =>
    Selection([querySelectorAll(selector)], [document.documentElement]);

class Selection implements Selectable {
  final UnmodifiableListView<UnmodifiableListView<Element>> groups;

  final UnmodifiableListView<Element> parents;

  final UnmodifiableListView<Element> allElements;

  Selection(List<List<Element>> groups, List<Element> parents)
      : groups = makeImmutableLevel2<Element>(groups),
        parents = makeImmutableLevel1<Element>(parents),
        allElements = UnmodifiableListView(groups.fold<List<Element>>(
            <Element>[],
            (List<Element> list, List<Element> g) => list..addAll(g)));

  Selection._groups(List<List<Element>> groups, this.parents)
      : groups = makeImmutableLevel2<Element>(groups),
        allElements = UnmodifiableListView(groups.fold<List<Element>>(
            <Element>[],
            (List<Element> list, List<Element> g) => list..addAll(g)));

  Selection select(String select, {void doo(Selection sel)}) {
    final newGroup = List<List<Element>>.filled(groups.length, null);

    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        newGroup[i][j] = el.querySelector(select);
      }
    }

    final ret = Selection._groups(newGroup, this.parents);
    if (doo != null) doo(ret);
    return ret;
  }

  BindableSelected selectAll(String select) {
    final newGroup = <List<Element>>[];
    final newParents = <Element>[];

    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        newGroup.add(el.querySelectorAll(select));
        newParents.add(el);
      }
    }
    return BindableSelection(newGroup, newParents);
  }

  void forEach(ForEach forEach) {
    allElements.map((e) => ElementRef(e)).forEach(forEach);
  }

  Selection append(String tag, {ForEach forEach}) {
    final newGroup = List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final Element newEl = createElement(tag);
        el.append(newEl);
        newGroup[i][j] = newEl;
      }
    }

    final ret = Selection(newGroup, this.parents);
    if (forEach != null) ret.forEach(forEach);
    return ret;
  }

  Selection insert(
      String tag, Element before(int index, Element parent, int groupIndex)) {
    final newGroup = List<List<Element>>.filled(groups.length, null);
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      newGroup[i] = List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final Element el = group[j];
        if (el == null) continue;
        final Element newEl = createElement(tag);
        final Element beforeEl = before(j, el, i);
        el.insertBefore(newEl, beforeEl);
        newGroup[i][j] = newEl;
      }
    }
    return Selection(newGroup, this.parents);
  }

  Selection remove() {
    allElements.where((e) => e != null).forEach((Element e) => e.remove());
    // TODO empty allElements?
    return this;
  }

  // TODO Selection order() => super.order();
}

abstract class Selectable {
  Selection select(String /* TODO String | Element */ select);

  BindableSelected selectAll(String select);
}
