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
    @Test
    public void testSignupLinkClick() throws InterruptedException {
        driver.get("http://localhost:4200/login");
        WebElement signupLink = wait.until(ExpectedConditions.presenceOfElementLocated(By.linkText("S'inscrire")));
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", signupLink);
        wait.until(ExpectedConditions.urlToBe("http://localhost:4200/signup"));
        assertEquals("http://localhost:4200/signup", driver.getCurrentUrl());
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