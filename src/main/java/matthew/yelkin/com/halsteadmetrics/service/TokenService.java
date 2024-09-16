package matthew.yelkin.com.halsteadmetrics.service;

import matthew.yelkin.com.halsteadmetrics.jflex.Lexer;
import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.io.IOException;


@Service
public class TokenService {
    Lexer lexer = new Lexer(new FileReader("E:\\5 sem\\Метрология\\Задание№1_Метрики_Холстеда\\java\\halstead-metrics\\src\\main\\java\\1.txt"));

    public TokenService() throws IOException {
        System.out.println(lexer.yylex());
    }
}
