package net.datasa.yomakase_web.controller;

import lombok.extern.slf4j.Slf4j;
import net.datasa.yomakase_web.domain.dto.MemberDTO;
import net.datasa.yomakase_web.security.AuthenticatedUser;
import net.datasa.yomakase_web.service.MemberService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Slf4j
@Controller
public class MemberController {

    private final MemberService memberService;

    public MemberController(MemberService memberService) {
        this.memberService = memberService;
    }

    // 회원가입 폼을 보여주는 메소드
    @GetMapping("signupForm")
    public String signupForm() {
        return "signupForm";
    }

    // 회원가입 폼 제출을 처리하는 메소드
    @PostMapping("signupForm")
    public String join(@ModelAttribute("member") MemberDTO dto,
                       @RequestParam(value = "allergies", required = false) List<String> allergies) {

        // 알레르기 정보 매핑
        if (allergies != null) {
            dto.setEggs(allergies.contains("egg"));
            dto.setMilk(allergies.contains("milk"));
            dto.setBuckwheat(allergies.contains("buckwheat"));
            dto.setPeanut(allergies.contains("peanut"));
            dto.setSoybean(allergies.contains("soy"));
            dto.setWheat(allergies.contains("wheat"));
            dto.setMackerel(allergies.contains("mackerel"));
            dto.setCrab(allergies.contains("crab"));
            dto.setShrimp(allergies.contains("shrimp"));
            dto.setPork(allergies.contains("pork"));
            dto.setPeach(allergies.contains("peach"));
            dto.setTomato(allergies.contains("tomato"));
            dto.setWalnuts(allergies.contains("walnut"));
            dto.setChicken(allergies.contains("chicken"));
            dto.setBeef(allergies.contains("beef"));
            dto.setSquid(allergies.contains("squid"));
            dto.setShellfish(allergies.contains("shellfish"));
            dto.setPineNut(allergies.contains("pineNut"));
        }

        log.debug("전달된 회원정보: {}", dto);
        memberService.saveMember(dto);
        return "redirect:/";
    }


    // ID 중복 확인 폼을 보여주는 메소드
    @GetMapping("/idCheck")
    public String idCheck() {
        return "idCheck";
    }

    // ID 중복 확인 요청 처리
    @PostMapping("idCheck")
    @ResponseBody
    public String idChecked(@RequestParam("searchId") String searchId) {
        boolean result = memberService.find(searchId);

        // 중복 여부에 따라 메시지 반환
        if (result) {
            return searchId + "은(는) 사용가능한 ID입니다.";
        } else {
            return searchId + "은(는) 이미 존재하는 ID입니다.";
        }
    }

    @GetMapping("loginForm")
    public String loginForm() {
        return "loginForm";
    }

    // 개인정보 수정 폼으로 이동
    @GetMapping("info")
    public String info(@AuthenticationPrincipal AuthenticatedUser user, Model model) {
        MemberDTO dto = memberService.getMember(user.getUsername());
        model.addAttribute("member", dto);
        return "loginInfo";
    }

    // 개인정보 수정 폼에서 수정 처리
    @PostMapping("info")
    public String update(@AuthenticationPrincipal AuthenticatedUser user,
                         @ModelAttribute MemberDTO dto, RedirectAttributes redirectAttributes) {
        log.debug("수정폼에서 전달된 값 : {}", dto);
        dto.setEmail(user.getUsername());
        memberService.update(dto);
        redirectAttributes.addFlashAttribute("flag", true);
        return "redirect:/";
    }
}
