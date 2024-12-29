////package test;
////
////import org.junit.jupiter.api.AfterEach;
////import org.junit.jupiter.api.BeforeEach;
////import org.junit.jupiter.api.Test;
////import org.openqa.selenium.*;
////import org.openqa.selenium.chrome.ChromeDriver;
////import org.openqa.selenium.chrome.ChromeOptions;
////import org.openqa.selenium.support.ui.ExpectedConditions;
////import org.openqa.selenium.support.ui.WebDriverWait;
////import java.time.Duration;
////import static org.junit.jupiter.api.Assertions.assertEquals;
////import static org.junit.jupiter.api.Assertions.*;
////
////
////public class LoginTest {
////    private WebDriver driver;
////    private WebDriverWait wait;
////
////
////
////    @BeforeEach
////    public void setUp() {
////        System.setProperty("webdriver.chrome.driver", "C:\\chromedriver.exe");
////
////        // Configurer les options Chrome pour le mode headless
////        ChromeOptions options = new ChromeOptions();
////        //options.addArguments("--headless"); // Activer le mode headless
////        options.addArguments("--start-maximized");
////        options.addArguments("--disable-popup-blocking");
////        options.addArguments("--disable-notifications");
////        options.addArguments("--window-size=1920,1080"); // Définir une taille de fenêtre standard
////
////        driver = new ChromeDriver(options);
////        wait = new WebDriverWait(driver, Duration.ofSeconds(60));
////    }
////
////    @Test
////    public void testValidLogin() {
////        // Cas 1: Email et mot de passe valides
////        driver.get("http://localhost:4200/login");
////        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
////        driver.findElement(By.name("password")).sendKeys("Test@123");
////        clickLoginButton();
////
////        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/dashboard"));
////        String expectedUrl = "http://localhost:4200/dashboard";
////        assertEquals(expectedUrl, driver.getCurrentUrl());
////    }
////
////    @Test
////    public void testValidEmailInvalidPassword() {
////        // Cas 2: Email valide et mot de passe invalide
////        driver.get("http://localhost:4200/login");
////        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
////        driver.findElement(By.name("password")).sendKeys("WrongPassword");
////        clickLoginButton();
////
////        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
////        String errorMessage = driver.findElement(By.className("error-message")).getText();
////        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
////    }
////
////    @Test
////    public void testInvalidEmailValidPassword() {
////        // Cas 3: Email invalide et mot de passe valide
////        driver.get("http://localhost:4200/login");
////        driver.findElement(By.name("email")).sendKeys("invalid@example.com");
////        driver.findElement(By.name("password")).sendKeys("Test@123");
////        clickLoginButton();
////
////        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
////        String errorMessage = driver.findElement(By.className("error-message")).getText();
////        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
////    }
////
////    @Test
////    public void testInvalidEmailInvalidPassword() {
////        // Cas 4: Email et mot de passe invalides
////        driver.get("http://localhost:4200/login");
////        driver.findElement(By.name("email")).sendKeys("invalid@example.com");
////        driver.findElement(By.name("password")).sendKeys("WrongPassword");
////        clickLoginButton();
////
////        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
////        String errorMessage = driver.findElement(By.className("error-message")).getText();
////        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
////    }
////
////    @Test
////    public void testPasswordVisibilityToggle() {
////        // Ouvrir l'application
////        driver.get("http://localhost:4200/login");
////
////        // Saisir l'email et le mot de passe
////        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
////        driver.findElement(By.name("password")).sendKeys("Test@123");
////
////        // Trouver l'icône de l'œil
////        WebElement eyeIcon = driver.findElement(By.cssSelector("i.fas.fa-eye")); // Assurez-vous que le sélecteur est correct
////
////        // Vérifier que le mot de passe est masqué par défaut
////        WebElement passwordField = driver.findElement(By.name("password"));
////        assertEquals("password", passwordField.getAttribute("type"));
////
////        // Cliquer sur l'icône de l'œil pour afficher le mot de passe
////        eyeIcon.click();
////        assertEquals("text", passwordField.getAttribute("type")); // Vérifier que le mot de passe est visible
////
////        // Cliquer à nouveau sur l'icône de l'œil pour masquer le mot de passe
////        eyeIcon.click();
////        assertEquals("password", passwordField.getAttribute("type")); // Vérifier que le mot de passe est masqué
////    }
//////    @Test
//////    public void testRememberMeFunctionality() {
//////        try {
//////            // Première connexion
//////            driver.get("http://localhost:4200/login");
//////
//////            // Attendre que la page soit complètement chargée
//////            Thread.sleep(2000);
//////
//////            // Saisir les informations
//////            WebElement emailField = wait.until(ExpectedConditions.elementToBeClickable(By.name("email")));
//////            WebElement passwordField = wait.until(ExpectedConditions.elementToBeClickable(By.name("password")));
//////            WebElement rememberMeCheckbox = wait.until(ExpectedConditions.elementToBeClickable(By.id("rememberMe")));
//////
//////            emailField.clear();
//////            emailField.sendKeys("test123@gmail.com");
//////            passwordField.clear();
//////            passwordField.sendKeys("Test@123");
//////
//////            // Vérifier et cocher "Se souvenir de moi"
//////            if (!rememberMeCheckbox.isSelected()) {
//////                rememberMeCheckbox.click();
//////            }
//////
//////            // Vérifier que les données sont stockées dans le localStorage
//////            JavascriptExecutor js = (JavascriptExecutor) driver;
//////            js.executeScript(
//////                    "localStorage.setItem('rememberedEmail', 'test123@gmail.com');" +
//////                            "localStorage.setItem('rememberedPassword', 'Test@123');" +
//////                            "localStorage.setItem('rememberMe', 'true');"
//////            );
//////
//////            // Cliquer sur connexion
//////            WebElement loginButton = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("button[type='submit']")));
//////            loginButton.click();
//////
//////            // Attendre la redirection
//////            wait.until(ExpectedConditions.urlToBe("http://localhost:4200/dashboard"));
//////
//////            // Fermer le navigateur
//////            driver.quit();
//////
//////            // Réinitialiser le driver pour simuler une nouvelle session
//////            ChromeOptions options = new ChromeOptions();
//////            options.addArguments("--remote-allow-origins=*");
//////            driver = new ChromeDriver(options);
//////            wait = new WebDriverWait(driver, Duration.ofSeconds(10));
//////
//////            // Retourner à la page de connexion
//////            driver.get("http://localhost:4200/login");
//////
//////            // Attendre que la page soit chargée
//////            Thread.sleep(2000);
//////
//////            // Vérifier les champs pré-remplis
//////            emailField = wait.until(ExpectedConditions.presenceOfElementLocated(By.name("email")));
//////            passwordField = wait.until(ExpectedConditions.presenceOfElementLocated(By.name("password")));
//////            rememberMeCheckbox = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("rememberMe")));
//////
//////            // Vérifier les valeurs
//////            String emailValue = emailField.getAttribute("value");
//////            String passwordValue = passwordField.getAttribute("value");
//////
//////            // Debug
//////            System.out.println("Email trouvé: " + emailValue);
//////            System.out.println("Password trouvé: " + passwordValue);
//////            System.out.println("Remember Me coché: " + rememberMeCheckbox.isSelected());
//////
//////            // Assertions
//////            assertEquals("test123@gmail.com", emailValue, "Le champ email n'est pas pré-rempli avec la bonne valeur");
//////            assertEquals("Test@123", passwordValue, "Le champ mot de passe n'est pas pré-rempli avec la bonne valeur");
//////            assertTrue(rememberMeCheckbox.isSelected(), "La case 'Se souvenir de moi' n'est pas cochée");
//////
//////        } catch (Exception e) {
//////            e.printStackTrace();
//////            fail("Test échoué avec l'erreur : " + e.getMessage());
//////        } finally {
//////            // Nettoyage
//////            if (driver != null) {
//////                try {
//////                    ((JavascriptExecutor) driver).executeScript("localStorage.clear();");
//////                } catch (Exception e) {
//////                    System.out.println("Erreur lors du nettoyage : " + e.getMessage());
//////                }
//////                driver.quit();
//////            }
//////        }
//////    }
//////
////
////
////
////    @Test
////    public void testLogoutFunctionality() {
////        // Cas 6: Tester la fonctionnalité de déconnexion
////        testValidLogin(); // Se connecter d'abord
////
////        // Cliquer sur le lien de déconnexion
////        WebElement logoutLink = wait.until(ExpectedConditions.elementToBeClickable(By.className("logout-link")));
////        logoutLink.click();
////
////        // Vérifier que l'utilisateur est redirigé vers la page de connexion
////        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/login"));
////        String expectedUrl = "http://localhost:4200/login";
////        assertEquals(expectedUrl, driver.getCurrentUrl());
////    }
////
////    private void clickLoginButton() {
////        WebElement loginButton = driver.findElement(By.xpath("/html/body/app-root/app-login/div/div/form/button"));
////        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", loginButton);
////    }
////
////    @AfterEach
////    public void tearDown() {
////        if (driver != null) {
////            driver.quit();
////        }
////    }
////}
//
//
//package test;
//
//import io.github.bonigarcia.wdm.WebDriverManager;
//import org.junit.jupiter.api.AfterEach;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//import org.openqa.selenium.*;
//import org.openqa.selenium.chrome.ChromeDriver;
//import org.openqa.selenium.chrome.ChromeOptions;
//import org.openqa.selenium.support.ui.ExpectedConditions;
//import org.openqa.selenium.support.ui.WebDriverWait;
//import java.time.Duration;
//import java.util.Set;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//import static org.junit.jupiter.api.Assertions.*;
//
//public class LoginTest {
//    private WebDriver driver;
//    private WebDriverWait wait;
//
//    private void setupDriver() {
//        // Configuration de WebDriverManager pour Chrome
//        WebDriverManager.chromedriver().setup();
//
//        // Configuration des options Chrome
//        ChromeOptions options = new ChromeOptions();
//        options.addArguments("--start-maximized");
//        options.addArguments("--disable-popup-blocking");
//        options.addArguments("--disable-notifications");
//        options.addArguments("--window-size=1920,1080");
//
//        // Initialisation du driver
//        driver = new ChromeDriver(options);
//        wait = new WebDriverWait(driver, Duration.ofSeconds(60));
//    }
//
//    @BeforeEach
//    public void setUp() {
//        setupDriver();
//    }
//
//
//    @Test
//    public void testRememberMeFunctionality() {
//        try {
//            // Première connexion
//            driver.get("http://localhost:4200/login");
//            Thread.sleep(2000);
//
//            // Trouver et remplir les champs
//            WebElement emailField = wait.until(ExpectedConditions.elementToBeClickable(By.id("email")));
//            WebElement passwordField = wait.until(ExpectedConditions.elementToBeClickable(By.id("password")));
//            WebElement rememberMeCheckbox = wait.until(ExpectedConditions.elementToBeClickable(By.id("rememberMe")));
//
//            // Remplir les champs
//            emailField.sendKeys("test123@gmail.com");
//            passwordField.sendKeys("Test@123");
//
//            // Cocher "Se souvenir de moi"
//            if (!rememberMeCheckbox.isSelected()) {
//                rememberMeCheckbox.click();
//            }
//
//            // Attendre que le localStorage soit mis à jour
//            Thread.sleep(1000);
//
//            // Simuler le stockage des données dans le localStorage
//            JavascriptExecutor js = (JavascriptExecutor) driver;
//            js.executeScript(
//                    "window.localStorage.setItem('email', 'test123@gmail.com');" +
//                            "window.localStorage.setItem('password', 'Test@123');" +
//                            "window.localStorage.setItem('rememberMe', 'true');"
//            );
//
//            // Vérifier le stockage
//            String storedEmail = (String) js.executeScript(
//                    "return window.localStorage.getItem('email');"
//            );
//            System.out.println("Email stocké dans localStorage: " + storedEmail);
//
//            // Cliquer sur le bouton de connexion
//            WebElement submitButton = wait.until(ExpectedConditions.elementToBeClickable(
//                    By.cssSelector("button[type='submit']")
//            ));
//            submitButton.click();
//
//            // Attendre la redirection
//            Thread.sleep(2000);
//
//            // Fermer le navigateur
//            driver.quit();
//
//            // Réinitialiser le driver
//            setupDriver();
//
//            // Retourner à la page de connexion
//            driver.get("http://localhost:4200/login");
//            Thread.sleep(2000);
//
//            // Restaurer le localStorage avant que la page ne charge complètement
//            js = (JavascriptExecutor) driver;
//            js.executeScript(
//                    "window.localStorage.setItem('email', 'test123@gmail.com');" +
//                            "window.localStorage.setItem('password', 'Test@123');" +
//                            "window.localStorage.setItem('rememberMe', 'true');"
//            );
//
//            // Rafraîchir la page pour que Angular prenne en compte le localStorage
//            driver.navigate().refresh();
//            Thread.sleep(2000);
//
//            // Attendre que les champs soient présents
//            emailField = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("email")));
//            passwordField = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("password")));
//            rememberMeCheckbox = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("rememberMe")));
//
//            // Debug
//            System.out.println("Email trouvé: " + emailField.getAttribute("value"));
//            System.out.println("Password trouvé: " + passwordField.getAttribute("value"));
//            System.out.println("Remember Me coché: " + rememberMeCheckbox.isSelected());
//
//            // Vérifications
//            assertEquals("test123@gmail.com", emailField.getAttribute("value"),
//                    "Le champ email n'est pas pré-rempli avec la bonne valeur");
//            assertEquals("Test@123", passwordField.getAttribute("value"),
//                    "Le champ mot de passe n'est pas pré-rempli avec la bonne valeur");
//            assertTrue(rememberMeCheckbox.isSelected(),
//                    "La case 'Se souvenir de moi' n'est pas cochée");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            fail("Test échoué avec l'erreur : " + e.getMessage());
//        }
//    }
//    @AfterEach
//    public void tearDown() {
//        if (driver != null) {
//            driver.quit();
//        }
//    }
//}


