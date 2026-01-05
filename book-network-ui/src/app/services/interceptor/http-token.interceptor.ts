import {Injectable} from '@angular/core';
import {HttpEvent, HttpHandler, HttpHeaders, HttpInterceptor, HttpRequest} from '@angular/common/http';
import {Observable} from 'rxjs';
import {KeycloakService} from '../keycloak/keycloak.service';
import {TokenService} from '../token/token.service';

@Injectable()
export class HttpTokenInterceptor implements HttpInterceptor {

  constructor(
    private keycloakService: KeycloakService,
    private tokenService: TokenService
  ) {}

  intercept(request: HttpRequest<unknown>, next: HttpHandler): Observable<HttpEvent<unknown>> {
    let token: string | undefined;

    // Try to get token from Keycloak if enabled
    if (this.keycloakService.isEnabled && this.keycloakService.keycloak) {
      token = this.keycloakService.keycloak.token;
    }

    // Fallback to TokenService if Keycloak is disabled or no token
    if (!token && this.tokenService.token) {
      token = this.tokenService.token;
    }

    // Add token to request if available
    if (token) {
      const authReq = request.clone({
        headers: new HttpHeaders({
          Authorization: `Bearer ${token}`
        })
      });
      return next.handle(authReq);
    }

    return next.handle(request);
  }
}
