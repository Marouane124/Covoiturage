package test;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import static org.junit.jupiter.api.Assertions.*;

public class RegisterTest {
    private WebDriver driver;
    private WebDriverWait wait;
    private JavascriptExecutor js;

    @BeforeEach
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--start-maximized");
        options.addArguments("--headless");
        options.addArguments("--disable-popup-blocking");
        driver = new ChromeDriver(options);
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        js = (JavascriptExecutor) driver;
    }

    private void fillForm(String name, String email, String password, String phone, String gender, String city) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("name"))).sendKeys(name);
        driver.findElement(By.id("email")).sendKeys(email);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("phone")).sendKeys(phone);

        // Utiliser Select pour le menu déroulant du genre
        Select genderSelect = new Select(driver.findElement(By.id("gender")));
        genderSelect.selectByValue(gender);

        driver.findElement(By.id("city")).sendKeys(city);
    }

    private void clickSignupButton() {
        WebElement signupButton = wait.until(ExpectedConditions.elementToBeClickable(
                By.cssSelector("button.signup-button")));
        js.executeScript("arguments[0].scrollIntoView(true);", signupButton);
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        try {
            signupButton.click();
        } catch (ElementClickInterceptedException e) {
            js.executeScript("arguments[0].click();", signupButton);
        }
    }
    @Test
    public void testSuccessfulRegistration() {
        driver.get("http://localhost:4200/signup");
        fillForm("John Doe", "john175.doe@example.com", "Password123!", "1234567890", "Homme", "Paris");
        clickSignupButton();

        try {
            // Attendre que l'alerte soit présente
            WebDriverWait alertWait = new WebDriverWait(driver, Duration.ofSeconds(5));
            Alert alert = alertWait.until(ExpectedConditions.alertIsPresent());

            // Vérifier le message de l'alerte
            assertEquals("Inscription réussie !", alert.getText());

            // Accepter l'alerte
            alert.accept();

            // Maintenant attendre la redirection
            wait.until(ExpectedConditions.urlToBe("http://localhost:4200/login"));
            assertEquals("http://localhost:4200/login", driver.getCurrentUrl());
        } catch (TimeoutException e) {
            fail("La redirection vers la page de login n'a pas eu lieu ou l'alerte n'est pas apparue");
        }
    }

    @Test
    public void testRegistrationWithEmptyFields() {
        driver.get("http://localhost:4200/signup");
        clickSignupButton();

        // Vérifier la présence des attributs required
        assertTrue(driver.findElement(By.id("name")).getAttribute("required") != null);
        assertTrue(driver.findElement(By.id("email")).getAttribute("required") != null);
        assertTrue(driver.findElement(By.id("password")).getAttribute("required") != null);
        assertTrue(driver.findElement(By.id("phone")).getAttribute("required") != null);
        assertTrue(driver.findElement(By.id("gender")).getAttribute("required") != null);
        assertTrue(driver.findElement(By.id("city")).getAttribute("required") != null);
    }

    @Test
    public void testRegistrationWithInvalidEmail() {
        driver.get("http://localhost:4200/signup");
        fillForm("John Doe", "invalid-email", "Password123!", "1234567890", "Homme", "Paris");
        clickSignupButton();

        WebElement errorMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.className("error-message")));
        assertEquals("L'email fourni est invalide. Veuillez vérifier.", errorMessage.getText());
    }

    @Test
    public void testRegistrationWithWeakPassword() {
        driver.get("http://localhost:4200/signup");
        fillForm("John Doe", "john.doe@example.com", "123", "1234567890", "Homme", "Paris");
        clickSignupButton();

        WebElement errorMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.className("error-message")));
        assertEquals("Le mot de passe doit contenir au moins 6 caractères.", errorMessage.getText());
    }

    @Test
    public void testRegistrationWithExistingEmail() {
        driver.get("http://localhost:4200/signup");
        fillForm("John Doe", "test123@gmail.com", "Password123!", "1234567890", "Homme", "Paris");
        clickSignupButton();

        WebElement errorMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.className("error-message")));
        assertEquals("Cet email est déjà utilisé. Veuillez en choisir un autre.", errorMessage.getText());
    }


    @Test
    public void testNavigationToLogin() {
        driver.get("http://localhost:4200/signup");

        // Attendre que le lien soit cliquable
        WebElement loginLink = wait.until(ExpectedConditions.elementToBeClickable(
                By.cssSelector("p.login-link a")));

        // Vérifier le texte complet
        WebElement loginText = driver.findElement(By.cssSelector("p.login-link"));
        assertTrue(loginText.getText().contains("Déjà un compte ?"));
        assertTrue(loginText.getText().contains("Se connecter"));

        try {
            // Faire défiler jusqu'au lien si nécessaire
            js.executeScript("arguments[0].scrollIntoView(true);", loginLink);
            Thread.sleep(500); // Attendre un peu que le défilement soit terminé

            // Cliquer sur le lien
            loginLink.click();
        } catch (ElementClickInterceptedException e) {
            // Si le clic normal échoue, essayer avec JavaScript
            js.executeScript("arguments[0].click();", loginLink);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // Vérifier la redirection
        try {
            wait.until(ExpectedConditions.urlToBe("http://localhost:4200/login"));
            assertEquals("http://localhost:4200/login", driver.getCurrentUrl());
        } catch (TimeoutException e) {
            fail("La redirection vers la page de login n'a pas eu lieu");
        }
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}