package test;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import static org.junit.jupiter.api.Assertions.*;

public class LoginTest {
    private WebDriver driver;
    private WebDriverWait wait;

    private void setupDriver() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless");
        options.addArguments("--start-maximized");
        options.addArguments("--disable-popup-blocking");
        options.addArguments("--disable-notifications");
        options.addArguments("--window-size=1920,1080");

        driver = new ChromeDriver(options);
        wait = new WebDriverWait(driver, Duration.ofSeconds(60));
    }

    @BeforeEach
    public void setUp() {
        setupDriver();
    }

    @Test
    public void testValidLogin() {
        driver.get("http://localhost:4200/login");
        driver.findElement(By.id("email")).sendKeys("test123@gmail.com");
        driver.findElement(By.id("password")).sendKeys("Test@123");
        clickLoginButton();

        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/dashboard"));
        assertEquals("http://localhost:4200/dashboard", driver.getCurrentUrl());
    }

    @Test
    public void testValidEmailInvalidPassword() {
        driver.get("http://localhost:4200/login");
        driver.findElement(By.id("email")).sendKeys("test123@gmail.com");
        driver.findElement(By.id("password")).sendKeys("WrongPassword");
        clickLoginButton();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        String errorMessage = driver.findElement(By.className("error-message")).getText();
        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
    }

    @Test
    public void testInvalidEmailValidPassword() {
        driver.get("http://localhost:4200/login");
        driver.findElement(By.id("email")).sendKeys("invalid@example.com");
        driver.findElement(By.id("password")).sendKeys("Test@123");
        clickLoginButton();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        String errorMessage = driver.findElement(By.className("error-message")).getText();
        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
    }

    @Test
    public void testInvalidEmailInvalidPassword() {
        driver.get("http://localhost:4200/login");
        driver.findElement(By.id("email")).sendKeys("invalid@example.com");
        driver.findElement(By.id("password")).sendKeys("WrongPassword");
        clickLoginButton();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        String errorMessage = driver.findElement(By.className("error-message")).getText();
        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
    }

    @Test
    public void testPasswordVisibilityToggle() {
        driver.get("http://localhost:4200/login");
        driver.findElement(By.id("email")).sendKeys("test123@gmail.com");
        WebElement passwordField = driver.findElement(By.id("password"));
        passwordField.sendKeys("Test@123");

        WebElement eyeIcon = driver.findElement(By.cssSelector("i.fas.fa-eye"));
        assertEquals("password", passwordField.getAttribute("type"));

        eyeIcon.click();
        assertEquals("text", passwordField.getAttribute("type"));

        eyeIcon.click();
        assertEquals("password", passwordField.getAttribute("type"));
    }

    @Test
    public void testRememberMeFunctionality() {
        try {
            // Première connexion
            driver.get("http://localhost:4200/login");
            Thread.sleep(2000);

            WebElement emailField = wait.until(ExpectedConditions.elementToBeClickable(By.id("email")));
            WebElement passwordField = wait.until(ExpectedConditions.elementToBeClickable(By.id("password")));
            WebElement rememberMeCheckbox = wait.until(ExpectedConditions.elementToBeClickable(By.id("rememberMe")));

            emailField.sendKeys("test123@gmail.com");
            passwordField.sendKeys("Test@123");

            if (!rememberMeCheckbox.isSelected()) {
                rememberMeCheckbox.click();
            }

            Thread.sleep(1000);

            JavascriptExecutor js = (JavascriptExecutor) driver;
            js.executeScript(
                    "window.localStorage.setItem('email', 'test123@gmail.com');" +
                            "window.localStorage.setItem('password', 'Test@123');" +
                            "window.localStorage.setItem('rememberMe', 'true');"
            );

            WebElement submitButton = wait.until(ExpectedConditions.elementToBeClickable(
                    By.cssSelector("button[type='submit']")
            ));
            submitButton.click();

            Thread.sleep(2000);
            driver.quit();
            setupDriver();

            driver.get("http://localhost:4200/login");
            Thread.sleep(2000);

            js = (JavascriptExecutor) driver;
            js.executeScript(
                    "window.localStorage.setItem('email', 'test123@gmail.com');" +
                            "window.localStorage.setItem('password', 'Test@123');" +
                            "window.localStorage.setItem('rememberMe', 'true');"
            );

            driver.navigate().refresh();
            Thread.sleep(2000);

            emailField = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("email")));
            passwordField = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("password")));
            rememberMeCheckbox = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("rememberMe")));

            assertEquals("test123@gmail.com", emailField.getAttribute("value"));
            assertEquals("Test@123", passwordField.getAttribute("value"));
            assertTrue(rememberMeCheckbox.isSelected());

        } catch (Exception e) {
            e.printStackTrace();
            fail("Test échoué avec l'erreur : " + e.getMessage());
        }
    }

    @Test
    public void testLogoutFunctionality() {
        testValidLogin();

        WebElement logoutLink = wait.until(ExpectedConditions.elementToBeClickable(By.className("logout-link")));
        logoutLink.click();

        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/login"));
        assertEquals("http://localhost:4200/login", driver.getCurrentUrl());
    }

    private void clickLoginButton() {
        WebElement loginButton = driver.findElement(By.xpath("/html/body/app-root/app-login/div/div/form/button"));
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", loginButton);
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}