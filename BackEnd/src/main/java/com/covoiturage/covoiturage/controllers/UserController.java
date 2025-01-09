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
import com.covoiturage.covoiturage.security.services.RefreshTokenService;
import com.covoiturage.covoiturage.models.RefreshToken;
import com.covoiturage.covoiturage.payload.response.TokenRefreshResponse;
import com.covoiturage.covoiturage.exceptions.TokenRefreshException;
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
import org.springframework.web.multipart.MultipartFile;

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

    @Autowired
    private RefreshTokenService refreshTokenService;

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

            RefreshToken refreshToken = refreshTokenService.createRefreshToken(userDetails.getId());

            return ResponseEntity.ok(new JwtResponse(
                jwt,
                refreshToken.getToken(),
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
    @PutMapping("/utilisateur/{id}")
    public ResponseEntity<?> updateUser(@PathVariable String id, @RequestBody Map<String, Object> userData) {
        try {
            // Validate the username
            if (userData.get("username") != null && ((String) userData.get("username")).isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new MessageResponse("Error: Username cannot be empty"));
            }

            Optional<User> userOptional = userRepository.findById(id);
            if (userOptional.isPresent()) {
                User user = userOptional.get();
                if (userData.get("username") != null) {
                    user.setUsername((String) userData.get("username"));
                }
                if (userData.get("phone") != null) {
                    user.setPhone((String) userData.get("phone"));
                }
                if (userData.get("gender") != null) {
                    user.setGender((String) userData.get("gender"));
                }
                if (userData.get("city") != null) {
                    user.setCity((String) userData.get("city"));
                }

                userRepository.save(user);
                return ResponseEntity.ok(new MessageResponse("User updated successfully!"));
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new MessageResponse("Error: User not found"));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }


    @GetMapping("/utilisateur/{uid}")
    public ResponseEntity<User> getUserByUid(@PathVariable String uid) {
        Optional<User> userOptional = userRepository.findByUid(uid);
        return userOptional.map(ResponseEntity::ok)
            .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
    }

    @PostMapping("/auth/refresh")
    public ResponseEntity<?> refreshToken(@RequestBody Map<String, String> request) {
        String requestRefreshToken = request.get("refreshToken");

        try {
            RefreshToken refreshToken = refreshTokenService.findByToken(requestRefreshToken)
                .orElseThrow(() -> new TokenRefreshException(requestRefreshToken, "Refresh token not found"));

            refreshTokenService.verifyExpiration(refreshToken);

            // Generate new access token
            String newAccessToken = jwtUtils.generateTokenFromUsername(
                userRepository.findById(refreshToken.getUserId())
                    .orElseThrow(() -> new RuntimeException("User not found"))
                    .getUsername()
            );

            return ResponseEntity.ok(new TokenRefreshResponse(newAccessToken, requestRefreshToken));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new MessageResponse(e.getMessage()));
        }
    }

    @PostMapping("/utilisateur/updateProfileImage")
    public ResponseEntity<?> updateProfileImage(@RequestParam("photo") MultipartFile file, @RequestParam("uid") String currentUserId) {
        if (file.isEmpty() || currentUserId == null) {
            return ResponseEntity.badRequest().body("Missing required fields");
        }

        try {
            // Convert the file to a byte array
            byte[] imageBytes = file.getBytes();
            String encodedImage = Base64.getEncoder().encodeToString(imageBytes);

            // Find the user by ID and update the profile image
            User user = userRepository.findByUid(currentUserId).orElse(null);
            if (user != null) {
                user.setProfileImage(encodedImage);
                userRepository.save(user);
                return ResponseEntity.ok("Profile image updated successfully");
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error: " + e.getMessage());
        }
    }

    @PostMapping("/utilisateur/{uid}/role")
    public ResponseEntity<?> addRoleToUser(@PathVariable String uid, @RequestBody Map<String, String> roleData) {
        try {
            // Validate the role
            String roleName = roleData.get("role");
            if (roleName == null || roleName.isEmpty()) {
                return ResponseEntity.badRequest().body(new MessageResponse("Error: Role cannot be empty"));
            }

            // Find the user by UID
            User user = userRepository.findByUid(uid)
                    .orElseThrow(() -> new RuntimeException("Error: User not found"));

            // Find the role
            Role role = roleRepository.findByName(ERole.valueOf(roleName))
                    .orElseThrow(() -> new RuntimeException("Error: Role not found"));

            // Add the role to the user
            user.getRoles().add(role);
            userRepository.save(user);

            return ResponseEntity.ok(new MessageResponse("Role added successfully!"));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    @GetMapping("/utilisateur/{uid}/role")
    public ResponseEntity<?> getCurrentUserRole(@PathVariable String uid) {
        try {
            // Rechercher l'utilisateur par UID
            User user = userRepository.findByUid(uid)
                    .orElseThrow(() -> new RuntimeException("Error: User not found"));

            // Obtenir les rôles de l'utilisateur
            Set<Role> userRoles = user.getRoles();

            // Vérifier si l'utilisateur est un conducteur
            boolean isConducteur = userRoles.stream()
                    .anyMatch(role -> role.getName() == ERole.CONDUCTEUR);

            // Vérifier si l'utilisateur est un passager
            boolean isPassager = userRoles.stream()
                    .anyMatch(role -> role.getName() == ERole.PASSAGER);

            // Préparer la réponse
            Map<String, Object> response = new HashMap<>();
            response.put("uid", uid);
            response.put("roles", new HashMap<String, Boolean>() {{
                put("conducteur", isConducteur);
                put("passager", isPassager);
            }});

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }

    @PostMapping("/utilisateur/{uid}/toggleRole")
    public ResponseEntity<?> toggleUserRole(@PathVariable String uid) {
        try {
            // Rechercher l'utilisateur par UID
            User user = userRepository.findByUid(uid)
                    .orElseThrow(() -> new RuntimeException("Error: User not found"));

            Set<Role> userRoles = user.getRoles();
            Role conducteurRole = roleRepository.findByName(ERole.CONDUCTEUR)
                    .orElseThrow(() -> new RuntimeException("Error: Role CONDUCTEUR not found"));
            Role passagerRole = roleRepository.findByName(ERole.PASSAGER)
                    .orElseThrow(() -> new RuntimeException("Error: Role PASSAGER not found"));

            // Vérifier le rôle actuel et basculer
            if (userRoles.stream().anyMatch(role -> role.getName() == ERole.CONDUCTEUR)) {
                // Si l'utilisateur est CONDUCTEUR, changer à PASSAGER
                userRoles.remove(conducteurRole);
                userRoles.add(passagerRole);
            } else {
                // Si l'utilisateur est PASSAGER, changer à CONDUCTEUR
                userRoles.remove(passagerRole);
                userRoles.add(conducteurRole);
            }

            user.setRoles(userRoles);
            userRepository.save(user);

            // Préparer la réponse
            String newRole = userRoles.stream()
                    .map(role -> role.getName().toString())
                    .filter(roleName -> roleName.equals("CONDUCTEUR") || roleName.equals("PASSAGER"))
                    .findFirst()
                    .orElse("PASSAGER");

            Map<String, Object> response = new HashMap<>();
            response.put("uid", uid);
            response.put("roles", Collections.singletonMap(newRole.toLowerCase(), true));
            response.put("message", "Rôle changé avec succès en " + newRole);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new MessageResponse("Error: " + e.getMessage()));
        }
    }



//    @GetMapping("/utilisateur/{uid}/role")
//    public ResponseEntity<?> getCurrentUserRole(@PathVariable String uid) {
//        try {
//            // Rechercher l'utilisateur par UID
//            User user = userRepository.findByUid(uid)
//                    .orElseThrow(() -> new RuntimeException("Error: User not found"));
//
//            // Obtenir les rôles de l'utilisateur
//            Set<Role> userRoles = user.getRoles();
//
//            // Déterminer le rôle principal
//            String currentRole = userRoles.stream()
//                    .map(role -> role.getName().toString())
//                    .filter(roleName -> roleName.equals("CONDUCTEUR") || roleName.equals("PASSAGER"))
//                    .findFirst()
//                    .orElse("PASSAGER"); // Par défaut PASSAGER si aucun rôle trouvé
//
//            Map<String, Object> response = new HashMap<>();
//            response.put("uid", uid);
//            response.put("roles", Collections.singletonMap(currentRole.toLowerCase(), true));
//
//            return ResponseEntity.ok(response);
//
//        } catch (Exception e) {
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
//                    .body(new MessageResponse("Error: " + e.getMessage()));
//        }
//    }


}
