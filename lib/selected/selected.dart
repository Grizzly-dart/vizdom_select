import 'dart:html';

import 'package:vizdom_select/vizdom_select.dart';
import 'package:vizdom_select/binding/binding.dart';

/// Function that is called for each element in a selection.
typedef ForEachElement = void Function(Element element);

class BoundElementRef<DT> implements Data<DT> {
  @override
  final int dataIndex;

  @override
  final String label;

  @override
  final DT data;

  final Node node;

  final Iterable<DT> allData;

  BoundElementRef(
      this.node, this.data, this.dataIndex, this.label, this.allData);

  Element get element => node;

  Binding<T> bind<T>(String selector, List<T> data, {List<String> keys}) {
    keys ??= List<String>.generate(data.length, (i) => i.toString());
    return Binding<T>.keyed(selector, node, data, keys);
  }

  Selection get asSelection => Selection(node, data: data);
}

/// Called for each data in a [Binding] to update or merge data to the element.
typedef ForEachBound<VT> = void Function(BoundElementRef<VT> element);

class Data<DT> {
  final int dataIndex;

  final String label;

  final DT data;

  Data(this.data, this.dataIndex, this.label);
}

/// Called for each data in a [Binding] that does not have a corresponding element.
/// Must return an element that should be bound to data..
typedef EnterFunc<DT> = Element Function(Data<DT> data);

/*
abstract class SelectedMixin implements Selected {
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
 */
