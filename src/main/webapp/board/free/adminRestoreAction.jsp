<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="board.free.FreeBoardDao" %>

<%
String roleType = (String) session.getAttribute("roleType");
if (!"3".equals(roleType) && !"9".equals(roleType)) {
    out.print("{\"success\": false, \"error\": \"unauthorized\"}");
    return;
}

int board_idx = 0;
try {
    board_idx = Integer.parseInt(request.getParameter("board_idx"));
} catch (Exception e) {
    out.print("{\"success\": false, \"error\": \"invalid_board_idx\"}");
    return;
}

FreeBoardDao dao = new FreeBoardDao();
boolean success = dao.restoreBoard(board_idx);

out.print("{\"success\": " + success + "}");
%>
