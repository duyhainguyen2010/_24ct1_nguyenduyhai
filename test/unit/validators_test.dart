import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    test('validateFullName accepts valid names', () {
      expect(Validators.validateFullName('Nguyễn Văn A'), isNull);
      expect(Validators.validateFullName('An'), isNull);
    });

    test('validateFullName rejects empty or short names', () {
      expect(Validators.validateFullName(''), isNotNull);
      expect(Validators.validateFullName(' '), isNotNull);
      expect(Validators.validateFullName('A'), isNotNull);
    });

    test('validateEmail accepts valid emails', () {
      expect(Validators.validateEmail('user@domain.com'), isNull);
      expect(Validators.validateEmail('student@university.edu.vn'), isNull);
    });

    test('validateEmail rejects invalid emails', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail('invalid-email'), isNotNull);
      expect(Validators.validateEmail('@domain.com'), isNotNull);
    });

    test('validatePassword accepts 6+ chars with letters and numbers', () {
      expect(Validators.validatePassword('pass123'), isNull);
      expect(Validators.validatePassword('Secret99'), isNull);
    });

    test('validatePassword rejects weak or short passwords', () {
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('abcdef'), isNotNull); // no numbers
      expect(Validators.validatePassword('123456'), isNotNull); // no letters
    });

    test('validateConfirmPassword checks matching', () {
      expect(Validators.validateConfirmPassword('pass123', 'pass123'), isNull);
      expect(Validators.validateConfirmPassword('pass123', 'different'), isNotNull);
    });
  });
}
