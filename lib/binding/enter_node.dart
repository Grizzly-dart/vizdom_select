import 'dart:html';

/// Encapsulates the items that needs to be entered in [Binding]
class EnterNode<VT> {
  /// Parent of the entered item
  final Element parent;

  /// Label of the data bound to the item
  final String label;

  /// Data bound to the item
  final VT data;

  /// Index of datum in data bound to the selection
  final int index;

  /// Node before which the entered item shall be inserted
  ///
  /// [next] can be null
  final Node next;

  EnterNode(this.parent, this.data, this.label, this.index, this.next);

  EnterNode cloneWithNext(Element next) =>
      EnterNode(parent, data, label, index, next);

  void append(Element child) => parent.insertBefore(child, next);
}