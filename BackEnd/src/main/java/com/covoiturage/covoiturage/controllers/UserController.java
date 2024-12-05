package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.ERole;
import com.covoiturage.covoiturage.models.Role;
import com.covoiturage.covoiturage.models.Trajet;
import com.covoiturage.covoiturage.models.User;
import com.covoiturage.covoiturage.payload.request.LoginRequest;
import com.covoiturage.covoiturage.payload.request.SignupRequest;
import com.covoiturage.covoiturage.payload.response.JwtResponse;
import com.covoiturage.covoiturage.payload.response.MessageResponse;
import com.covoiturage.covoiturage.repositories.UserRepository;
import com.covoiturage.covoiturage.repositories.RoleRepository;
import com.covoiturage.covoiturage.security.jwt.JwtUtils;
import com.covoiturage.covoiturage.security.services.UserDetailsImpl;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder encoder;

    @Autowired
    private JwtUtils jwtUtils;

    @GetMapping("/utilisateurs")
    public List<User> findAll(){
        return userRepository.findAll();
    }

    @GetMapping("/utilisateur")
    public Optional<User> findByUsername(@RequestParam(value = "name") String name){
        return userRepository.findByUsername(name);
    }
    @GetMapping("/roles")
    public List<Role> findAllRoles() {return roleRepository.findAll();}

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            User user = userRepository.findByEmail(loginRequest.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User Not Found with email: " + loginRequest.getEmail()));

            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    user.getUsername(),
                    loginRequest.getPassword()
                )
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = jwtUtils.generateJwtToken(authentication);

            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

            return ResponseEntity.ok(new JwtResponse(
                jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                roles
            ));
        } catch (UsernameNotFoundException e) {
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(new MessageResponse("Error: User not found"));
        } catch (AuthenticationException e) {
            return ResponseEntity
                .status(HttpStatus.UNAUTHORIZED)
                .body(new MessageResponse("Error: Invalid email or password"));
        } catch (Exception e) {
            return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@RequestBody Map<String, Object> userData) {
        try {
            // Validate required fields
            if (userData.get("uid") == null || userData.get("email") == null) {
                return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: Missing required fields"));
            }

            // Check for existing user
            if (userRepository.existsByUid((String) userData.get("uid"))) {
                return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: User already exists"));
            }

            // Create new user
            User user = new User();
            user.setUid((String) userData.get("uid"));
            user.setUsername((String) userData.get("username"));
            user.setEmail((String) userData.get("email"));
            user.setPhone((String) userData.get("phone"));
            user.setGender((String) userData.get("gender"));
            user.setCity((String) userData.get("city"));
            user.setPassword(encoder.encode((String) userData.get("password")));

            Set<Role> roles = new HashSet<>();
            Role passagerRole = roleRepository.findByName(ERole.PASSAGER)
                .orElseThrow(() -> new RuntimeException("Error: Role PASSAGER not found"));
            roles.add(passagerRole);
            user.setRoles(roles);

            userRepository.save(user);

            return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError()
                .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }



    @PostMapping("/utilisateur/{id}/proposerTrajet")
    public void proposerTrajet(@PathVariable String id, @RequestBody Trajet trajet) {
        Optional<User> utilisateurOptional = userRepository.findById(id);
        if (utilisateurOptional.isPresent()) {
            User user = utilisateurOptional.get();
            user.proposerTrajet(trajet);
            userRepository.save(user);
        }
    }

    @GetMapping("/utilisateur/{id}/rechercherTrajet")
    public void rechercherTrajet(@PathVariable String id) {
        Optional<User> utilisateurOptional = userRepository.findById(id);
        if (utilisateurOptional.isPresent()) {
            User user = utilisateurOptional.get();
            user.rechercherTrajet();
        }
    }


}
