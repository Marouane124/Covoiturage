package com.covoiturage.covoiturage.models;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;


@Document(collection = "drivers")
@AllArgsConstructor
@NoArgsConstructor
@Data
public class Driver {
    @Id
    private String id;
    private String userId;
    private String licenseNumber;
    private String vehicleModel;
    private String vehicleYear;
    private String plateNumber;
    private String licenseFrontImage;
    private String licenseBackImage;
    private boolean isVerified;

    public Driver(String userId, String licenseNumber, String vehicleModel, String vehicleYear, String plateNumber, String licenseFrontImage, String licenseBackImage, boolean isVerified) {
        this.userId = userId;
        this.licenseNumber = licenseNumber;
        this.vehicleModel = vehicleModel;
        this.vehicleYear = vehicleYear;
        this.plateNumber = plateNumber;
        this.licenseFrontImage = licenseFrontImage;
        this.licenseBackImage = licenseBackImage;
        this.isVerified = isVerified;
    }


}