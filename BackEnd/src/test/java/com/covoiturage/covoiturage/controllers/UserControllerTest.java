package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.ERole;
import com.covoiturage.covoiturage.models.Role;
import com.covoiturage.covoiturage.models.User;
import com.covoiturage.covoiturage.payload.response.MessageResponse;
import com.covoiturage.covoiturage.repositories.RoleRepository;
import com.covoiturage.covoiturage.repositories.UserRepository;
import com.covoiturage.covoiturage.security.jwt.JwtUtils;
import com.covoiturage.covoiturage.security.services.RefreshTokenService;
import com.covoiturage.covoiturage.payload.request.LoginRequest;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;
import java.util.Map;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {
    @InjectMocks
    private UserController userController;
    @Mock
    private UserRepository userRepository;
    @Mock
    private RoleRepository roleRepository;
    @Mock
    private PasswordEncoder encoder;
    @Mock
    private JwtUtils jwtUtils;
    @Mock
    private RefreshTokenService refreshTokenService;
    @Mock
    private AuthenticationManager authenticationManager;
    @Test
    void testGetAllUsers_ReturnsList() {
        List<User> users = List.of(new User(), new User());
        when(userRepository.findAll()).thenReturn(users);

        List<User> response = userController.findAll();

        assertEquals(2, response.size());
    }
    @Test
    void testGetUserByUid_ReturnsUser() {
        User user = new User();
        user.setUid("1");
        when(userRepository.findByUid("1")).thenReturn(Optional.of(user));

        ResponseEntity<User> response = userController.getUserByUid("1");

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("1", response.getBody().getUid());
    }
    @Test
    void testSignup_Success() {
        Map<String, Object> userData = new HashMap<>();
        userData.put("uid", "1");
        userData.put("username", "newUser");
        userData.put("email", "user@example.com");
        userData.put("phone", "123456789");
        userData.put("gender", "Male");
        userData.put("city", "City");
        userData.put("password", "password123");
        when(userRepository.existsByUid("1")).thenReturn(false);
        when(roleRepository.findByName(ERole.PASSAGER)).thenReturn(Optional.of(new Role()));
        ResponseEntity<MessageResponse> response = (ResponseEntity<MessageResponse>) userController.registerUser(userData);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("User registered successfully!", response.getBody().getMessage());
    }
    @Test
    void testSignin() {
        String email = "invalid@example.com";
        String password = "wrongPassword";
        LoginRequest loginRequest = new LoginRequest(email, password);
        when(userRepository.findByEmail(email)).thenReturn(Optional.empty());
        ResponseEntity<MessageResponse> response = (ResponseEntity<MessageResponse>) userController.authenticateUser(loginRequest);
        assertEquals(HttpStatus.UNAUTHORIZED, response.getStatusCode());
        assertEquals("Error: User not found", response.getBody().getMessage());
    }
    @Test
    void testUpdateUser_Success() {
        String userId = "1";
        Map<String, Object> userData = new HashMap<>();
        userData.put("username", "updatedUser");
        userData.put("phone", "987654321");
        userData.put("city", "NewCity");
        User user = new User();
        user.setId(userId);
        when(userRepository.findById(userId)).thenReturn(Optional.of(user));
        ResponseEntity<MessageResponse> response = (ResponseEntity<MessageResponse>) userController.updateUser(userId, userData);
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("User updated successfully!", response.getBody().getMessage());
    }
    @Test
    void testUpdateUser_Failure_UserNotFound() {
        String userId = "1";
        Map<String, Object> userData = new HashMap<>();
        userData.put("username", "updatedUser");
        when(userRepository.findById(userId)).thenReturn(Optional.empty());
        ResponseEntity<MessageResponse> response = (ResponseEntity<MessageResponse>) userController.updateUser(userId, userData);
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertEquals("Error: User not found", response.getBody().getMessage());
    }
}
