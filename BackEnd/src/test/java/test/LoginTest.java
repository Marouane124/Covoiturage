package test;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class LoginTest {
    private WebDriver driver;
    private WebDriverWait wait;

    @BeforeEach
    public void setUp() {
        System.setProperty("webdriver.chrome.driver", "C:\\chromedriver.exe");

        // Configurer les options Chrome pour le mode headless
        ChromeOptions options = new ChromeOptions();
        //options.addArguments("--headless"); // Activer le mode headless
        options.addArguments("--start-maximized");
        options.addArguments("--disable-popup-blocking");
        options.addArguments("--disable-notifications");
        options.addArguments("--window-size=1920,1080"); // Définir une taille de fenêtre standard

        driver = new ChromeDriver(options);
        wait = new WebDriverWait(driver, Duration.ofSeconds(60));
    }

    @Test
    public void testValidLogin() {
        // Cas 1: Email et mot de passe valides
        driver.get("http://localhost:4200/login");
        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
        driver.findElement(By.name("password")).sendKeys("Test@123");
        clickLoginButton();

        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/dashboard"));
        String expectedUrl = "http://localhost:4200/dashboard";
        assertEquals(expectedUrl, driver.getCurrentUrl());
    }

    @Test
    public void testValidEmailInvalidPassword() {
        // Cas 2: Email valide et mot de passe invalide
        driver.get("http://localhost:4200/login");
        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
        driver.findElement(By.name("password")).sendKeys("WrongPassword");
        clickLoginButton();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        String errorMessage = driver.findElement(By.className("error-message")).getText();
        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
    }

    @Test
    public void testInvalidEmailValidPassword() {
        // Cas 3: Email invalide et mot de passe valide
        driver.get("http://localhost:4200/login");
        driver.findElement(By.name("email")).sendKeys("invalid@example.com");
        driver.findElement(By.name("password")).sendKeys("Test@123");
        clickLoginButton();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        String errorMessage = driver.findElement(By.className("error-message")).getText();
        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
    }

    @Test
    public void testInvalidEmailInvalidPassword() {
        // Cas 4: Email et mot de passe invalides
        driver.get("http://localhost:4200/login");
        driver.findElement(By.name("email")).sendKeys("invalid@example.com");
        driver.findElement(By.name("password")).sendKeys("WrongPassword");
        clickLoginButton();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        String errorMessage = driver.findElement(By.className("error-message")).getText();
        assertEquals("Mot de passe incorrect ou email invalide.", errorMessage);
    }

    @Test
    public void testPasswordVisibilityToggle() {
        // Ouvrir l'application
        driver.get("http://localhost:4200/login");

        // Saisir l'email et le mot de passe
        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
        driver.findElement(By.name("password")).sendKeys("Test@123");

        // Trouver l'icône de l'œil
        WebElement eyeIcon = driver.findElement(By.cssSelector("i.fas.fa-eye")); // Assurez-vous que le sélecteur est correct

        // Vérifier que le mot de passe est masqué par défaut
        WebElement passwordField = driver.findElement(By.name("password"));
        assertEquals("password", passwordField.getAttribute("type"));

        // Cliquer sur l'icône de l'œil pour afficher le mot de passe
        eyeIcon.click();
        assertEquals("text", passwordField.getAttribute("type")); // Vérifier que le mot de passe est visible

        // Cliquer à nouveau sur l'icône de l'œil pour masquer le mot de passe
        eyeIcon.click();
        assertEquals("password", passwordField.getAttribute("type")); // Vérifier que le mot de passe est masqué
    }
    @Test
    public void testRememberMeFunctionality() {
        // Cas 5: Tester la fonctionnalité "Se souvenir de moi"
        driver.get("http://localhost:4200/login");

        // Saisir l'email et le mot de passe
        driver.findElement(By.name("email")).sendKeys("test123@gmail.com");
        driver.findElement(By.name("password")).sendKeys("Test@123");

        // Cocher la case "Se souvenir de moi"
        WebElement rememberMeCheckbox = driver.findElement(By.id("rememberMe"));
        if (!rememberMeCheckbox.isSelected()) {
            rememberMeCheckbox.click();
        }

        clickLoginButton();

        // Attendre que l'URL change
        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/dashboard"));

        // Vérifier que la redirection est correcte
        String expectedUrl = "http://localhost:4200/dashboard";
        assertEquals(expectedUrl, driver.getCurrentUrl());

        // Fermer le navigateur
        driver.quit();

        // Rouvrir le navigateur
        driver = new ChromeDriver(new ChromeOptions().addArguments("--headless"));
        wait = new WebDriverWait(driver, Duration.ofSeconds(60));

        // Accéder à la page de connexion
        driver.get("http://localhost:4200/login");

        // Attendre que les champs soient remplis
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("email")));
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("password")));

        // Vérifier que les champs sont pré-remplis
        String emailValue = driver.findElement(By.name("email")).getAttribute("value");
        String passwordValue = driver.findElement(By.name("password")).getAttribute("value");

        assertEquals("test123@gmail.com", emailValue);
        // Vérifiez si le mot de passe est également pré-rempli
        assertEquals("Test@123", passwordValue); // Si le mot de passe est stocké, sinon ignorez cette ligne
    }

    @Test
    public void testLogoutFunctionality() {
        // Cas 6: Tester la fonctionnalité de déconnexion
        testValidLogin(); // Se connecter d'abord

        // Cliquer sur le lien de déconnexion
        WebElement logoutLink = wait.until(ExpectedConditions.elementToBeClickable(By.className("logout-link")));
        logoutLink.click();

        // Vérifier que l'utilisateur est redirigé vers la page de connexion
        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/login"));
        String expectedUrl = "http://localhost:4200/login";
        assertEquals(expectedUrl, driver.getCurrentUrl());
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