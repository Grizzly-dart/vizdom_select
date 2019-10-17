// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';
import 'dart:html' hide Selection;
import 'package:vizdom_select/vizdom_select.dart';

void main() {
  select('#root')
    ..select('.header', doo: (header) {
      final title = header.select('.title');
      DivElement node = title.element;
      node.text = "Vizdom";
      final subTitle = header.select('.sub-title');
      node = subTitle.element;
      node.text = "how-to";
    })
    ..select('.content', doo: (content) {
      final description = content.select('.description');
      DivElement node = description.element;
      node.text = "Use select to select elements.";
      final moreDescription = content.select('.more-description');
      node = moreDescription.element;
      node.text = "Use bind to bind data to elements.";
    });
}
