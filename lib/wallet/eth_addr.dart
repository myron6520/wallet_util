import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:flutter/material.dart';
import 'package:pointycastle/digests/keccak.dart';
import 'package:secp256k1/secp256k1.dart';

class EthAddr {
  final int index;
  final Chain chain;

  EthAddr({this.index = 0, required this.chain});

  late final String _addrHash = (() {
    ExtendedKey key = chain.forPath("m/44'/60'/0'/0/$index");
    String privateKeyHex = key.privateKeyHex();
    PublicKey publicKey = PrivateKey.fromHex(privateKeyHex).publicKey;
    List<int> input = hex.decode(publicKey.toHex().substring(2));
    Uint8List hash = keccak256(Uint8List.fromList(input));
    hash = hash.sublist(hash.length - 20, hash.length);
    String adrHash = hex.encode(hash);
    return adrHash;
  }).call();
  late final String simpleAddr = "0x" + _addrHash;
  late final String addr = (() {
    final adrHex = _addrHash.toLowerCase();
    final hashAdr = hex.encode(keccakAscii(_addrHash));
    final eip55 = StringBuffer('0x');
    for (var i = 0; i < adrHex.length; i++) {
      if (int.parse(hashAdr[i], radix: 16) >= 8) {
        eip55.write(adrHex[i].toUpperCase());
      } else {
        eip55.write(adrHex[i]);
      }
    }
    return eip55.toString();
  }).call();

  Uint8List keccak256(Uint8List input) {
    KeccakDigest digest = KeccakDigest(256);
    return digest.process(input);
  }

  Uint8List keccakAscii(String input) {
    return keccak256(ascii.encode(input));
  }
}
