import 'dart:html' hide Selection;
import 'dart:collection';

import 'package:vizdom_select/component/component.dart';
import 'package:vizdom_select/selection/selection.dart';

part 'enter_node.dart';

/// Encapsulates binding on a [Selection]
class Binding<VT> {
  /// Parents of each group in selection
  final Element parent;

  final List<_EnterNode> _enter;

  List<Element> _entered;

  final List<Element> _exit;

  final List<Element> _update;

  /// Labels of data bound to the selection
  final UnmodifiableListView<String> labels;

  /// The data bound to the selection
  final UnmodifiableListView<VT> data;

  Binding._(this.parent, this.data, this.labels, this._enter, this._exit,
      this._update);

  factory Binding.keyed(
      String selector, Element parent, List<VT> data, List<String> keys) {
    final elements = parent.querySelectorAll(selector);
    // Find keys for existing nodes
    final nodeKeyMap = <String, Element>{};
    for (final element in elements) {
      final key = element.dataset['vizdom-key'];
      if (key == null) continue;
      nodeKeyMap[key] = element;
    }

    final enters = <_EnterNode>[];
    final updates = <Element>[]..length = data.length;

    for (int i = 0; i < data.length; i++) {
      final key = keys[i];
      final element = nodeKeyMap.remove(key);
      if (element == null) {
        enters.add(_EnterNode(parent, data[i], key, i, null));
        continue;
      }
      updates[i] = element;
    }

    final exits = nodeKeyMap.values.toList();

    return Binding<VT>._(parent, UnmodifiableListView<VT>(data),
        UnmodifiableListView<String>(keys), enters, exits, updates);
  }

  /// Updates new elements based on their data.
  ///
  /// Executes [forEach] function on each element that has been newly added.
  void enter(EnterFunc<VT> forEach) {
    if (_entered != null) throw Exception('Already entered!');
    _entered = []..length = data.length;
    for (int i = 0; i < _enter.length; i++) {
      final _EnterNode enter = _enter[i];
      final newEl = forEach(
          Data<VT>(data[enter.index], enter.index, labels[enter.index]));
      newEl.dataset['vizdom-key'] = labels[enter.index];
      _entered[enter.index] = newEl;
      parent.children.add(newEl);
      if (forEach != null) {}
    }
  }

  /// Executes [forEach] function on each old element whose bound data has been
  /// removed.
  void exit(ForEachElement forEach) {
    for (final element in _exit) {
      forEach(element);
    }
  }

  /// Updates old elements based on changes to their data.
  ///
  /// Executes [forEach] function on each element that needs update.
  void update(ForEachBound<VT> forEach) {
    for (int i = 0; i < _update.length; i++) {
      final el = _update[i];
      if (el != null) {
        forEach(BoundElementRef<VT>(el, data[i], i, labels[i], data));
      }
    }
  }

  /// Merges enter and update selections and returns the merged selection
  ///
  /// Binding must be entered before merging
  void merge(ForEachBound<VT> forEach) {
    if (_enter.isNotEmpty && _entered == null) {
      throw Exception('Must be entered before merge!');
    }
    for (int i = 0; i < data.length; i++) {
      final Element entered = _entered[i];
      final Element updated = _update[i];
      final element = entered ?? updated;
      if (element != null) {
        forEach(BoundElementRef<VT>(element, data[i], i, labels[i], data));
      }
    }
  }

  void operate(BindOperator<VT> operator) {
    exit(operator.onExit);
    enter(operator.onEnter);
    merge(operator.onMerge);
    update(operator.onUpdate);
  }

  List<Selection> selectAll() {
    if (_enter.isNotEmpty && _entered == null) {
      throw Exception('Must be entered before selection!');
    }
    final ret = <Selection>[]..length = data.length;
    for (int i = 0; i < data.length; i++) {
      ret[i] =
          Selection(_entered[i] ?? _update[i], parent: parent, data: data[i]);
    }
    return ret;
  }
}

/*
  factory Binding.indexed(
      UnmodifiableListView<UnmodifiableListView<Element>> groups,
      UnmodifiableListView<Element> parents,
      List<VT> data) {
    final enters = List<List<_EnterNode>>.filled(groups.length, null);
    final exits = List<List<Element>>.filled(groups.length, null);
    final updates = List<List<Element>>.filled(groups.length, null);

    for (int j = 0; j < groups.length; j++) {
      final List<Element> group = groups[j];
      final Element parent = parents[j];

      final enter = List<_EnterNode>.filled(data.length, null);
      final exit = List<Element>.filled(group.length, null);
      final update = List<Element>.filled(data.length, null);

      enters[j] = enter;
      exits[j] = exit;
      updates[j] = update;

      // Non-null nodes => update
      // Null nodes => enter
      // New nodes => enter.
      for (int i = 0; i < data.length; i++) {
        final Element el = i < group.length ? group[i] : null;
        if (el != null) {
          el.dataset['vizzie-label'] = i.toString();
          update[i] = el;
        } else {
          enter[i] = _EnterNode(parent, data[i], i.toString(), i, null);
        }
      }

      // extra nodes => exit
      for (int i = data.length; i < group.length; i++) {
        final Element el = group[i];
        if (el != null) {
          exit[i] = el;
        }
      }

      // Order so that newly entered nodes are inserted in order
      /* Seems like this is not necessary
      {
        int i1 = 0;
        Element next;

        for (int i0 = 0; i0 < data.length; i0++) {
          final _EnterNode previous = enter[i0];
          if (previous != null) {
            if (i0 >= i1) {
              if (i0 == (data.length - 1)) break;
              i1 = i0 + 1;
            }
            while (((next = update[i1]) == null) && (++i1 < data.length));
            enter[i0] = previous.cloneWithNext(next);
            if (i1 >= data.length) break;
          }
        }
      }
      */
    }

    final labels = List<String>.generate(data.length, (int i) => i.toString());

    return Binding<VT>._(groups, parents, makeImmutableLevel1<VT>(data),
        makeImmutableLevel1<String>(labels), enters, exits, updates);
  }
 */
