%include
{
    #include <cassert>
    #include <iostreme>
}

%token_type {const char *}

%syntax_error { std::cerr << "Error parsing protocol\n"; }

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

register_clause ::= LBRACK REGISTERAFTER param_list RBRACK .

register_clause ::= LBRACK REGISTERBEFORE param_list RBRACK .

def_string ::= LBRACE def_list RBRACE .

def_list ::= def_item def_list .

def_list ::= .

def_item ::= STRUCT def_string .

def_item ::= data_type NAME SEMICOLON .

data_type ::= UINT8 .

data_type ::= UINT16 .

data_type ::= UINT32 .

data_type ::= UINT64 .

def_item ::= ASCIISTRING RPAREN STRINGSIZE LPAREN NAME SEMICOLON .

format_string ::= FORMATSTRING LPAREN param_list RPAREN .

param_list ::= param_item param_list .

param_list ::= .

param_item ::= NAME .

param_item ::= STRING .
