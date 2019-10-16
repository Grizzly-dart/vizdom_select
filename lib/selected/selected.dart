import 'dart:html';
import 'dart:collection';

import 'package:vizdom_select/namespace/namespace.dart';
import 'package:vizdom_select/selection/bindable_selection.dart';

class SelectedElement {
  set attributes(Map<String, String> attributes) {
    // TODO
  }

  set styles(Map<String, String> attributes) {
    // TODO
  }

  set classes(List<String> attributes) {
    // TODO
  }

  set text(String value) {
    // TODO
  }
}

/// Interface class for a selected selection
abstract class Selected {
  /// Groups in selection
  UnmodifiableListView<UnmodifiableListView<Element>> get groups;

  /// Parents of each group in selection
  UnmodifiableListView<Element> get parents;

  /// Sets a constant attribute with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attribute
  /// to them. Null elements are skipped.
  Selected attr(String name, String value);

  /// Sets constant attributes with name [name], value [value] to all elements
  /// in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided attributes
  /// to them. Null elements are skipped.
  Selected attrs(Map<String, String> values);

  /// Sets a constant style with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided style
  /// to them. Null elements are skipped.
  Selected style(String name, String value, [String priority]);

  /// Sets constant styles with name [name], value [value] and priority
  /// [priority] to all elements in the selection
  ///
  /// Iterates over all elements in the selection and sets the provided styles
  /// to them. Null elements are skipped.
  Selected styles(Map<String, String> styles, [String priority]);

  Selected classes(List<String> classes);

  Selected clazz(String clazz);

  Selected text(textContent);

  //TODO Selected rmAttr(String name);

  //TODO Selected rmStyle(String name);

  //TODO Selected rmClass(String name);

  //TODO Selected rmClasses(List<String> classes);

  Selected select(String select);

  BindableSelected selectAll(String select);

  Selected append(String tag);

  Selected insert(
      String tag,
      Element before(
          int index, Element parent, int groupIndex));

  Selected remove();

  Selected order();

//TODO Selected replace();  //TODO: must take a function
}

abstract class SelectedMixin implements Selected {
  UnmodifiableListView<Element> get allElements;

  Selected attr(String name, String value) {
    final Namespaced attrName = Namespaced.parse(name);
    allElements.where((e) => e != null).forEach((Element e) {
      if (attrName.hasSpace) {
        e.setAttributeNS(attrName.space, attrName.local, value);
      } else {
        e.setAttribute(attrName.local, value);
      }
    });
    return this;
  }

  Selected attrs(Map<String, String> attrMap) {
    final attrSpaces = <String, Namespaced>{};
    attrMap.forEach((String n, _) {
      final Namespaced attrName = Namespaced.parse(n);
      attrSpaces[n] = attrName;
    });
    allElements.where((e) => e != null).forEach((Element e) => attrMap
        .forEach((String name, String value) {
      final Namespaced attrName = attrSpaces[name];
      if (attrName.hasSpace) {
        e.setAttributeNS(attrName.space, attrName.local, value);
      } else {
        e.setAttribute(attrName.local, value);
      }
    }));
    return this;
  }

  Selected style(String name, String value, [String priority]) {
    allElements
        .where((e) => e != null)
        .forEach((Element e) => e.style.setProperty(name, value, priority));
    return this;
  }

  Selected styles(Map<String, String> styles, [String priority]) {
    allElements.where((e) => e != null).forEach((Element e) => styles.forEach(
            (String name, String value) =>
            e.style.setProperty(name, value, priority)));
    return this;
  }

  Selected classes(List<String> classes) {
    allElements
        .where((e) => e != null)
        .forEach((Element e) => e.classes.addAll(classes));
    return this;
  }

  Selected clazz(String clazz) {
    allElements
        .where((e) => e != null)
        .forEach((Element e) => e.classes.add(clazz));
    return this;
  }

  Selected text(textContent) {
    allElements
        .where((e) => e != null)
        .forEach((Element e) => e.text = textContent.toString());
    return this;
  }

  Selected order() {
    for (int i = 0; i < groups.length; i++) {
      final List<Element> group = groups[i];
      if (group.length <= 1) continue;

      final Iterator<Element> iterator = group.reversed.iterator;
      iterator.moveNext();
      Element next = iterator.current;

      while (iterator.moveNext()) {
        final Element el = iterator.current;
        if (el == null) continue;
        if (el.nextElementSibling != next) el.parent.insertBefore(el, next);
        next = el;
      }
    }
    return this;
  }
}