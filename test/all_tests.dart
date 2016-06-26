import 'package:test/test.dart';
import 'lexer/all_tests.dart' as lexer;
import 'parser/all_tests.dart' as parser;

main() {
	group('lexer', lexer.main);
	group('parser', parser.main);
}
