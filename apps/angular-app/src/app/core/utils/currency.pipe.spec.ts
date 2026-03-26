import { CopCurrencyPipe } from './currency.pipe';

describe('CopCurrencyPipe', () => {
  let pipe: CopCurrencyPipe;

  beforeEach(() => {
    pipe = new CopCurrencyPipe();
  });

  it('should format 500000 as $500.000', () => {
    expect(pipe.transform(500000)).toBe('$500.000');
  });

  it('should format 75000 as $75.000', () => {
    expect(pipe.transform(75000)).toBe('$75.000');
  });

  it('should format 0 as $0', () => {
    expect(pipe.transform(0)).toBe('$0');
  });

  it('should format 1000000 as $1.000.000', () => {
    expect(pipe.transform(1000000)).toBe('$1.000.000');
  });

  it('should handle null as $0', () => {
    expect(pipe.transform(null)).toBe('$0');
  });

  it('should handle undefined as $0', () => {
    expect(pipe.transform(undefined)).toBe('$0');
  });
});
