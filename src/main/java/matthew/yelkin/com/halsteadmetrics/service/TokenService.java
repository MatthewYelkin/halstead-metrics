package matthew.yelkin.com.halsteadmetrics.service;

import lombok.Getter;
import lombok.SneakyThrows;
import matthew.yelkin.com.halsteadmetrics.jflex.Lexer;
import matthew.yelkin.com.halsteadmetrics.jflex.Token;
import matthew.yelkin.com.halsteadmetrics.jflex.TokenType;
import org.springframework.stereotype.Service;

import java.io.StringReader;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;

@Getter
@Service
public class TokenService {
    private static final List<TokenType> operatorTokens = List.of(
            TokenType.WHILE,
            TokenType.CONTINUE,
            TokenType.FUNCTION,
            TokenType.FOR,
            TokenType.SWITCH,
            TokenType.CONTAINS,
            TokenType.BITWISE,
            TokenType.ARITHMETIC,
            TokenType.LOGICAL,
            TokenType.WHERE,
            TokenType.IF,
            TokenType.IN,
            TokenType.BREAK,
            TokenType.AS,
            TokenType.ASSIGN,
            TokenType.COLON,
            TokenType.DOT,
            TokenType.L_BRACKET,
            TokenType.L_PAREN,
            TokenType.L_FIGURE,
            TokenType.DO,
            TokenType.QUESTION,
            TokenType.COLON,
            TokenType.RANGE,
            TokenType.TRY,
            TokenType.RETURN,
            TokenType.SEMICOLON,
            TokenType.COMMA,
            TokenType.INIT
    );

    private static final List<TokenType> operandTokens = List.of(
            TokenType.IDENTIFIER,
            TokenType.NUMBER,
            TokenType.DATA_TYPE,
            TokenType.STRING,
            TokenType.BOOL
    );

    private final HashMap<String, Integer> operands = new HashMap<>();
    private final HashMap<String, Integer> operators = new HashMap<>();

    @SneakyThrows
    public void analyzeCode(String code) {
        List<Token> tokens = new Lexer(new StringReader(code)).yylex();

        operands.clear();
        operators.clear();

        int parenToRemove = 0;
        int colonToRemove = 0;
        int figureToRemove = 0;

        for (Token token : tokens) {
            var tokenType = token.getTokenType();
            var text = token.getTextValue();

            switch (tokenType) {
                case CASE, DEFAULT, QUESTION -> colonToRemove++;
                case FUNC -> { parenToRemove++; figureToRemove++; }
                case CLASS, IF, SWITCH, WHILE, FOR, INIT, ELSE, ELIF -> figureToRemove++;
            }

            if (operandTokens.contains(tokenType)) {
                if (operands.containsKey(text)) {
                    operands.put(text, operands.get(text) + 1);
                } else {
                    operands.put(text, 1);
                }
            } else if (operatorTokens.contains(tokenType)) {
                switch (tokenType) {
                    case FUNCTION -> {
                        text += "()";
                        parenToRemove++;
                    }
                    case L_BRACKET -> text += "]";
                    case L_FIGURE -> text += "}";
                    case L_PAREN -> text += ")";
                    case QUESTION -> text += ":";
                }

                if (operators.containsKey(text)) {
                    operators.put(text, operators.get(text) + 1);
                } else {
                    operators.put(text, 1);
                }
            }
        }

        if (parenToRemove != 0) {
            int count = operators.get("()") - parenToRemove;
            if (count > 0)
                operators.put("()", count);
            else
                operators.remove("()");
        }

        if (figureToRemove != 0) {
            int count = operators.get("{}") - figureToRemove;
            if (count > 0)
                operators.put("{}", count);
            else
                operators.remove("{}");
        }

        if (colonToRemove != 0) {
            int count = operators.get(":") - colonToRemove;
            if (count > 0)
                operators.put(":", count);
            else
                operators.remove(":");
        }
    }
}
