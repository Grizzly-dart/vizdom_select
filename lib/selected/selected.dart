import 'dart:html';

typedef ForEach = void Function(Element element);

class BoundElementRef<DT> implements Data<DT> {
  final int dataIndex;

  final String label;

  final DT data;

  final Node node;

  final Iterable<DT> allData;

  BoundElementRef(this.node, this.data, this.dataIndex, this.label, this.allData);
}

typedef ForEachBound<VT> = void Function(BoundElementRef<VT> element);

class Data<DT> {
  final int dataIndex;

  final String label;

  final DT data;

  Data(this.data, this.dataIndex, this.label);
}

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
