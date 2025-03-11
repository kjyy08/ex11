<%@ page import="java.net.http.HttpClient" %>
<%@ page import="java.net.http.HttpRequest" %>
<%@ page import="java.net.URI" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="io.github.cdimascio.dotenv.Dotenv" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.http.HttpResponse" %>
<%@ page import="org.example.ex11.model.GeminiResponse" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>요청 객체 다루기</title>
    <style>
        @font-face {
            font-family: 'NoonnuBasicGothicRegular';
            src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noon-2410@1.0/NoonnuBasicGothicRegular.woff2') format('woff2');
            font-weight: normal;
            font-style: normal;
        }

        * {
            font-family: NoonnuBasicGothicRegular, serif;
            font-size: 13pt;
        }

        body * {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        form {
            width: 100%;
            height: 100vh;
            /*display: flex;*/
            /*flex-direction: column;*/
            /*justify-content: center;*/
            /*align-items: center;*/
            gap: 1rem;
        }

        form * {
            width: 50%;
        }
    </style>
</head>
<body>
<%! HttpClient client = HttpClient.newHttpClient(); %>
<%! Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load(); %>
<%! ObjectMapper mapper = new ObjectMapper(); %>
<%! String answer = ""; %>
<%
    String prompt = request.getParameter("prompt");
    if (prompt == null || prompt.isBlank()) {
        prompt = "프롬프트가 없습니다";
        answer = "프롬프트를 제대로 입력해주세요!";
    } else {
        prompt += " no markdown, under 300 character, use korean language, nutshell please";

        Map<String, List<Map<String, List<Map<String, String>>>>> geminiMap = new HashMap<>();
        List<Map<String, String>> parts = List.of(new HashMap<>());
        parts.get(0).put("text", prompt);
        List<Map<String, List<Map<String, String>>>> contents = List.of(new HashMap<>());
        contents.get(0).put("parts", parts);
        geminiMap.put("contents", contents);

        HttpRequest httpRequest = HttpRequest.newBuilder()
                .uri(URI.create("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=%s".formatted(
                        dotenv.get("GEMINI_KEY")
                )))
                .POST(HttpRequest.BodyPublishers.ofString(
                        mapper.writeValueAsString(geminiMap)))
                .build();
        try {
            HttpResponse<String> httpResponse = client.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            answer = mapper.readValue(httpResponse.body(), GeminiResponse.class).candidates().get(0).content().parts().get(0).text();
        } catch (Exception e) {
            answer = e.getMessage();
        }
    }
%>
<form>
    <section class="title">
        프롬프트 : <%= prompt %>
    </section>
    <section>
        답변 : <%= answer %>
    </section>
    <input name="prompt" placeholder="프롬프트를 입력해주세요">
    <button>제출</button>
</form>
</body>
</html>