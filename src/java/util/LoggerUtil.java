package util;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;

public class LoggerUtil {

    private static final String LOG_FILE = "logs/error.log";

    public static void logError(String context, Exception e) {
        try (FileWriter fw = new FileWriter(LOG_FILE, true);
             PrintWriter pw = new PrintWriter(fw)) {

            pw.println("========== ERROR ==========");
            pw.println("Timestamp: " + LocalDateTime.now());
            pw.println("Context: " + context);
            pw.println("Exception: " + e.toString());

            for (StackTraceElement element : e.getStackTrace()) {
                pw.println("    at " + element.toString());
            }

            pw.println("===========================");
            pw.println();

        } catch (IOException ioEx) {
            System.err.println("⚠ Failed to write to error log: " + ioEx.getMessage());
        }
    }
}
