import 'dart:typed_data';

import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/digests/keccak.dart';
import 'package:pointycastle/digests/sha256.dart';
import 'package:secp256k1/secp256k1.dart';
import 'package:convert/convert.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

class TronAddr {
  final int index;
  final Chain chain;

  TronAddr({this.index = 0, required this.chain});
  late final String addr = (() {
    ExtendedKey key = chain.forPath("m/44'/195'/0'/0/$index");
    String privateKeyHex = key.privateKeyHex();
    PublicKey publicKey = PrivateKey.fromHex(privateKeyHex).publicKey;
    List<int> input = hex.decode(publicKey.toHex().substring(2));
    Uint8List hash = keccak256(Uint8List.fromList(input));
    hash = hash.sublist(hash.length - 20, hash.length);
    final payload = Uint8List(hash.length + 1);
    payload.buffer.asByteData().setUint8(0, 0x41);
    payload.setRange(1, payload.length, hash);
    return bs58check.encode(payload);
  }).call();

  Uint8List keccak256(Uint8List input) {
    KeccakDigest digest = KeccakDigest(256);
    return digest.process(input);
  }
}
