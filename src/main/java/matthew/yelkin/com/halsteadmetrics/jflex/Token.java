package matthew.yelkin.com.halsteadmetrics.jflex;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Token {
    /**
     * Тип токена
     */
    private TokenType tokenType;

    /**
     * Значение
     */
    private String textValue;
}
