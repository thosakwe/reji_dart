import 'package:reji/reji.dart';
import 'package:test/test.dart';

main() {
  final RegExp WS = new RegExp("( |\n|\r|\r\n)");

  test("parse some basic math", () async {
    var lexer = new Lexer()..skip(WS);
    var parser = new Parser();

    // Lexer rules
    lexer
      ..lex("DOT", r"\.")
      ..lex("PLUS", r"\+")
      ..lex("TIMES", r"\*")
      ..lex("DIGITS", "[0-9]+")
      ..lex("NUMBER", "<%DIGITS%>(<%DOT%><%DIGITS%>)?").then((token) => num.parse(token.text))
      ..scan("3 + 6");

    // Parse rules
    parser
      ..parse("SUM", "NUMBER PLUS NUMBER").then((tree) => tree['NUMBER'][0].value + tree['NUMBER'][1].value)
      ..parse("PRODUCT", "NUMBER TIMES NUMBER").then((tree) => tree['NUMBER'][0].value * tree['NUMBER'][1].value)
      ..parse("ARITH_EXPR", "SUM|PRODUCT").then((tree) => tree.tokens.first.value);

    List<ParseTree> trees = await lexer.tokenStream.transform(parser).toList();
  });
}
