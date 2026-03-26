import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'fundName',
  standalone: true,
})
export class FundNamePipe implements PipeTransform {
  transform(value: string | null | undefined): string {
    if (!value) return '';
    return value
      .split('_')
      .map((word) => this.capitalize(word))
      .join(' ')
      .replace(/-/g, ' ');
  }

  private capitalize(word: string): string {
    if (!word) return '';
    // Keep acronyms like BTG, FPV, FDO uppercase if they are short
    if (word.length <= 3 && word === word.toUpperCase()) {
      return word;
    }
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  }
}
