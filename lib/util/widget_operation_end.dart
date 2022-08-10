import 'package:flutter/widgets.dart';

extension WidgetOperationEnd on Widget {
  Widget withExpaned() {
    return Expanded(child: this);
  }

  Widget withFlexible(int flex) {
    return Flexible(child: this, flex: flex);
  }

  Widget withPadding(EdgeInsets insets) {
    return Padding(padding: insets, child: this);
  }
}

