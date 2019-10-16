import 'dart:html' hide Selection;
import 'dart:collection';

import 'package:vizdom_select/selection/bound.dart';
import 'package:vizdom_select/selection/selection.dart';
import 'package:vizdom_select/uitls/collection.dart';
import 'package:vizdom_select/uitls/html.dart';

part 'enter_node.dart';

/// Encapsulates binding on a [Selection]
class Binding<VT> {
  /// Groups in selection
  final UnmodifiableListView<UnmodifiableListView<Element>> groups;

  /// Parents of each group in selection
  final UnmodifiableListView<Element> parents;

  final List<List<_EnterNode>> _enter;

  List<List<Element>> _entered;

  final List<List<Element>> _exit;

  final List<List<Element>> _update;

  /// Labels of data bound to the selection
  final UnmodifiableListView<String> labels;

  /// The data bound to the selection
  final UnmodifiableListView<VT> data;

  Binding._(this.groups, this.parents, this.data, this.labels, this._enter,
      this._exit, this._update);

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

  factory Binding.keyed(
      UnmodifiableListView<UnmodifiableListView<Element>> groups,
      UnmodifiableListView<Element> parents,
      List<VT> data,
      LinkedHashSet<String> keys) {
    final enters = List<List<_EnterNode>>.filled(groups.length, null);
    final exits = List<List<Element>>.filled(groups.length, null);
    final updates = List<List<Element>>.filled(groups.length, null);

    for (int j = 0; j < groups.length; j++) {
      final nodeKeyMap = <String, Element>{};

      final List<Element> group = groups[j];
      final Element parent = parents[j];

      final enter = List<_EnterNode>.filled(data.length, null);
      final exit = List<Element>.filled(group.length, null);
      final update = List<Element>.filled(data.length, null);

      enters[j] = enter;
      exits[j] = exit;
      updates[j] = update;

      // Find keys for existing nodes
      for (int i = 0; i < group.length; i++) {
        final Element el = group[i];
        if (el == null) continue;
        final String key = el.dataset['vizzie-label'];
        if (nodeKeyMap.containsKey(key)) {
          exit[i] = el;
        } else if (!keys.contains(key)) {
          exit[i] = el;
        } else {
          nodeKeyMap[key] = el;
        }
      }

      final Iterator<String> keyIter = keys.iterator;
      keyIter.moveNext();
      for (int i = 0; i < data.length; i++) {
        final String key = keyIter.current;
        if (nodeKeyMap.containsKey(key)) {
          update[i] = nodeKeyMap[key];
          nodeKeyMap.remove(key);
        } else {
          enter[i] = _EnterNode(parent, data[i], key, i, null);
        }
        keyIter.moveNext();
      }
    }

    return Binding<VT>._(groups, parents, makeImmutableLevel1<VT>(data),
        makeImmutableLevel1<String>(keys.toList()), enters, exits, updates);
  }

  /// Updates new elements based on their data.
  ///
  /// Executes [forEach] function on each element that has been newly added.
  void enter(String tag, ForEachBound<VT> forEach) {
    if (_entered != null) throw Exception('Already entered!');
    _entered = List<List<Element>>.filled(_enter.length, null);
    for (int i = 0; i < _enter.length; i++) {
      final List<_EnterNode> group = _enter[i];
      _entered[i] = List<Element>.filled(group.length, null);
      for (int j = 0; j < group.length; j++) {
        final _EnterNode el = group[j];
        if (el == null) continue;

        final Element newEl = createElement(tag);
        newEl.dataset['vizzie-label'] = labels[j];
        el.append(newEl);
        _entered[i][j] = newEl;
        forEach(BoundElementRef<VT>(newEl, data[j], j, labels[j]));
      }
    }
  }

  /// Executes [forEach] function on each old element whose bound data has been
  /// removed.
  void exit(ForEach forEach) {
    for (final group in _exit) {
      for (final element in group) {
        forEach(ElementRef(element));
      }
    }
  }

  /// Updates old elements based on changes to their data.
  ///
  /// Executes [forEach] function on each element that needs update.
  void update(ForEachBound<VT> forEach) {
    for (final group in _update) {
      for (int j = 0; j < group.length; j++) {
        forEach(BoundElementRef<VT>(group[j], data[j], j, labels[j]));
      }
    }
  }

  /// Merges enter and update selections and returns the merged selection
  ///
  /// Binding must be entered before merging
  void merge(ForEachBound<VT> forEach) {
    if (_entered == null) throw Exception('Must be entered before merge!');
    for (int i = 0; i < groups.length; i++) {
      final List<Element> entered = _entered[i];
      final List<Element> updated = _update[i];
      for (int j = 0; j < data.length; j++) {
        final element = entered[j] ?? updated[j];
        forEach(BoundElementRef<VT>(element, data[j], j, labels[j]));
      }
    }
  }
}
