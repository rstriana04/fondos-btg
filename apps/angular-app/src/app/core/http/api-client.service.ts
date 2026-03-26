import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, catchError, throwError } from 'rxjs';

@Injectable({ providedIn: 'root' })
export class ApiClientService {
  private readonly http = inject(HttpClient);
  private readonly baseUrl = 'http://localhost:3000';

  get<T>(path: string): Observable<T> {
    return this.http.get<T>(`${this.baseUrl}${path}`).pipe(
      catchError(this.handleError)
    );
  }

  post<T>(path: string, body: unknown): Observable<T> {
    return this.http.post<T>(`${this.baseUrl}${path}`, body).pipe(
      catchError(this.handleError)
    );
  }

  put<T>(path: string, body: unknown): Observable<T> {
    return this.http.put<T>(`${this.baseUrl}${path}`, body).pipe(
      catchError(this.handleError)
    );
  }

  patch<T>(path: string, body: unknown): Observable<T> {
    return this.http.patch<T>(`${this.baseUrl}${path}`, body).pipe(
      catchError(this.handleError)
    );
  }

  delete<T>(path: string): Observable<T> {
    return this.http.delete<T>(`${this.baseUrl}${path}`).pipe(
      catchError(this.handleError)
    );
  }

  private handleError(error: HttpErrorResponse): Observable<never> {
    let message = 'Error desconocido';
    if (error.error instanceof ErrorEvent) {
      message = `Error de red: ${error.error.message}`;
    } else {
      message = error.error?.message || `Error del servidor: ${error.status}`;
    }
    return throwError(() => new Error(message));
  }
}
