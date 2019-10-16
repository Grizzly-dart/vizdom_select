import 'dart:collection';

UnmodifiableListView<UnmodifiableListView<T>> makeImmutableLevel2<T>(
        List<List<T>> list) =>
    UnmodifiableListView<UnmodifiableListView<T>>(
        list.map((List<T> l) => UnmodifiableListView<T>(l)).toList());

UnmodifiableListView<T> makeImmutableLevel1<T>(List<T> list) =>
    UnmodifiableListView<T>(list);
