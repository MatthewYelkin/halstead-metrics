package matthew.yelkin.com.halsteadmetrics.controller;

import lombok.RequiredArgsConstructor;
import matthew.yelkin.com.halsteadmetrics.service.TokenServiceForHalstead;
import matthew.yelkin.com.halsteadmetrics.service.TokenServiceForJilb;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
@RequiredArgsConstructor
public class MainController {
    private final TokenServiceForHalstead tokenServiceForHalstead;
    private final TokenServiceForJilb tokenServiceForJilb;

    @GetMapping("/halstead-metrics")
    public String getHalsteadPage() {
        return "halsteadMetrics";
    }

    @PostMapping("/halstead-metrics")
    public String getHalsteadPage(@RequestParam(value = "code") String code, Model model) {
        tokenServiceForHalstead.analyzeCode(code);

        model.addAttribute("code", code);
        model.addAttribute("operands", tokenServiceForHalstead.getOperands()
                .entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed()));
        model.addAttribute("operators", tokenServiceForHalstead.getOperators()
                .entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed()));
        model.addAttribute("metrics", tokenServiceForHalstead.getMetrics());

        return getHalsteadPage();
    }

    @GetMapping("/jilb-metrics")
    public String getJilbPage() {
        return "jilbMetrics";
    }

    @PostMapping("/jilb-metrics")
    public String getJilbPage(@RequestParam(value = "code") String code, Model model) {
        tokenServiceForJilb.analyzeCode(code);

        model.addAttribute("code", code);
        model.addAttribute("conditionalOperatorsCount", tokenServiceForJilb.getConditionalOperatorsCount());
        model.addAttribute("operatorsCount", tokenServiceForJilb.getOperatorsCount());
        model.addAttribute("maxNestingLevel", tokenServiceForJilb.getMaxNestingLevel());
        model.addAttribute("difficulty", String.format("%.4f", tokenServiceForJilb.getConditionalOperatorsCount() / (float) tokenServiceForJilb.getOperatorsCount()));

        return getJilbPage();
    }
}
