library reji.ast;

import 'dart:async';
import 'shared.dart';

/// Represents an abstract syntax tree, and supports querying.
class Ast implements StreamConsumer<ParseTree> {
  bool _open = true;
  List<ParseTree> children = [];

  @override Future addStream(Stream<ParseTree> stream) async {
    if (!_open)
      throw new Exception("Cannot pipe into a closed AST.");
  }

  @override Future close() async {
    _open = false;
  }

  List<ParseTree> select(String query) {
    List<ParseTree> result = [];

    return result;
  }
}
