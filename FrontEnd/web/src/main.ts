// import { bootstrapApplication } from '@angular/platform-browser';
// import { AppComponent } from './app/app.component';
// import { provideFirebaseApp, initializeApp } from '@angular/fire/app';
// import { provideAuth, getAuth } from '@angular/fire/auth';
// import { routes } from './app/app.routes';
// import { appConfig } from './app/app.config';
// import { provideHttpClient } from '@angular/common/http';
// import { provideRouter } from '@angular/router';

// bootstrapApplication(AppComponent, {
//   providers: [
//     provideRouter(routes),
//     provideHttpClient()
//   ]
// }).catch(err => console.error(err));



import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { provideFirebaseApp, initializeApp } from '@angular/fire/app';
import { provideAuth, getAuth } from '@angular/fire/auth';
import { routes } from './app/app.routes';
import { appConfig } from './app/app.config';
import { provideHttpClient } from '@angular/common/http';
import { provideRouter } from '@angular/router';
import { environment } from './environments/environment'; // Assurez-vous que l'environnement est correctement configuré

bootstrapApplication(AppComponent, {
  providers: [
    provideRouter(routes),
    provideHttpClient(),
    // Configuration Firebase
    provideFirebaseApp(() => initializeApp(environment.firebase)),
    provideAuth(() => getAuth()),
  ]
}).catch(err => console.error(err));
