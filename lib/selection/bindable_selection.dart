import 'dart:html' hide Selection;
import 'dart:collection';

import 'package:vizdom_select/binding/binding.dart';
import 'package:vizdom_select/selection/selection.dart';

abstract class Bindable {
  /// Binds data to current [Selection] and returns update selection
  Binding<VT> bind<VT>(List<VT> values);

  Binding<UT> bindKeyed<UT>(List<UT> values, LinkedHashSet<String> keys);

  Binding<UT> bindMap<UT>(Map<String, UT> maps);
}

abstract class BindableSelected implements Selected, Bindable {}

class BindableSelection extends Selection implements BindableSelected {
  BindableSelection(List<List<Element>> groups, List<Element> parents)
      : super(groups, parents);

  /// Binds data to current [Selection] and returns update selection
  Binding<VT> bind<VT>(List<VT> values) =>
      Binding<VT>.indexed(groups, parents, values);

  Binding<UT> bindKeyed<UT>(List<UT> values, LinkedHashSet<String> keys) =>
      Binding.keyed(groups, parents, values, keys);

  Binding<UT> bindMap<UT>(Map<String, UT> map) => Binding.keyed(groups, parents,
      map.values.toList(), LinkedHashSet.from(map.keys.toList()));
}
