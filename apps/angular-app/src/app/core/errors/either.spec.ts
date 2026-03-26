import { Left, Right, left, right } from './either';

describe('Either', () => {
  describe('Left', () => {
    it('should be left', () => {
      const l = left('error');
      expect(l.isLeft()).toBeTrue();
      expect(l.isRight()).toBeFalse();
    });

    it('should fold with left function', () => {
      const l = left('error');
      const result = l.fold(
        (e) => `Error: ${e}`,
        () => 'Success',
      );
      expect(result).toBe('Error: error');
    });

    it('should return default value on getOrElse', () => {
      const l = left('error');
      expect(l.getOrElse(42)).toBe(42);
    });
  });

  describe('Right', () => {
    it('should be right', () => {
      const r = right(42);
      expect(r.isRight()).toBeTrue();
      expect(r.isLeft()).toBeFalse();
    });

    it('should fold with right function', () => {
      const r = right(42);
      const result = r.fold(
        () => 'Error',
        (v) => `Value: ${v}`,
      );
      expect(result).toBe('Value: 42');
    });

    it('should map the value', () => {
      const r = right(21);
      const mapped = r.map((v) => v * 2);
      expect(mapped.isRight()).toBeTrue();
      mapped.fold(
        () => fail('Should be Right'),
        (v) => expect(v).toBe(42),
      );
    });

    it('should return value on getOrElse', () => {
      const r = right(42);
      expect(r.getOrElse(0)).toBe(42);
    });
  });
});
