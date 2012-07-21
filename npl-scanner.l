/* A simple scanner for NPL */

%{
    #include "npl-to-wshark.h"

    #define MAX_STR_CONST 81

    char string_buf[MAX_STR_CONST];
    char *string_buf_p;
    int lineno = 0; 

%}

%option reentrant
%option noyywrap

%x SINGLE_QUOTED
%x DOUBLE_QUOTED

%%
    // This string handling stuff needs extending
["]        { BEGIN(DOUBLE_QUOTED); string_buf_p = string_buf; }

<DOUBLE_QUOTED>[^"] {
	char *yptr = yytext;
	while (*yptr)
		*string_buf_p++ = *yptr++;
}
<DOUBLE_QUOTED>["]  { BEGIN(INITIAL); *string_buf_p = '\0'; return STRING; }
<DOUBLE_QUOTED><<EOF>> { return -1; }

"//".*$     {}

[ \r\t] {}

"="        { string_buf[0] = '\0'; return EQUAL; }

"Protocol" { string_buf[0] = '\0'; return PROTOCOL; }

"AsciiString" { string_buf[0] = '\0'; return ASCIISTRING; }

"FormatString" { string_buf[0] = '\0'; return FORMATSTRING; }

"UINT8"    { string_buf[0] = '\0'; return UINT8; }

"UINT16"   { string_buf[0] = '\0'; return UINT16; }

"UINT32"   { string_buf[0] = '\0'; return UINT32; }

"UINT64"   { string_buf[0] = '\0'; return UINT64; }

"{"        { string_buf[0] = '\0'; return LBRACE; }

"}"	   { string_buf[0] = '\0'; return RBRACE; }

";"        { string_buf[0] = '\0'; return SEMICOLON; }

"["	   { string_buf[0] = '\0'; return LBRACK; }

"]"	   { string_buf[0] = '\0'; return RBRACK; }

"("	   { string_buf[0] = '\0'; return LPAREN; }

")"	   { string_buf[0] = '\0'; return RPAREN; }

","	   { string_buf[0] = '\0'; return COMMA; }

[a-zA-Z_][a-zA-Z0-9_]+ { 

	string_buf_p = string_buf;
	char *yptr = yytext;
	while (*yptr)
		*string_buf_p++ = *yptr++;
	*string_buf_p = '\0';

	return NAME; }

[1-9][0-9]+ { 

	string_buf_p = string_buf;
	char *yptr = yytext;
	while (*yptr)
		*string_buf_p++ = *yptr++;
	*string_buf_p = '\0';

	return NUMBER; }

"0x"[0-9a-fA-F]+ { 

	string_buf_p = string_buf;
	char *yptr = yytext;
	while (*yptr)
		*string_buf_p++ = *yptr++;
	*string_buf_p = '\0';

	return HEXNUM; }

\n         { lineno++; }

%%

