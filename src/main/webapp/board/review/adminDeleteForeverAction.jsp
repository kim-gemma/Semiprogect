<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="board.review.ReviewBoardDao" %>

<%
String roleType = (String) session.getAttribute("roleType");

if (!"3".equals(roleType) && !"9".equals(roleType)) {
    out.print("{\"success\": false}");
    return;
}

int board_idx = 0;
try {
    board_idx = Integer.parseInt(request.getParameter("board_idx"));
} catch (Exception e) {
    out.print("{\"success\": false, \"error\": \"invalid_board_idx\"}");
    return;
}

ReviewBoardDao dao = new ReviewBoardDao();
boolean success = dao.deleteBoardForever(board_idx);

out.print("{\"success\": " + success + "}");
%>
