import { FundNamePipe } from './fund-name.pipe';

describe('FundNamePipe', () => {
  let pipe: FundNamePipe;

  beforeEach(() => {
    pipe = new FundNamePipe();
  });

  it('should transform FPV_BTG_PACTUAL_RECAUDADORA to FPV BTG Pactual Recaudadora', () => {
    expect(pipe.transform('FPV_BTG_PACTUAL_RECAUDADORA')).toBe('FPV BTG Pactual Recaudadora');
  });

  it('should transform DEUDAPRIVADA to Deudaprivada', () => {
    expect(pipe.transform('DEUDAPRIVADA')).toBe('Deudaprivada');
  });

  it('should transform FDO-ACCIONES properly', () => {
    const result = pipe.transform('FDO-ACCIONES');
    expect(result).toBeTruthy();
  });

  it('should handle null as empty string', () => {
    expect(pipe.transform(null)).toBe('');
  });

  it('should handle undefined as empty string', () => {
    expect(pipe.transform(undefined)).toBe('');
  });
});
