package user;

import dao.PageDAO;
import model.Page;
import model.User;
import util.LoggerUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/AddPageServlet")
public class AddPageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            HttpSession session = request.getSession(false);
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/user/login.jsp");
                return;
            }

            String title = request.getParameter("title");
            String contact = request.getParameter("contact");
            String email = request.getParameter("email");
            String location = request.getParameter("location");
            String content = request.getParameter("content");

            Page page = new Page();
            page.setUserId(user.getUserId());
            page.setTitle(title);
            page.setContact(contact);
            page.setEmail(email);
            page.setLocation(location);
            page.setContent(content);

            PageDAO pageDAO = new PageDAO();
            boolean saved = pageDAO.addPage(page);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp?msg=page_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/user/add_page.jsp?msg=fail");
            }

        } catch (Exception e) {
            LoggerUtil.logError("AddPageServlet.doPost()", e);
            response.sendRedirect(request.getContextPath() + "/user/add_page.jsp?msg=fail");
        }
    }
}
