// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:html' hide Selection;
import 'package:vizdom_select/vizdom_select.dart';

void main() {
  select('#root')
    ..select('.header', doo: (header) {
      header.select('.title').forEach((e) {
        final node = e.node as DivElement;
        node.text = "Vizdom";
      });
      header.select('.sub-title').forEach((e) {
        final node = e.node as DivElement;
        node.text = "how-to";
      });
    })..select('.content', doo: (content) {
      content.select('.description').forEach((e) {
        final node = e.node as DivElement;
        node.text = "Use select to select elements.";
      });
      content.select('.more-description').forEach((e) {
        final node = e.node as DivElement;
        node.text = "Use bind to bind data to elements.";
      });
  });
}
