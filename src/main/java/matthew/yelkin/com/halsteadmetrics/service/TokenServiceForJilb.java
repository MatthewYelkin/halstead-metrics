package matthew.yelkin.com.halsteadmetrics.service;

import lombok.Getter;
import lombok.SneakyThrows;
import matthew.yelkin.com.halsteadmetrics.jflex.Lexer;
import matthew.yelkin.com.halsteadmetrics.jflex.Token;
import matthew.yelkin.com.halsteadmetrics.jflex.TokenType;
import org.springframework.stereotype.Service;

import java.io.StringReader;
import java.util.List;

@Getter
@Service
public class TokenServiceForJilb {
    private static final List<TokenType> conditionalOperators = List.of(
            TokenType.WHILE,
            TokenType.FOR,
            TokenType.IF,
            TokenType.SWITCH,
            TokenType.DO
    );

    private static final List<TokenType> operatorTokens = List.of(
            TokenType.WHILE,
            TokenType.CONTINUE,
            TokenType.FUNCTION,
            TokenType.FOR,
            TokenType.SWITCH,
            TokenType.CONTAINS,
            TokenType.LOGICAL,
            TokenType.WHERE,
            TokenType.IF,
            TokenType.BREAK,
            TokenType.ASSIGN,
            TokenType.DO,
            TokenType.RETURN
    );

    private int operatorsCount;
    private int conditionalOperatorsCount;
    private int maxNestingLevel;

    @SneakyThrows
    public void analyzeCode(String code) {
        List<Token> tokens = new Lexer(new StringReader(code)).yylex();

        operatorsCount = 0;
        conditionalOperatorsCount = 0;
        maxNestingLevel = 0;

        int currNestingLevel = 0;

        for (Token token : tokens) {
            if (operatorTokens.contains(token.getTokenType())) {
                operatorsCount++;
            }

            if (conditionalOperators.contains(token.getTokenType())) {
                conditionalOperatorsCount++;
            }

            if (TokenType.L_FIGURE == token.getTokenType()) {
                currNestingLevel++;

                if (maxNestingLevel < currNestingLevel) {
                    maxNestingLevel++;
                }
            } else if (TokenType.R_FIGURE == token.getTokenType()) {
                currNestingLevel--;
            }
        }
    }
}
