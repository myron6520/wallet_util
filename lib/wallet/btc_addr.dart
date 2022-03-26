import 'dart:typed_data';

import 'package:bech32/bech32.dart';
import 'package:convert/convert.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:secp256k1/secp256k1.dart';

class BtcAddr {
  final int index;
  final Chain chain;

  BtcAddr({this.index = 0, required this.chain});

  //P2PKH
  String? _legacyAddr;
  String get legacyAddr {
    if (_legacyAddr == null) {
      ExtendedKey key44 = chain.forPath("m/44'/0'/0'/0/$index");
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

  String legacyAddrWithIndex(int idx) {
    ExtendedKey key44 = chain.forPath("m/44'/0'/0'/0/$idx");
    Uint8List hash44 = hash160(key44.publicKey().q!.getEncoded());
    final payload44 = Uint8List(21);
    payload44.buffer.asByteData().setUint8(0, 0x00);
    payload44.setRange(1, payload44.length, hash44);
    return bs58check.encode(payload44);
  }

  ///P2SH
  String? _p2shAddr;
  String get p2shAddr {
    if (_p2shAddr == null) {
      ExtendedKey key49 = chain.forPath("m/49'/0'/0'/0/$index");
      // Uint8List hash49 = hash160(key49.publicKey().q!.getEncoded());
      PublicKey publicKey = PrivateKey.fromHex(key49.privateKeyHex()).publicKey;
      List<int> encodeHex = hex.decode(publicKey.toCompressedHex());
      Uint8List hash49 = hash160(Uint8List.fromList(encodeHex));
      final scriptSig = Uint8List(22);
      scriptSig.buffer.asByteData().setUint8(0, 0x00);
      scriptSig.buffer.asByteData().setUint8(1, hash49.length);
      scriptSig.setRange(2, scriptSig.length, hash49);
      var scriptHash = hash160(scriptSig);
      Uint8List payload49 = Uint8List(1 + scriptHash.length);
      payload49.buffer.asByteData().setUint8(0, 0x05);
      payload49.setRange(1, payload49.length, scriptHash);
      _p2shAddr = bs58check.encode(payload49);
    }
    return _p2shAddr!;
  }

  ///Native SegWit (Bech32)
  String? _base32Addr;
  String get base32Addr {
    if (_base32Addr == null) {
      ExtendedKey key = chain.forPath("m/84'/0'/0'/0/$index");
      PublicKey publicKey = PrivateKey.fromHex(key.privateKeyHex()).publicKey;
      List<int> encodeHex = hex.decode(publicKey.toCompressedHex());
      Uint8List hash = hash160(Uint8List.fromList(encodeHex));
      _base32Addr = const SegwitCodec().encode(Segwit("bc", 0, hash));
    }
    return _base32Addr!;
  }
}
