<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <title>JSP - Hello World</title>
</head>
<body>
<%-- <%= %>: 표현식(Expression) - 결과를 웹 페이지에 출력할 때 사용 --%>
<%-- <% %>: 스크립트릿(Scriptlet) - 자바 로직을 삽입할 때 사용 --%>
<%-- <%! %>: 선언부(Declaration) - JSP 파일 내에서 사용할 메서드나 변수를 선언할 때 사용 --%>

    <% System.out.println("hello"); %>
    <% response.getWriter().println("hello jsp"); %>
    <%! int i = 0; %>
    <%= i++ %>
    <%= i++ %>
    <%= i++ %>
    <%= i++ %>

</body>
</html>