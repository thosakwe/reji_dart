library reji.lexer;

import 'dart:async';
import 'shared.dart';

final RegExp rgxExpand = new RegExp("<%([^%]+)%>");

class Lexer {
  bool debug;
  StreamController<Token> _tokenStream = new StreamController<Token>();

  Stream<Token> get tokenStream => _tokenStream.stream;

  List<TokenType> tokenTypes = [];
  List<TokenType> tokenTypesToSkip = [];

  Map<TokenType, MatchFilter> filters = {};
  Map<TokenType, MatchFilter> skipFilters = {};

  Lexer({bool this.debug: false});

  TokenType lex(String name, Pattern spec, [MatchFilter filter]) {
    TokenType tokenType = new TokenType(name.trim(), spec);

    if (filter != null) filters[tokenType] = filter;

    tokenTypes.add(tokenType);
    return tokenType;
  }

  TokenType skip(Pattern spec, {MatchFilter filter, String name: "[SKIPPED]"}) {
    TokenType tokenType = new TokenType(name.trim(), spec);

    if (filter != null) skipFilters[tokenType] = filter;

    tokenTypes.add(tokenType);
    tokenTypesToSkip.add(tokenType);
    return tokenType;
  }

  void _expandRules() {
    for (TokenType tokenType in tokenTypes) {
      if (tokenType.spec is String) {
        String spec = tokenType.spec;

        if (debug) {
          print("Expanding lexer rulespec: $spec");
        }

        for (Match match in rgxExpand.allMatches(tokenType.spec)) {
          if (debug) {
            print("Found child rule: ${match[1]}");
          }

          TokenType ref =
          tokenTypes.firstWhere((TokenType type) => type.name == match[1]);

          if (ref == null)
            throw new Exception(
                "Cannot reference nonexistent lexer rule: ${match[1]}");
          if (ref.matcher == null)
            throw new Exception(
                "Cannot reference lexer rule ${match[1]} before it is declared.");

          RegExp matcher = ref.matcher;
          String expression =
          matcher.pattern.replaceAll(new RegExp(r"(\^)|(\$)"), "");

          // TODO: Maybe make this a named group?
          spec = spec.replaceAll(match[0], "(${expression})");

          if (debug) {
            print("Updated rulespec: $spec");
          }
        }

        tokenType.matcher = new RegExp(spec);
      } else if (tokenType.spec is RegExp) {
        tokenType.matcher = tokenType.spec;
      } else
        throw new Exception(
            "Reji can only tokenize input based on strings and regular expressions. " +
                "You have provided a ${tokenType.spec.runtimeType}");
    }
  }

  void scan(String input) {
    _expandRules();
    String str = input;

    if (debug) {
      print("Now tokenizing: $str");
    }

    while (str.length > 0) {
      for (TokenType tokenType in tokenTypes) {
        MatchFilter filter = filters[tokenType];
        MatchFilter skipFilter = skipFilters[tokenType];
        Match match = tokenType.matcher.firstMatch(str);

        if (match != null) {
          bool canTokenize = true;

          if (debug) {
            print("Found $tokenType");
          }

          if (tokenTypesToSkip.contains(tokenType)) {
            canTokenize = false;

            if (skipFilter != null)
              canTokenize = !skipFilter(match);
          } else if (filter != null) canTokenize = filter(match);

          if (canTokenize) {
            Token token = new Token(tokenType, match);

            if (tokenType.transformer != null)
              token.value = tokenType.transformer(token);

            _tokenStream.add(token);

            str = str.substring(match[0].length);
          }
        }
      }
    }

    _tokenStream.close();
  }
}
