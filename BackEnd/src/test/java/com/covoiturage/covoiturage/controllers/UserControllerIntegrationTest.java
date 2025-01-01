package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.User;
import com.covoiturage.covoiturage.repositories.UserRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import java.util.HashMap;
import java.util.Map;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@AutoConfigureMockMvc
@TestPropertySource(properties = {
        "spring.security.user.name=admin",
        "spring.security.user.password=admin",
        "spring.security.user.roles=ADMIN"
})
class UserControllerIntegrationTest {
    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private ObjectMapper objectMapper;
    private User existingUser;
    @Autowired
    private PasswordEncoder encoder;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
        existingUser = new User();
        existingUser.setUsername("oldUsername");
        existingUser.setPhone("987654321");
        existingUser.setGender("Female");
        existingUser.setCity("Old City");
        existingUser = userRepository.save(existingUser);
    }
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void testUpdateUser_Success() throws Exception {
        User updateData = new User();
        updateData.setUsername("newUsername");
        updateData.setPhone("123456789");
        updateData.setGender("Male");
        updateData.setCity("New City");
        MvcResult result = mockMvc.perform(put("/api/utilisateur/{userId}", existingUser.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateData)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("User updated successfully!"))
                .andReturn();
        User updatedUser = userRepository.findById(existingUser.getId())
                .orElseThrow(() -> new AssertionError("User not found"));
        assertEquals(updateData.getUsername(), updatedUser.getUsername());
        assertEquals(updateData.getPhone(), updatedUser.getPhone());
        assertEquals(updateData.getGender(), updatedUser.getGender());
        assertEquals(updateData.getCity(), updatedUser.getCity());
    }
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void testUpdateUser_UserNotFound() throws Exception {
        User updateData = new User();
        updateData.setUsername("newUsername");
        mockMvc.perform(put("/api/utilisateur/{userId}", "nonexistentid")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateData)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Error: User not found"));
    }
    @Test
    @WithMockUser(username = "admin", roles = {"ADMIN"})
    void testUpdateUser_ValidationError() throws Exception {
        // Create invalid update request data
        User updateData = new User();
        updateData.setUsername(""); // Invalid empty username

        // Perform the update request
        mockMvc.perform(put("/api/utilisateur/{userId}", existingUser.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateData)))
                .andExpect(status().isBadRequest()) // Expect a Bad Request response
                .andExpect(jsonPath("$.message").value("Error: Username cannot be empty")); // Expect the validation error message
    }

    @Test
    void testSignup_Success() throws Exception {
        // Create signup request data
        Map<String, Object> signupData = new HashMap<>();
        signupData.put("uid", "unique123");
        signupData.put("username", "newUser");
        signupData.put("email", "newuser@example.com");
        signupData.put("password", "password123");
        signupData.put("phone", "123456789");
        signupData.put("gender", "Male");
        signupData.put("city", "New City");
        mockMvc.perform(post("/api/signup")
                        .contentType(MediaType.APPLICATION_JSON) // Set Content-Type header
                        .content(objectMapper.writeValueAsString(signupData))) // Set request body
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("User registered successfully!"));
        User user = userRepository.findByUsername("newUser")
                .orElseThrow(() -> new AssertionError("User not found"));
        assertEquals("newUser", user.getUsername());
        assertEquals("newuser@example.com", user.getEmail());
    }
    @Test
    void testSignin_Success() throws Exception {
        Map<String, Object> signupData = new HashMap<>();
        signupData.put("uid", "unique123");
        signupData.put("username", "newUser");
        signupData.put("email", "newuser@example.com");
        signupData.put("password", "password123");
        signupData.put("phone", "123456789");
        signupData.put("gender", "Male");
        signupData.put("city", "New City");
        mockMvc.perform(post("/api/signup")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(signupData)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("User registered successfully!"));
        User user = userRepository.findByUsername("newUser")
                .orElseThrow(() -> new AssertionError("User not found"));
        assertEquals("newUser", user.getUsername());
        assertEquals("newuser@example.com", user.getEmail());
    }
}
