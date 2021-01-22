// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' hide Selection;
import 'package:vizdom_select/vizdom_select.dart';

void main() {
  select('#root')
    ..select('.header', init: DivElement(), doo: (header) {
      final title = header.select('.title', init: DivElement());
      DivElement node = title.element;
      node.text = 'Vizdom';
      final subTitle = header.select('.sub-title', init: DivElement());
      node = subTitle.element;
      node.text = 'how-to';
    })
    ..select('.content', init: DivElement(), doo: (content) {
      final description = content.select('.description', init: DivElement());
      DivElement node = description.element;
      node.text = 'Use select to select elements.';
      final moreDescription =
          content.select('.more-description', init: DivElement());
      node = moreDescription.element;
      node.text = 'Use bind to bind data to elements.';
    });
}
