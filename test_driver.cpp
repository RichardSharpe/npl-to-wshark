// A simple driver for the scanner and possibly the parser
//
#include <cstdlib>
#include <iostream>
#include <string>
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include "npl-scanner.yy.h"
#include "npl-to-wshark.h"

using namespace std;

extern "C" char string_buf[];
extern "C" int lineno;

void *ParseAlloc(void *(*AllocProc)(size_t));
void *Parse(void *, int, const char *, void *);
void *ParseFree(void *, void (*FreeProc)(void *));

int main(int argc, char *argv[])
{
	yyscan_t scanner;
	string inputLine;

	yylex_init(&scanner);

	if (argc > 1) {
		FILE *infile = fopen(argv[1], "r");
		if (!infile) {
			cout << "Unable to open \"" << argv[1] << "\": "
			     << strerror(errno) << "\n";
			return 1;
		}

		yyset_in(infile, scanner);
	}

	void *Parser = ParseAlloc(malloc);

	int lexcode;
	while ((lexcode = yylex(scanner)) > 0) {

		cout << "Line: " << lineno << " LexVal = " << lexcode << " ";
		switch (lexcode) {
                case EQUAL:
			cout << "LexCode = EQUAL\n";
			break;

		case PROTOCOL:
			cout << "LexCode = PROTOCOL\n";
			break;

		case UINT8:
			cout << "LexCode = UINT8\n";
			break;

		case UINT16:
			cout << "LexCode = UINT16\n";
			break;

		case UINT32:
			cout << "LexCode = UINT32\n";
			break;

		case UINT64:
			cout << "LexCode = UINT64\n";
			break;

		case NAME:
			cout << "LexCode = NAME: " 
			     << string_buf << "\n";
			break;

		case REGISTERAFTER:
			cout << "LexCode = REGISTERAFTER\n";
			break;

		case REGISTERBEFORE:
			cout << "LexCode = REGISTERBEFORE\n";
			break;

		case STRING:
			cout << "LexCode = STRING: " 
			     << string_buf << "\n";
			break;

		case ASCIISTRING:
			cout << "LexCode = ASCIISTRING\n";
			break;

		case FORMATSTRING:
			cout << "LexCode = FORMATSTRING\n";
			break;

		case NUMBER:
			cout << "LexCode = NUMBER: " 
			     << string_buf << "\n";
			break;

		case HEXNUM:
			cout << "LexCode = HEXNUM: " 
			     << string_buf << "\n";
			break;

		case STRUCT:
			cout << "LexCode = STRUCT\n";
			break;

		case RPAREN:
			cout << "LexCode = RPAREN\n";
			break;

		case LPAREN:
			cout << "LexCode = LPAREN\n";
			break;

		case COMMA:
			cout << "LexCode = COMMA\n";
			break;

		case LBRACE:
			cout << "LexCode = LBRACE\n";
			break;

		case RBRACE:
			cout << "LexCode = RBRACE\n";
			break;

		case LBRACK:
			cout << "LexCode = LBRACK\n";
			break;

		case RBRACK:
			cout << "LexCode = RBRACK\n";
			break;

		case SEMICOLON:
			cout << "LexCode = SEMICOLON\n";
			break;

		case PLUS:
			cout << "Lexcode = PLUS\n";
			break;

		default:
			cout << "LexCode = " << lexcode << "\n";

		};

		if (lexcode == -1) {
			cerr << "The scanner encountered an error.\n";
		}

		// Parse it
		Parse(Parser, lexcode, string_buf, NULL);
	}

	Parse(Parser, 0, string_buf, NULL);

	ParseFree(Parser, free);

	yylex_destroy(scanner);
}
