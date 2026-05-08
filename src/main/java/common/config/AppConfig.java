package common.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class AppConfig {

    private static final Properties props = new Properties();

    static {
        try (InputStream input = AppConfig.class
                .getClassLoader()
                .getResourceAsStream("config.properties")) {

            if (input == null) {
                throw new RuntimeException(
                    "config.properties file was not found. Create it under src/main/resources."
                );
            }

            props.load(input);

        } catch (IOException e) {
            throw new RuntimeException("Failed to read config.properties", e);
        }
    }

    public static String getKmdbServiceKey() {
        return props.getProperty("KMDB_SERVICE_KEY");
    }

    public static String getKmdbApiUrl() {
        return props.getProperty("KMDB_API_URL");
    }

    public static String getNaverClientId() {
        return props.getProperty("NAVER_CLIENT_ID");
    }

    public static String getNaverClientSecret() {
        return props.getProperty("NAVER_CLIENT_SECRET");
    }

    public static String getNaverCallbackUrl() {
        return props.getProperty("NAVER_CALLBACK_URL");
    }
}
