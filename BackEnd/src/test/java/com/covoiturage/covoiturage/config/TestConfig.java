package com.covoiturage.covoiturage.config;

import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@TestConfiguration
public class TestConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        // Disable CSRF explicitly for the security configuration
        http
                .authorizeRequests()
                .anyRequest().authenticated()
                .and();


        // Return the configured SecurityFilterChain
        return http.build();
    }
}
