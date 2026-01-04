package com.gorasr6.book.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Database configuration for production environments (e.g., Render, Heroku)
 * Handles DATABASE_URL in postgresql:// format and converts to JDBC format
 */
@Configuration
@Profile("prod")
public class DatabaseConfig {

    private static final Logger log = LoggerFactory.getLogger(DatabaseConfig.class);

    @Bean
    public DataSource dataSource() {
        String databaseUrl = System.getenv("DATABASE_URL");

        log.info("=== DATABASE CONFIGURATION ===");
        log.info("DATABASE_URL is {}", databaseUrl != null ? "SET" : "NOT SET");

        if (databaseUrl == null || databaseUrl.isEmpty()) {
            log.error("DATABASE_URL environment variable is not set!");
            log.error("Please set DATABASE_URL in Render dashboard -> Environment tab");
            throw new RuntimeException("DATABASE_URL environment variable is required but not set");
        }

        if (databaseUrl.startsWith("postgresql://")) {
            // Convert Render's postgresql:// format to jdbc:postgresql://
            try {
                URI dbUri = new URI(databaseUrl);

                if (dbUri.getUserInfo() == null) {
                    log.error("DATABASE_URL is missing username/password");
                    log.error("Format should be: postgresql://username:password@host:port/database");
                    throw new RuntimeException("Invalid DATABASE_URL: missing credentials");
                }

                String[] userInfo = dbUri.getUserInfo().split(":");
                if (userInfo.length < 2) {
                    log.error("DATABASE_URL is missing password");
                    throw new RuntimeException("Invalid DATABASE_URL: missing password");
                }

                String username = userInfo[0];
                String password = userInfo[1];
                String host = dbUri.getHost();
                int port = dbUri.getPort();
                String path = dbUri.getPath();

                // Handle missing port - default to 5432 (standard PostgreSQL port)
                if (port == -1) {
                    log.warn("DATABASE_URL is missing port number, defaulting to 5432");
                    log.warn("Current URL format appears incomplete - missing :5432");
                    log.warn("Expected format: postgresql://user:pass@host:5432/database");
                    log.warn("Your URL format: postgresql://user:pass@host/database");
                    log.warn("");
                    log.warn("Using default PostgreSQL port 5432 as fallback...");
                    log.warn("For better configuration, get the COMPLETE Internal Database URL from Render:");
                    log.warn("1. Go to Render Dashboard → PostgreSQL");
                    log.warn("2. Click on your database");
                    log.warn("3. Scroll to 'Connections' section");
                    log.warn("4. Copy the FULL 'Internal Database URL' including :5432");
                    log.warn("5. Set it as DATABASE_URL in your web service");
                    port = 5432; // Default PostgreSQL port
                }

                // Also check if hostname is complete (should include .render.com suffix)
                if (!host.contains(".")) {
                    log.warn("DATABASE_URL hostname appears incomplete: {}", host);
                    log.warn("Expected format: dpg-xxxxx-a.REGION-postgres.render.com");
                    log.warn("Your format: {}", host);
                    log.warn("Attempting to construct full hostname...");

                    // Try to construct full hostname if it's a Render database
                    if (host.startsWith("dpg-") && !host.contains(".render.com")) {
                        // Assume Oregon region as default (most common)
                        String fullHost = host + ".oregon-postgres.render.com";
                        log.warn("Constructed hostname: {}", fullHost);
                        host = fullHost;
                    }
                }

                String jdbcUrl = "jdbc:postgresql://" + host + ':' + port + path;

                // Add SSL and other parameters for Render
                if (dbUri.getQuery() != null) {
                    jdbcUrl += "?" + dbUri.getQuery();
                } else {
                    // Render requires SSL
                    jdbcUrl += "?sslmode=require";
                }

                log.info("Converted DATABASE_URL:");
                log.info("  Host: {}", host);
                log.info("  Port: {}", port);
                log.info("  Database: {}", path);
                log.info("  Username: {}", username);
                log.info("  JDBC URL: {}", jdbcUrl.replaceAll("\\?.*", "?[params]"));

                // Use HikariCP with proper configuration for cloud environments
                HikariConfig config = new HikariConfig();
                config.setJdbcUrl(jdbcUrl);
                config.setUsername(username);
                config.setPassword(password);
                config.setDriverClassName("org.postgresql.Driver");

                // Connection pool settings for cloud databases
                config.setMaximumPoolSize(5);
                config.setMinimumIdle(2);
                config.setConnectionTimeout(30000); // 30 seconds
                config.setIdleTimeout(600000); // 10 minutes
                config.setMaxLifetime(1800000); // 30 minutes
                config.setLeakDetectionThreshold(60000); // 1 minute

                // Validate connections
                config.setConnectionTestQuery("SELECT 1");

                log.info("Creating HikariDataSource with connection pool");
                return new HikariDataSource(config);

            } catch (URISyntaxException e) {
                log.error("Invalid DATABASE_URL format: {}", e.getMessage());
                throw new RuntimeException("Invalid DATABASE_URL format", e);
            } catch (Exception e) {
                log.error("Failed to create DataSource: {}", e.getMessage());
                throw new RuntimeException("Failed to create DataSource", e);
            }
        }

        // Handle jdbc:postgresql:// format
        if (databaseUrl.startsWith("jdbc:postgresql://")) {
            log.info("Using JDBC URL format directly");
            log.info("JDBC URL: {}", databaseUrl.replaceAll("\\?.*", "?[params]"));

            String username = System.getenv("DATABASE_USERNAME");
            String password = System.getenv("DATABASE_PASSWORD");

            if (username == null || password == null) {
                log.error("DATABASE_USERNAME or DATABASE_PASSWORD not set");
                throw new RuntimeException("DATABASE_USERNAME and DATABASE_PASSWORD required for JDBC URL");
            }

            return DataSourceBuilder
                    .create()
                    .url(databaseUrl)
                    .username(username)
                    .password(password)
                    .driverClassName("org.postgresql.Driver")
                    .build();
        }

        log.error("DATABASE_URL format not recognized. Must start with 'postgresql://' or 'jdbc:postgresql://'");
        log.error("Current value starts with: {}", databaseUrl.substring(0, Math.min(20, databaseUrl.length())));
        throw new RuntimeException("Invalid DATABASE_URL format");
    }
}

