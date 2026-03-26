import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'friendlyDate',
  standalone: true,
})
export class FriendlyDatePipe implements PipeTransform {
  transform(value: string | Date | null | undefined): string {
    if (!value) return '';
    const date = typeof value === 'string' ? new Date(value) : value;
    return date.toLocaleDateString('es-CO', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  }
}
