// TODO add dependency injection

import 'dart:html';

import 'package:vizdom_select/selected/selected.dart';

abstract class BindOperator<VT> {
  Element onEnter(Data<VT> data) {}

  void onExit(Element elementRef) {}

  void onMerge(BoundElementRef<VT> elementRef) {}

  void onUpdate(BoundElementRef<VT> elementRef) {}
}