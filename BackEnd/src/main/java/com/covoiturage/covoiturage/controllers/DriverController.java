package com.covoiturage.covoiturage.controllers;

import com.covoiturage.covoiturage.models.Driver;
import com.covoiturage.covoiturage.services.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;
import java.util.Optional;

@RestController
@RequestMapping("/api/drivers")
public class DriverController {
    @Autowired
    private DriverService driverService;

    @PostMapping("/register")
    public ResponseEntity<?> registerDriver(
            @RequestParam("uid") String userId,
            @RequestParam("licenseNumber") String licenseNumber,
            @RequestParam("vehicleModel") String vehicleModel,
            @RequestParam("vehicleYear") String vehicleYear,
            @RequestParam("plateNumber") String plateNumber,
            @RequestParam("licenseFrontImage") MultipartFile licenseFrontImage,
            @RequestParam("licenseBackImage") MultipartFile licenseBackImage) {

        try {
            // Convert images to Base64 or binary as needed
            String licenseFrontImageBase64 = Base64.getEncoder().encodeToString(licenseFrontImage.getBytes());
            String licenseBackImageBase64 = Base64.getEncoder().encodeToString(licenseBackImage.getBytes());

            // Create a Driver object
            Driver driver = new Driver(userId, licenseNumber, vehicleModel, vehicleYear, plateNumber, licenseFrontImageBase64, licenseBackImageBase64, false);

            // Save the driver
            Driver createdDriver = driverService.createDriver(driver);

            // Return success response
            return ResponseEntity.status(HttpStatus.CREATED).body(createdDriver);
        } catch (Exception e) {
            // Log the error for debugging
            System.err.println("Error during driver registration: " + e.getMessage());

            // Return error response
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Registration failed: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Driver> getDriver(@PathVariable String id) {
        Optional<Driver> driver = driverService.getDriver(id);
        return driver.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}")
    public ResponseEntity<Driver> updateDriver(@PathVariable String id, @RequestBody Driver driver) {
        Driver updatedDriver = driverService.updateDriver(id, driver);
        return ResponseEntity.ok(updatedDriver);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDriver(@PathVariable String id) {
        driverService.deleteDriver(id);
        return ResponseEntity.noContent().build();
    }
}
