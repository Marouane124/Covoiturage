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
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
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

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                roles));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@RequestBody SignupRequest signUpRequest) {
        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity.badRequest().body(new MessageResponse("Error: Username is already taken!"));
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity.badRequest().body(new MessageResponse("Error: Email is already in use!"));
        }

        User user = new User(
                signUpRequest.getUsername(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()),
                signUpRequest.getPhone(),
                signUpRequest.getGender()
        );

        Set<String> strRoles = signUpRequest.getRoles();
        Set<Role> roles = new HashSet<>();

        if (strRoles == null || strRoles.isEmpty()) {
            Role userRole = roleRepository.findByName(ERole.PASSAGER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            roles.add(userRole);
        } else {
            strRoles.forEach(role -> {
                switch (role.toLowerCase()) {
                    case "conducteur":
                        Role adminRole = roleRepository.findByName(ERole.CONDUCTEUR)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(adminRole);
                        break;

                    case "passager":
                    default:
                        Role userRole = roleRepository.findByName(ERole.PASSAGER)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(userRole);
                }
            });
        }

        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
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
