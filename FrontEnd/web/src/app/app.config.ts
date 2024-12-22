import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { provideRouter } from '@angular/router';
import { routes } from './app.routes';
import { provideFirebaseApp, initializeApp } from '@angular/fire/app';
import { provideAuth, getAuth } from '@angular/fire/auth';
import { provideHttpClient } from '@angular/common/http';

const firebaseConfig = {
  apiKey: "AIzaSyB8DSeRA3fXa0JGlo-h94cjll142sByM8g",
  authDomain: "covoiturage-f8b59.firebaseapp.com",
  projectId: "covoiturage-f8b59",
  storageBucket: "covoiturage-f8b59.firebasestorage.app",
  messagingSenderId: "390254582968",
  appId: "1:390254582968:web:ca5a562c8a8a22845d284d"
};

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes),
    provideHttpClient(),
    provideFirebaseApp(() => initializeApp(firebaseConfig)),
    provideAuth(() => getAuth())
  ],
};

// export const appConfig: ApplicationConfig = {
//   providers: [
//     provideRouter(routes),
//     provideHttpClient(),
//     provideFirebaseApp(() => initializeApp(environment.firebase)),
//     provideAuth(() => getAuth())
//   ]
// };
