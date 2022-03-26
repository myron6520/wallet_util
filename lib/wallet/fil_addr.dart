import 'dart:typed_data';

import 'package:base32/encodings.dart';
import 'package:convert/convert.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:pointycastle/digests/blake2b.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:base32/base32.dart';

class FilAddr {
  final int index;
  final Chain chain;
  FilAddr({this.index = 0, required this.chain});

  late final String addr = (() {
    ExtendedKey key = chain.forPath("m/44'/461'/0'/0/$index");
    String privateKeyHex = key.privateKeyHex();
    PublicKey publicKey = PrivateKey.fromHex(privateKeyHex).publicKey;
    Blake2bDigest digest = Blake2bDigest(digestSize: 20);
    Uint8List hash =
        digest.process(Uint8List.fromList(hex.decode(publicKey.toHex())));
    String hashStr = hex.encode(hash);
    String checkStr = "01" + hashStr;
    Blake2bDigest checkSumDigest = Blake2bDigest(digestSize: 4);
    Uint8List checkSum =
        checkSumDigest.process(Uint8List.fromList(hex.decode(checkStr)));
    String addr = "f1" +
        base32
            .encodeHexString(
              hashStr + hex.encode(checkSum),
              encoding: Encoding.standardRFC4648,
            )
            .toLowerCase();
    if (addr.endsWith("=")) {
      addr = addr.substring(0, addr.length - 1);
    }
    return addr;
  }).call();
}
