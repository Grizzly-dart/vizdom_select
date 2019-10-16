// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:html' hide Selection;
import 'package:vizdom_select/vizdom_select.dart';

void main() {
  select('#root')
      .selectAll('div')
      .bindMap<int>(LinkedHashMap<String, int>.fromIterable([50, 80, 20],
          key: (i) => i.toString()))
      .enter('div', (element) {
    final DivElement div = element.node;
    div.style
      ..margin = '2px'
      ..boxSizing = 'border-box'
      ..display = 'inline-block'
      ..padding = '5px'
      ..backgroundColor = '#E6E6E6';
    div.text = element.data.toString();
  });

  /*
  select('#root').selectAll('div').bindMap<int>(
      LinkedHashMap<String, int>.fromIterable([10, 20, 40, 50, 70, 80, 100],
          key: (i) => i.toString()))
    ..exit((e) => e.node.remove())
    ..enter('div', (element) {
      final DivElement div = element.node;
      div.style
        ..margin = '2px'
        ..boxSizing = 'border-box'
        ..display = 'inline-block'
        ..padding = '5px'
        ..backgroundColor = '#E6E6E6';
    })
    ..merge((element) {
      final div = element.node as DivElement;
      div.text = element.data.toString();
    }) /* TODO .order() */;
   */
}
