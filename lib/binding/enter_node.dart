part of 'binding.dart';

/// Encapsulates the items that needs to be entered in [Binding]
class _EnterNode<VT> {
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

  _EnterNode(this.parent, this.data, this.label, this.index, this.next);

  _EnterNode cloneWithNext(Element next) =>
      _EnterNode(parent, data, label, index, next);

  void append(Element child) => parent.insertBefore(child, next);
}
