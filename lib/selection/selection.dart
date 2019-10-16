import 'dart:html';
import 'dart:collection';

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

class Selection extends Object with SelectedMixin implements Selected {
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

  /// Sets a constant attribute with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attribute
  /// to them. Null elements are skipped.
  Selection attr(String name, String value) => super.attr(name, value);

  /// Sets constant attributes with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attributes
  /// to them. Null elements are skipped.
  Selection attrs(Map<String, String> attrMap) => super.attrs(attrMap);

  /// Sets a constant style with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided style
  /// to them. Null elements are skipped.
  Selection style(String name, String value, [String priority]) =>
      super.style(name, value, priority);

  /// Sets constant styles with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided styles
  /// to them. Null elements are skipped.
  Selection styles(Map<String, String> styles, [String priority]) =>
      super.styles(styles, priority);

  /// Adds constant classes [classes] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and adds classes
  /// to them. Null elements are skipped.
  Selection classes(List<String> classes) => super.classes(classes);

  /// Adds constant class [clazz] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and adds class
  /// to them. Null elements are skipped.
  Selection clazz(String clazz) => super.clazz(clazz);

  /// Sets a constant text context of all elements in the selection to [text]
  ///
  /// Iterates over all elements in the selection and sets their text content.
  /// Null elements are skipped.
  Selection text(textContent) => super.text(textContent);

  Selection select(String select) {
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
    return Selection._groups(newGroup, this.parents);
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

  Selection append(String tag) {
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
    return Selection(newGroup, this.parents);
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
    return this;
  }

  Selection order() => super.order();
}