import {Injectable} from '@angular/core';
import Keycloak from 'keycloak-js';
import {UserProfile} from './user-profile';
import {environment} from '../../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class KeycloakService {
  private _keycloak: Keycloak | undefined;
  private _isKeycloakEnabled: boolean = false;

  constructor() {
    // Check if Keycloak is configured in environment
    this._isKeycloakEnabled = !!environment.keycloakUrl && environment.keycloakUrl !== '';
  }

  get keycloak() {
    if (!this._keycloak && this._isKeycloakEnabled) {
      this._keycloak = new Keycloak({
        url: environment.keycloakUrl || 'http://localhost:9090',
        realm: environment.keycloakRealm || 'book-social-network',
        clientId: environment.keycloakClientId || 'bsn'
      });
    }
    return this._keycloak;
  }

  private _profile: UserProfile | undefined;

  get profile(): UserProfile | undefined {
    return this._profile;
  }

  get isEnabled(): boolean {
    return this._isKeycloakEnabled;
  }

  async init() {
    // Skip Keycloak initialization if not configured (production without Keycloak)
    if (!this._isKeycloakEnabled) {
      console.log('Keycloak is disabled - using direct backend authentication');
      return true; // Return true to allow app to continue
    }

    try {
      const authenticated = await this.keycloak?.init({
        onLoad: 'login-required',
      });

      if (authenticated) {
        this._profile = (await this.keycloak?.loadUserProfile()) as UserProfile;
        if (this.keycloak?.token) {
          this._profile.token = this.keycloak.token;
        }
      }
      return authenticated;
    } catch (error) {
      console.error('Keycloak initialization failed:', error);
      console.log('Falling back to direct backend authentication');
      return true; // Allow app to continue without Keycloak
    }
  }

  login() {
    if (!this._isKeycloakEnabled) {
      console.log('Keycloak is disabled - login handled by backend');
      return Promise.resolve();
    }
    return this.keycloak?.login();
  }

  logout() {
    if (!this._isKeycloakEnabled) {
      console.log('Keycloak is disabled - logout handled by backend');
      return Promise.resolve();
    }
    return this.keycloak?.logout({redirectUri: window.location.origin});
  }
}
