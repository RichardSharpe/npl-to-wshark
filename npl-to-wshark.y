%include
{
    #include <cassert>
    #include <iostream>
}

%extra_argument { void *state }

%token_type {const char *}

%syntax_error { std::cerr << "Error parsing protocol\n"; }

%left NAME STRING NUMBER HEXNUM .
%left COMMA .

definitions ::= entries .

entries ::= entries entry .

entries ::= .

entry ::= protocol .

entry ::= struct .

struct ::= STRUCT NAME def_string .

protocol ::= register_clause proto_clause .
{

}

protocol ::= proto_clause .
{

}

proto_clause ::= PROTOCOL NAME def_string .
{

}

proto_clause ::= PROTOCOL NAME EQUAL format_string def_string .
{

}

register_clause ::= LBRACK REGISTERAFTER params_list RBRACK .

register_clause ::= LBRACK REGISTERBEFORE params_list RBRACK .

def_string ::= LBRACE def_list RBRACE .

def_list ::= def_list def_item .

def_list ::= .

string_expr ::= .

string_expr ::= string_expr STRING .

string_expr ::= string_expr STRING PLUS .

format_string ::= FORMATSTRING LPAREN params_list RPAREN .

format_string ::= string_expr .

format_string_expr ::= .

format_string_expr ::= EQUAL format_string .

array_spec ::= .

array_spec ::= LBRACK array_size RBRACK .

def_item ::= STRUCT def_string .

def_item ::= struct .

def_item ::= data_type NAME array_spec format_string_expr SEMICOLON .

array_size ::= NAME .

array_size ::= number_type .

data_type ::= UINT8 .

data_type ::= UINT16 .

data_type ::= UINT32 .

data_type ::= UINT64 .

def_item ::= ASCIISTRING RPAREN NUMBER LPAREN NAME SEMICOLON .

number_type ::= NUMBER .

number_type ::= HEXNUM .

params_list ::= params_list COMMA param_item .

params_list ::= param_item .

param_item ::= NAME .

param_item ::= STRING .

param_item ::= number_type .
