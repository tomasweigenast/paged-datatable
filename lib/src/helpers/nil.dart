///
/// Credits to: https://github.com/letsar/nil 
///
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

const nil = Nil();

class Nil extends Widget {
  /// Creates a [Nil] widget.
  const Nil({Key? key}) : super(key: key);

  @override
  Element createElement() => _NilElement(this);
}

class _NilElement extends Element {
  _NilElement(Nil widget) : super(widget);

  @override
  void mount(Element? parent, dynamic newSlot) {
    assert(parent is! MultiChildRenderObjectElement, """
        You are using Nil under a MultiChildRenderObjectElement.
        This suggests a possibility that the Nil is not needed or is being used improperly.
        Make sure it can't be replaced with an inline conditional or
        omission of the target widget from a list.
        """);

    super.mount(parent, newSlot);
  }

  @override
  bool get debugDoingBuild => false;

  @override
  void performRebuild() {}
}