package com.covoiturage.covoiturage.controllers;
import com.covoiturage.covoiturage.controllers.UserController;
import com.covoiturage.covoiturage.models.User;
import com.covoiturage.covoiturage.payload.response.MessageResponse;
import com.covoiturage.covoiturage.repositories.UserRepository;
import com.covoiturage.covoiturage.security.jwt.JwtUtils;
import com.covoiturage.covoiturage.security.services.UserDetailsImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import java.util.Optional;
import java.util.Map;

public class UserControllerTest {

    @InjectMocks
    private UserController userController;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder encoder;

    @Mock
    private JwtUtils jwtUtils;

    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testUpdateUser_Success() {
        // Arrange
        String userId = "123";
        Map<String, Object> userData = Map.of(
                "username", "newUsername",
                "phone", "123456789",
                "gender", "Male",
                "city", "New City"
        );

        User existingUser = new User();
        existingUser.setId(userId);
        existingUser.setUsername("oldUsername");
        existingUser.setPhone("987654321");
        existingUser.setGender("Female");
        existingUser.setCity("Old City");

        when(userRepository.findById(userId)).thenReturn(Optional.of(existingUser));
        when(userRepository.save(any(User.class))).thenReturn(existingUser);

        // Act
        ResponseEntity<?> response = userController.updateUser(userId, userData);

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertTrue(response.getBody() instanceof MessageResponse);
        MessageResponse message = (MessageResponse) response.getBody();
        assertEquals("User updated successfully!", message.getMessage());

        // Verify that the repository save method was called
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    public void testUpdateUser_UserNotFound() {
        // Arrange
        String userId = "123";
        Map<String, Object> userData = Map.of(
                "username", "newUsername",
                "phone", "123456789",
                "gender", "Male",
                "city", "New City"
        );

        when(userRepository.findById(userId)).thenReturn(Optional.empty());

        // Act
        ResponseEntity<?> response = userController.updateUser(userId, userData);

        // Assert
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
        assertTrue(response.getBody() instanceof MessageResponse);
        MessageResponse message = (MessageResponse) response.getBody();
        assertEquals("Error: User not found", message.getMessage());
    }

    @Test
    public void testUpdateUser_InternalServerError() {
        // Arrange
        String userId = "123";
        Map<String, Object> userData = Map.of(
                "username", "newUsername"
        );

        User existingUser = new User();
        existingUser.setId(userId);
        existingUser.setUsername("oldUsername");

        when(userRepository.findById(userId)).thenReturn(Optional.of(existingUser));
        when(userRepository.save(any(User.class))).thenThrow(new RuntimeException("Internal error"));

        // Act
        ResponseEntity<?> response = userController.updateUser(userId, userData);

        // Assert
        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.getStatusCode());
        assertTrue(response.getBody() instanceof MessageResponse);
        MessageResponse message = (MessageResponse) response.getBody();
        assertEquals("Error: Internal error", message.getMessage());
    }
}
