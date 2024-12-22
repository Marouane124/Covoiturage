package com.covoiturage.covoiturage.models;

import java.time.Instant;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Data;

@Document(collection = "refreshtokens")
@Data
public class RefreshToken {
    @Id
    private String id;
    private String token;
    private Instant expiryDate;
    private String userId;
}
