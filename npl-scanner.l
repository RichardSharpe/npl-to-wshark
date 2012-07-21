/* A simple scanner for NPL */

%{
    #include <limits.h>
    #include "npl-to-wshark.h"

    #define MAX_STR_CONST 81

    char include_name[PATH_MAX + 1];
    char string_buf[MAX_STR_CONST];
    char *string_buf_p;
    int lineno = 1; 

%}

%option reentrant
%option noyywrap

%x SINGLE_QUOTED
%x DOUBLE_QUOTED
%x include

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

    /* Include file handling done here */

^include   { BEGIN(include); }

<include>[ \t]*       { /* eat white space */ }

<include>[^ \t]+$     { /* Got the include file name, could be quoted */
	
		BEGIN(INITIAL);
	}

    /* Unwind include file */
<<EOF>> {
		yypop_buffer_state(yyscanner);
		if (!YY_CURRENT_BUFFER) {
			yyterminate();
		}
	}

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

