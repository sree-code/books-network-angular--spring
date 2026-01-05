package com.gorasr6.book.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.view.RedirectView;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Root controller to handle base URL requests
 * Provides API information and redirects to Swagger UI
 */
@RestController
@RequestMapping("/")
public class RootController {

    @GetMapping
    public RedirectView root() {
        // Redirect root URL to Swagger UI
        return new RedirectView("/api/v1/swagger-ui/index.html");
    }

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", LocalDateTime.now());
        health.put("application", "Book Social Network API");
        health.put("version", "1.0.0");
        return ResponseEntity.ok(health);
    }

    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> info() {
        Map<String, Object> info = new HashMap<>();
        info.put("application", "Book Social Network API");
        info.put("description", "A social network for book lovers");
        info.put("version", "1.0.0");
        info.put("apiBasePath", "/api/v1");
        info.put("swaggerUI", "/api/v1/swagger-ui/index.html");
        info.put("timestamp", LocalDateTime.now());

        Map<String, String> endpoints = new HashMap<>();
        endpoints.put("Authentication", "/api/v1/auth");
        endpoints.put("Books", "/api/v1/books");
        endpoints.put("Feedback", "/api/v1/feedbacks");
        endpoints.put("Swagger UI", "/api/v1/swagger-ui/index.html");
        endpoints.put("API Docs", "/api/v1/v3/api-docs");

        info.put("endpoints", endpoints);

        return ResponseEntity.ok(info);
    }
}

