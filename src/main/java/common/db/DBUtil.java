package common.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import common.config.AppConfig;

public class DBUtil {

    private DBUtil() {
    }

    public static Connection getConnection() throws SQLException {
        loadDriver();

        return DriverManager.getConnection(
            AppConfig.getDbUrl(),
            AppConfig.getDbUser(),
            AppConfig.getDbPassword()
        );
    }

    private static void loadDriver() throws SQLException {
        String driver = AppConfig.getDbDriver();

        if (driver == null || driver.trim().isEmpty()) {
            throw new SQLException("DB_DRIVER is not configured.");
        }

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new SQLException("DB driver class was not found: " + driver, e);
        }
    }
}
