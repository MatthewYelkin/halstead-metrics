package matthew.yelkin.com.halsteadmetrics.model;

import lombok.Getter;

import java.util.HashMap;

@Getter
public class Metrics {
    private final int countOfOperands;
    private final int countOfOperators;
    private final int programLength;
    private final int countOfUniqueOperands;
    private final int countOfUniqueOperators;
    private final int programMap;
    private final int volume;


    public Metrics(HashMap<String, Integer> operands, HashMap<String, Integer> operators) {
        countOfUniqueOperands = operands.size();
        countOfUniqueOperators = operators.size();
        programMap = countOfUniqueOperands + countOfUniqueOperators;

        countOfOperands = operands.values().stream().mapToInt(v -> v).sum();
        countOfOperators = operators.values().stream().mapToInt(v -> v).sum();
        programLength = countOfOperands + countOfOperators;

        volume = (int) Math.round(programLength * Math.log(programMap) / Math.log(2));
    }
}
