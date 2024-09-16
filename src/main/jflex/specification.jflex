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

DecIntegerLiteral = 0 | [1-9][0-9]*
DecFloatLiteral = [0-9]* "." [0-9]*
StringLiteral = "\"" .* "\""

%%

/* keywords */
<YYINITIAL> "break"              { newToken(Token.BREAK); }
<YYINITIAL> "return"             { newToken(Token.RETURN); }

<YYINITIAL> {
  /* identifiers */
  {Identifier}                   { newToken(Token.IDENTIFIER); }

  /* literals */
  {DecFloatLiteral}
  {DecIntegerLiteral}            { newToken(Token.NUMBER); }
  {StringLiteral}                { newToken(Token.STRING); }

  /* operators */
  "="                            { newToken(Token.ASSIGN); }
  "=="                           { newToken(Token.EQ); }
  "+"                            { newToken(Token.PLUS); }
  ";"                            { newToken(Token.SEMICOLON); }
  "{"                            { newToken(Token.L_FIGURE); }
  "}"                            { newToken(Token.R_FIGURE); }
  "("                            { newToken(Token.L_PAREN); }
  ")"                            { newToken(Token.R_PAREN); }

  /* comments */
  {Comment}                      { /* ignore */ }

  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }

  <<EOF>>                        { return list; }
}

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
                                                    yytext()+">"); }