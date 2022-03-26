import 'dart:typed_data';
import 'package:dart_bip32_bip44/dart_bip32_bip44.dart';
import 'package:bip32/bip32.dart';
import 'package:wallet_util/wallet/btc_addr.dart';
import 'package:wallet_util/wallet/dot_addr.dart';
import 'package:wallet_util/wallet/eth_addr.dart';
import 'package:wallet_util/wallet/fil_addr.dart';
import 'package:wallet_util/wallet/tron_addr.dart';

class HDWallet {
  final Uint8List seed;
  late BIP32 bip32;
  late Chain chain;
  late FilAddr filAddr;
  late EthAddr ethAddr;
  late BtcAddr btcAddr;
  late TronAddr tronAddr;
  late DotAddr dotAddr;
  HDWallet({required this.seed}) {
    bip32 = BIP32.fromSeed(seed);
    String seedHex =
        seed.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join("");
    chain = Chain.seed(seedHex);
    filAddr = FilAddr(chain: chain, index: 0);
    ethAddr = EthAddr(chain: chain, index: 0);
    btcAddr = BtcAddr(chain: chain, index: 0);
    tronAddr = TronAddr(chain: chain, index: 0);
    dotAddr = DotAddr(chain: chain, index: 0);
  }
}
