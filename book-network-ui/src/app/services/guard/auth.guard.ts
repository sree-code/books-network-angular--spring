import {CanActivateFn, Router} from '@angular/router';
import {TokenService} from '../token/token.service';
import {inject} from '@angular/core';
import {KeycloakService} from '../keycloak/keycloak.service';

export const authGuard: CanActivateFn = () => {
  const keycloakService = inject(KeycloakService);
  const tokenService = inject(TokenService);
  const router = inject(Router);

  // If Keycloak is disabled, use token service for authentication
  if (!keycloakService.isEnabled) {
    if (!tokenService.token) {
      router.navigate(['login']);
      return false;
    }
    return true;
  }

  // Use Keycloak authentication
  if (keycloakService.keycloak?.isTokenExpired()) {
    router.navigate(['login']);
    return false;
  }
  return true;
};
