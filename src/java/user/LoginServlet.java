package user;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usernameOrEmail = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDao = new UserDAO();
        User user = userDao.login(usernameOrEmail, password);

        if (user != null && !user.isSuspended()) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
        } else if (user != null && user.isSuspended()) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp?msg=suspended");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp?msg=fail");
        }
    }
}
