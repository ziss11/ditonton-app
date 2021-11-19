import 'package:encrypt/encrypt.dart';

String encrypt(String plainText) {
  final key = Key.fromUtf8('My 32 length key................');
  final iv = IV.fromLength(16);

  final encypter = Encrypter(AES(key));

  final excrypted = encypter.encrypt(plainText, iv: iv);

  return excrypted.base64;
}
