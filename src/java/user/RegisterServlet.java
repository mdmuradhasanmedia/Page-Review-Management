package user;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/user/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password);

        UserDAO userDao = new UserDAO();
        boolean success = userDao.register(user);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp?msg=registered");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/register.jsp?msg=fail");
        }
    }
}
