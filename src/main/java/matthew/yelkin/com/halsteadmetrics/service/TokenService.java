package matthew.yelkin.com.halsteadmetrics.service;

import matthew.yelkin.com.halsteadmetrics.jflex.Lexer;
import org.springframework.stereotype.Service;

import java.io.FileReader;
import java.io.IOException;


@Service
public class TokenService {
    Lexer lexer = new Lexer(new FileReader("C:\\Users\\ivank\\IdeaProjects\\halstead-metrics\\src\\main\\resources\\example.txt"));

    public TokenService() throws IOException {
        System.out.println(lexer.yylex());
    }
}
