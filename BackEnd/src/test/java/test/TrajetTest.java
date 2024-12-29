package test;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class TrajetTest {
    private WebDriver driver;
    private WebDriverWait wait;

    @BeforeEach
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(20));
        driver.manage().window().maximize();
    }

    @Test
    public void testSearchTrajets() throws InterruptedException {
        // Accéder à la page dashboard
        driver.get("http://localhost:4200/dashboard");

        // 1. Cliquer sur "Mes trajets" dans la sidebar
        WebElement mesTrajetsLink = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//a[contains(.,'Mes trajets')]")));
        mesTrajetsLink.click();

        // Attendre que la section des trajets soit chargée
        wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector("div.trajets-container")));

        // 2. Remplir le formulaire de recherche
        WebElement villeDepart = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector("input[placeholder='Ville de départ']")));
        WebElement villeArrivee = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector("input[placeholder=\"Ville d'arrivée\"]")));

        villeDepart.clear();
        villeDepart.sendKeys("casa");

        villeArrivee.clear();
        villeArrivee.sendKeys("nador");

        // 3. Cliquer sur le bouton de recherche
        WebElement searchButton = wait.until(ExpectedConditions.elementToBeClickable(
                By.cssSelector("button.search-button")));
        searchButton.click();

        // 4. Attendre et vérifier les résultats
        WebElement trajetCard = wait.until(ExpectedConditions.visibilityOfElementLocated(
                By.cssSelector("div.trajet-card")));

        // 5. Vérifier l'itinéraire et le prix
        WebElement trajetRoute = trajetCard.findElement(By.cssSelector("div.trajet-route h3"));
        assertTrue(trajetRoute.getText().contains("casa → nador"), "L'itinéraire n'est pas correct");

        WebElement trajetPrice = trajetCard.findElement(By.cssSelector("div.trajet-price"));
        assertTrue(trajetPrice.getText().contains("30Dh"), "Le prix n'est pas correct");
    }


    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}