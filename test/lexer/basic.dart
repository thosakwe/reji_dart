import 'package:reji/reji.dart' as reji;
import 'package:test/test.dart';

main() {
  final RegExp WHITESPACE = new RegExp("( |\n|\r|\r\n)");

  test('lex a single int', () async {
    var lexer = new reji.Lexer(debug: true)
      ..lex('INT', "[0-9]+").then((token) => int.parse(token.text))
      ..scan("1337");

    reji.Token token = await lexer.tokenStream.first;
    print(token);
    expect(token.type.name, equals('INT'));
    expect(token.value, equals(1337));
  });

  test("dart", () async {
    var lexer = new reji.Lexer(debug: true);
    lexer.skip(WHITESPACE);
    lexer.lex("CURLY_L", "{");
    lexer.lex("CURLY_R", "}");
    lexer.lex("PAREN_L", r"\(");
    lexer.lex("PAREN_R", r"\)");
    lexer.lex("KW_ASYNC", "async");
    lexer.lex("ID", "[A-Za-z][A-Za-z0-9_]*");
    lexer.scan("main () async {}");

    List<reji.Token> tokens = await lexer.tokenStream.toList();
    print(tokens);
    expect(tokens[0].type.name, equals("ID"));
    expect(tokens[0].text, equals("main"));
    expect(tokens[1].type.name, equals("PAREN_L"));
    expect(tokens[2].type.name, equals("PAREN_R"));
    expect(tokens[3].type.name, equals("KW_ASYNC"));
    expect(tokens[4].type.name, equals("CURLY_L"));
    expect(tokens[5].type.name, equals("CURLY_R"));
  });

  test("skip a pattern", () async {
    reji.Lexer lexer = new reji.Lexer(debug: true);
    lexer
      ..skip(WHITESPACE)..skip("boy")
      ..lex("WORD", "[A-Za-z]+");
    lexer.scan("man girl boy woman");

    List<reji.Token> tokens = await lexer.tokenStream.toList();
    print(tokens);
    expect(tokens.length, equals(3));
    expect(tokens[0].text, equals("man"));
    expect(tokens[1].text, equals("girl"));
    expect(tokens[2].text, equals("woman"));
  });

  test("lex a variable declaration", () async {
    reji.Lexer lexer = new reji.Lexer(debug: true);
    lexer..skip(WHITESPACE)..skip(";");
    lexer..lex("KW_VAR", "var")..lex("ID", "[A-Za-z][A-Za-z0-9_]*");
    lexer.scan("var foo;");

    List<reji.Token> tokens = await lexer.tokenStream.toList();
    print(tokens);

    expect(tokens.length, equals(2));
    expect(tokens[0].type.name, equals("KW_VAR"));
    expect(tokens[1].type.name, equals("ID"));
  });

  test("nested rule", () async {
    reji.Lexer lexer = new reji.Lexer(debug: true);
    reji.TokenType DOT = lexer.lex("DOT", "\.");
    reji.TokenType DIGIT = lexer.lex("DIGIT", "[0-9]+");
    reji.TokenType DIGITS = lexer.lex("DIGITS", "$DIGIT+");
    lexer.lex("DECIMAL", "$DIGITS($DOT$DIGITS)").then((token) => num.parse(token.text));

    lexer.scan("420.69");

    List<reji.Token> tokens = await lexer.tokenStream.toList();
    print(tokens);

    expect(tokens.length, equals(1));
    expect(tokens[0].type.name, equals("DECIMAL"));
    expect(tokens[0].value, equals(420.69));
  });
}
