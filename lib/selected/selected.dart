import 'dart:html';

class ElementRef {
  final Node node;

  ElementRef(this.node);

  /* TODO
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
   */
}

typedef ForEach = void Function(ElementRef element);

class BoundElementRef<DT> implements ElementRef {
  final int dataIndex;

  final String label;

  final DT data;

  final Node node;

  BoundElementRef(this.node, this.data, this.dataIndex, this.label);
}

typedef ForEachBound<VT> = void Function(BoundElementRef<VT> element);

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
