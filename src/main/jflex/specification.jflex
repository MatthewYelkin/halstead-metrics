package matthew.yelkin.com.halsteadmetrics.jflex;

import java.util.LinkedList;

%%

%class Lexer
%type LinkedList<Token>
%public
%unicode

%{
    LinkedList<Token> list = new LinkedList<>();

    private void newToken(TokenType tokenType) {
        list.add(new Token(tokenType, yytext()));
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]


Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*
DataType = "Int" | "String" | "Character" | "Float" | "Double" | "Bool"
AccessModifier = "open" | "fileprivate" | "internal" | "public" | "private"

ComparisonOperators1 = "!==" | "!="
LogicalOperators = "&&" | "||" | "!"
BitwiseOperators = "^" | "|" | "&" | "~" | "<<" | ">>"
ComparisonOperators2 = "<=" | ">=" | "===" | "==" | ">" | "<"
AssignmentOperators = "=" | "+=" | "-=" | "*=" | "/=" | "%="
ArithmeticOperators = "+" | "-" | "*" | "/" | "%"
RangeOperators = "...<" | "..."

DecIntegerLiteral = "0" | [1-9][0-9]*
DecFloatLiteral = [0-9]+ "." [0-9]+
StringLiteral = "\"" [^"\""]* "\""

%%

<YYINITIAL> {
  /* keywords */
  "break"                        { newToken(TokenType.BREAK); }
  "return"                       { newToken(TokenType.RETURN); }
  "switch"                       { newToken(TokenType.SWITCH); }
  "case"                         { newToken(TokenType.CASE); }
  "default"                      { newToken(TokenType.DEFAULT); }
  "if"                           { newToken(TokenType.IF); }
  "else if"                      { newToken(TokenType.ELIF); }
  "else"                         { newToken(TokenType.ELSE); }
  "repeat"                       { newToken(TokenType.REPEAT); }
  "while"                        { newToken(TokenType.WHILE); }
  "init("                         { newToken(TokenType.INIT); }
  "in"                           { newToken(TokenType.IN); }
  "where"                        { newToken(TokenType.WHERE); }
  "for"                          { newToken(TokenType.FOR); }
  "from"                         { newToken(TokenType.FROM); }
  "question"                     { newToken(TokenType.QUESTION); }
  "as"                           { newToken(TokenType.AS); }
  "at"                           { newToken(TokenType.AT); }
  "do"                           { newToken(TokenType.DO); }
  "fallthrough"                  { newToken(TokenType.FALLTHROUGH); }
  "class" {WhiteSpace}+ {Identifier} { newToken(TokenType.CLASS); }
  "deinit"                       { newToken(TokenType.DEINIT); }
  "enum"                         { newToken(TokenType.DEFAULT); }
  "extension"                    { newToken(TokenType.EXTENSION); }
  "func" {WhiteSpace}+ {Identifier} { newToken(TokenType.FUNC); }
  "import" {WhiteSpace}+ {Identifier} { newToken(TokenType.IMPORT); }
  "let"                          { newToken(TokenType.LET); }
  "protocol"                     { newToken(TokenType.PROTOCOL); }
  "static"                       { newToken(TokenType.STATIC); }
  "struct"                       { newToken(TokenType.STRUCT); }
  "subscript"                    { newToken(TokenType.SUBSCRIPT); }
  "typealias"                    { newToken(TokenType.TYPEALIAS); }
  "var"                          { newToken(TokenType.VAR); }
  "try"                          { newToken(TokenType.TRY); }
  "catch"                        { newToken(TokenType.CATCH); }

  "true" | "false"               { newToken(TokenType.BOOL) ; }


  /* Access Modifiers */
  {AccessModifier}               { newToken(TokenType.ACCESS_MODIFIER); }

  /* Data Types */
  {DataType}                     { newToken(TokenType.DATA_TYPE); }

  {Identifier}/"("               { newToken(TokenType.FUNCTION); }

  /* identifiers */
  {Identifier}                   { newToken(TokenType.IDENTIFIER); }

  /* literals */
  {DecFloatLiteral}              { newToken(TokenType.NUMBER); }
  {DecIntegerLiteral}            { newToken(TokenType.NUMBER); }
  {StringLiteral}                { newToken(TokenType.STRING); }

  /* operators */
  {ComparisonOperators1}         { newToken(TokenType.COMPARISON); }
  {LogicalOperators}             { newToken(TokenType.LOGICAL); }
  {BitwiseOperators}             { newToken(TokenType.BITWISE); }
  {ComparisonOperators2}         { newToken(TokenType.COMPARISON); }
  {AssignmentOperators}          { newToken(TokenType.ASSIGN); }
  {ArithmeticOperators}          { newToken(TokenType.ARITHMETIC); }
  {RangeOperators}               { newToken(TokenType.RANGE); }

  ";"                            { newToken(TokenType.SEMICOLON); }
  "{"                            { newToken(TokenType.L_FIGURE); }
  "}"                            { newToken(TokenType.R_FIGURE); }
  "("                            { newToken(TokenType.L_PAREN); }
  ")"                            { newToken(TokenType.R_PAREN); }
  "."                            { newToken(TokenType.DOT); }
  "["                            { newToken(TokenType.L_BRACKET); }
  "]"                            { newToken(TokenType.R_BRACKET); }
  ";"                            { newToken(TokenType.SEMICOLON); }
  ","                            { newToken(TokenType.COMMA); }
  ":"                            { newToken(TokenType.COLON); }
  "->"                           { newToken(TokenType.RETURN_TYPE); }
  "?"                            { newToken(TokenType.QUESTION); }

  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  <<EOF>>                        { return list; }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }