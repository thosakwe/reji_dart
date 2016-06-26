library reji.parser;

import 'dart:async';
import 'shared.dart';

class Parser implements StreamTransformer<Token, ParseTree> {
  StreamController<ParseTree> _treeStream = new StreamController<ParseTree>();

  Stream<ParseTree> get treeStream => _treeStream.stream;


  String _strand = "";

  Stream<ParseTree> bind(Stream<Token> tokenStream) {
    tokenStream.toList().then(transform);
    return _treeStream.stream;
  }

  ParseTreeType parse(String name, List<String> tokenTypes) {
    return null;
  }

  transform(List<Token> tokens) {
    for (Token token in tokens) {
      if (_strand.isNotEmpty)
        _strand += " ";

      _strand += token.type.name;
    }

    _buildTrees(tokens);
  }

  _buildTrees(List<Token> tokens) {
    _treeStream.close();
  }
}