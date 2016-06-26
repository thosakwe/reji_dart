import 'dart:async';
import 'package:reji/reji.dart' as reji;

class Sql {
  final reji.Lexer _lexer = new reji.Lexer();
  final reji.Parser _parser = new reji.Parser();
  List<Map> items = [];

  void _setUpLexer() {
    _lexer
      ..lex("ASTERISK", r"\*")
      ..lex("EQUALS", "=")
      ..lex("KW_ASC", new RegExp("ASC", caseSensitive: false))
      ..lex("KW_BY", new RegExp("BY", caseSensitive: false))
      ..lex("KW_FROM", new RegExp("FROM", caseSensitive: false))
      ..lex("KW_ORDER", new RegExp("ORDER", caseSensitive: false))
      ..lex("KW_SELECT", new RegExp("SELECT", caseSensitive: false))
      ..lex("KW_WHERE", new RegExp("WHERE", caseSensitive: false))
      ..lex("STRING", new RegExp("('[^']*')|(`[^`]*`)"))
      ..lex("ID", new RegExp("[A-Za-z][A-za-z0-9_]*"));
  }

  Sql() {
    _setUpLexer();
  }

  Future<List<Map>> executeQueries(List<String> queries) async {
    List<Map> result = []..addAll(items);

    for (String query in queries) {
      _lexer.scan(query);
      reji.ParseTree ast = await _lexer.tokenStream.transform(_parser).first;
    }

    return result;
  }
}
