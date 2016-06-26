library reji.parser;

import 'dart:async';
import 'shared.dart';

class Parser implements StreamTransformer<Token, ParseTree> {
	StreamController<ParseTree> _ast = new StreamController<ParseTree>();

	Stream<ParseTree> bind(Stream<Token> tokenStream) {
		tokenStream.listen(parse);
		return _ast.stream;
	}

	parse(Token token) {
		
	}
}