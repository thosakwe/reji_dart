library reji.shared;

typedef bool MatchFilter(Match match);
typedef dynamic TokenTransformer(Token token);

class TokenType {
  final String name;
  RegExp matcher;
  Pattern spec;
  TokenTransformer transformer;

  TokenType(String this.name, Pattern this.spec);

  then(TokenTransformer transformer) {
    this.transformer = transformer;
  }

  @override
  String toString() => "<%$name%>";
}

class Token {
  int line;
  int indexInLine;
  final Match match;
  final TokenType type;
  var value;

  String get text => match[0];

  Token(TokenType this.type, Match this.match,
      {int this.line: 1, int this.indexInLine: 0});

  @override
  String toString() =>
      '{"type": "${type.name}","text":"$text","value":$value,' +
      '"line":$line,"indexLine":$indexInLine}';
}

class ParseTreeType {}

class ParseTree {}
