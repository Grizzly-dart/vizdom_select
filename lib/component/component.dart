// TODO add dependency injection

import 'package:vizdom_select/selected/selected.dart';

abstract class Component {

}

abstract class BoundComponent {

}

abstract class BindOperator<VT> {
  String get enterElementTag;

  void onEnter(BoundElementRef<VT> elementRef) {}

  void onExit(ElementRef elementRef) {}

  void onMerge(BoundElementRef<VT> elementRef) {}

  void onUpdate(BoundElementRef<VT> elementRef) {}
}