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
    /**
     * var tokens = new Reji.Lexer()
        .skip(WHITESPACE)
        .lex('CURLY_L', /\{/)
        .lex('CURLY_R', /}/)
        .lex('PAREN_L', /\(/)
        .lex('PAREN_R', /\)/)
        .lex('KW_ASYNC', /async/)
        .lex('ID', /[a-z]+/)
        .scan("main () async {}");
        console.log(tokens);
     */
    var lexer = new reji.Lexer(debug: true)
      ..skip(WHITESPACE)
      ..lex("CURLY_L", "{")
      ..lex("CURLY_R", "}")
      ..lex("PAREN_L", r"\(")
      ..lex("PAREN_R", r"\)")
      ..lex("KW_ASYNC", "async")
      ..lex("ID", "[A-Za-z][A-Za-z0-9_]*")
      ..scan("main () async {}");

    List<reji.Token> tokens = await lexer.tokenStream.toList();
    print(tokens);
  });
}
