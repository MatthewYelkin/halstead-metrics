package matthew.yelkin.com.halsteadmetrics.jflex;

import java.util.ArrayList;

%%

%class Lexer
%type ArrayList
%public
%unicode

%{
    ArrayList<Token> list = new ArrayList<>();

    private void newToken(Token token) {
        list.add(token);
    }
%}

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment} | {DocumentationComment}

TraditionalComment   = "/*" [^*] ~"*/" | "/*" "*"+ "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "//" {InputCharacter}* {LineTerminator}?
DocumentationComment = "/**" {CommentContent} "*"+ "/"
CommentContent       = ( [^*] | \*+ [^/*] )*

Identifier = [:jletter:] [:jletterdigit:]*
DataType = "Int" | "String" | "Character" | "Float" | "Double" | "Bool"
AccessModifier = "open" | "fileprivate" | "internal" | "public" | "private"

DecIntegerLiteral = "0" | [1-9][0-9]*
DecFloatLiteral = [0-9]+ "." [0-9]+
StringLiteral = "\"" .* "\""

%%

<YYINITIAL> {
  /* keywords */
  "break"              { newToken(Token.BREAK); }
  "return"             { newToken(Token.RETURN); }
  "switch"             { newToken(Token.SWITCH); }
  "case"               { newToken(Token.CASE); }
  "default"            { newToken(Token.DEFAULT); }
  "if"                 { newToken(Token.IF); }
  "else"               { newToken(Token.ELSE); }
  "repeat"             { newToken(Token.REPEAT); }
  "while"              { newToken(Token.WHILE); }
  "in"                 { newToken(Token.IN); }
  "where"              { newToken(Token.WHERE); }
  "for"                { newToken(Token.FOR); }
  "from"               { newToken(Token.FROM); }
  "question"           { newToken(Token.QUESTION); }
  "as"                 { newToken(Token.AS); }
  "do"                 { newToken(Token.DO); }
  "fallthrough"        { newToken(Token.FALLTHROUGH); }
  "class"              { newToken(Token.CLASS); }
  "deinit"             { newToken(Token.DEINIT); }
  "enum"               { newToken(Token.DEFAULT); }
  "extension"          { newToken(Token.EXTENSION); }
  "func"               { newToken(Token.FUNC); }
  "import"             { newToken(Token.IMPORT); }
  "init"               { newToken(Token.INIT); }
  "let"                { newToken(Token.LET); }
  "protocol"           { newToken(Token.PROTOCOL); }
  "static"             { newToken(Token.STATIC); }
  "struct"             { newToken(Token.STRUCT); }
  "subscript"          { newToken(Token.SUBSCRIPT); }
  "typealias"          { newToken(Token.TYPEALIAS); }
  "var"                { newToken(Token.VAR); }

  "true" | "false"               { newToken(Token.BOOL) ; }


  /* Access Modifiers */
  {AccessModifier}               { newToken(Token.ACCESS_MODIFIER); }

  /* Data Types */
  {DataType}                     { newToken(Token.DATA_TYPE); }

  /* identifiers */
  {Identifier}                   { newToken(Token.IDENTIFIER); }

  /* literals */
  {DecFloatLiteral}              { newToken(Token.NUMBER); }
  {DecIntegerLiteral}            { newToken(Token.NUMBER); }
  {StringLiteral}                { newToken(Token.STRING); }

  /* operators */
  "<="                           { newToken(Token.LESS_EQ); }
  ">="                           { newToken(Token.MORE_EQ); }
  "="                            { newToken(Token.ASSIGN); }
  "==="                          { newToken(Token.EQEQ); }
  "=="                           { newToken(Token.EQ); }
  "!="                           { newToken(Token.NOT_EQ); }
  "+"                            { newToken(Token.PLUS); }
  "-"                            { newToken(Token.MINUS); }
  "*"                            { newToken(Token.MULT); }
  "/"                            { newToken(Token.DIVIDE); }
  "%"                            { newToken(Token.PERCENT); }
  "<<"                           { newToken(Token.L_SHIFT); }
  ">>"                           { newToken(Token.R_SHIFT); }
  "<"                            { newToken(Token.LESS); }
  ">"                            { newToken(Token.MORE); }
  "&&"                           { newToken(Token.AND); }
  "^"                            { newToken(Token.XOR); }
  "||"                           { newToken(Token.OR); }

  ";"                            { newToken(Token.SEMICOLON); }
  "{"                            { newToken(Token.L_FIGURE); }
  "}"                            { newToken(Token.R_FIGURE); }
  "("                            { newToken(Token.L_PAREN); }
  ")"                            { newToken(Token.R_PAREN); }
  "."                            { newToken(Token.DOT); }
  "["                            { newToken(Token.L_BRACKET); }
  "]"                            { newToken(Token.R_BRACKET); }
  ";"                            { newToken(Token.SEMICOLON); }
  ","                            { newToken(Token.COMMA); }
  ":"                            { newToken(Token.COLON); }
  "...<"                         { newToken(Token.ELLIPSIS_LESS); }
  "..."                          { newToken(Token.ELLIPSIS); }
  "->"                           { newToken(Token.RETURN_TYPE); }
  "?"                            { newToken(Token.QUESTION); }

  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  <<EOF>>                        { return list; }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }