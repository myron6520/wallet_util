import 'dart:convert';
import 'dart:typed_data';
import 'package:bech32/bech32.dart';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:bip32/bip32.dart';
import 'package:pointycastle/digests/keccak.dart';
import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:convert/convert.dart';

class HDWallet {
  final Uint8List seed;
  late BIP32 bip32;
  late Chain chain;
  HDWallet({required this.seed}) {
    bip32 = BIP32.fromSeed(seed);
    String seedHex =
        seed.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join("");
    chain = Chain.seed(seedHex);
  }
  //P2PKH
  String? _legacyAddr;
  String get legacyAddr {
    if (_legacyAddr == null) {
      ExtendedKey key44 = chain.forPath("m/44'/0'/0'/0/0");
      Uint8List hash44 = hash160(key44.publicKey().q!.getEncoded());
      final payload44 = Uint8List(21);
      payload44.buffer.asByteData().setUint8(0, 0x00);
      payload44.setRange(1, payload44.length, hash44);
      _legacyAddr = bs58check.encode(payload44);
    }
    return _legacyAddr!;
  }

  ///P2SH
  String? _p2shAddr;
  String get p2shAddr {
    if (_p2shAddr == null) {
      ExtendedKey key49 = chain.forPath("m/49'/0'/0'/0/0");
      Uint8List hash49 = hash160(key49.publicKey().q!.getEncoded());
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
      ExtendedKey key = chain.forPath("m/84'/0'/0'/0/0");
      Uint8List hash = hash160(key.publicKey().q!.getEncoded());
      _base32Addr = const SegwitCodec().encode(Segwit("bc", 0, hash));
    }
    return _base32Addr!;
  }

  late final KeccakDigest _keccakDigest = KeccakDigest(256);
  Uint8List keccak256(Uint8List input) {
    _keccakDigest.reset();
    return _keccakDigest.process(input);
  }

  Uint8List keccakAscii(String input) {
    return keccak256(ascii.encode(input));
  }

  String bytesToHex(List<int> bytes,
      {bool include0x = false,
      int? forcePadLength,
      bool padToEvenLength = false}) {
    var encoded = hex.encode(bytes);

    if (forcePadLength != null) {
      assert(forcePadLength >= encoded.length);

      final padding = forcePadLength - encoded.length;
      encoded = ('0' * padding) + encoded;
    }

    if (padToEvenLength && encoded.length % 2 != 0) {
      encoded = '0$encoded';
    }

    return (include0x ? '0x' : '') + encoded;
  }
}
