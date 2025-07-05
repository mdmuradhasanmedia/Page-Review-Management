package util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("AppContextListener: contextInitialized called!");
        DBInitializer.initialize();
    }
    @Override
    public void contextDestroyed(ServletContextEvent sce) { }
}
