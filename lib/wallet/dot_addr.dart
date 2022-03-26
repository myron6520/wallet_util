import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class DotAddr {
  final int index;
  final Chain chain;

  DotAddr({this.index = 0, required this.chain});
  //P2PKH
  String? _legacyAddr;
  String get legacyAddr {
    if (_legacyAddr == null) {
      ExtendedKey key44 = chain.forPath("m/44'/354'/0'/0/$index");
      // Uint8List hash44 = hash160(key44.publicKey().q!.getEncoded());
      PublicKey publicKey = PrivateKey.fromHex(key44.privateKeyHex()).publicKey;
      List<int> encodeHex = hex.decode(publicKey.toCompressedHex());
      Uint8List hash44 = hash160(Uint8List.fromList(encodeHex));
      final payload44 = Uint8List(21);
      payload44.buffer.asByteData().setUint8(0, 0x00);
      payload44.setRange(1, payload44.length, hash44);
      _legacyAddr = bs58check.encode(payload44);
    }
    return _legacyAddr!;
  }
}
