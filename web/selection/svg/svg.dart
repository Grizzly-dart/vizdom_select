// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:svg';
import 'package:vizdom_select/vizdom_select.dart';

void main() {
  final selection = select('svg')
    ..select('text',
        init: SvgElement.tag('text')
          ..innerHtml = 'Hello'
          ..setAttribute('x', '50')
          ..setAttribute('y', '10'))
    ..select('rect',
        init: SvgElement.tag('rect')
          ..setAttribute('width', '100')
          ..setAttribute('height', '100')
          ..setAttribute('x', '10')
          ..setAttribute('y', '10')
          ..style.setProperty('fill', 'green'));
}
