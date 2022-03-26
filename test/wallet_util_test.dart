import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_util/wallet_util.dart';

void main() {
  test('addr parser', () {
    Uint8List seed = mnemonicToSeed(
        "process forget believe wealth tennis ski radio coral swim home clay topple");
    HDWallet wallet = HDWallet(seed: seed);

    print("p2shAddr:${wallet.btcAddr.p2shAddr}");
    print("legacyAddr:${wallet.btcAddr.legacyAddr}");
    print("base32Addr:${wallet.btcAddr.base32Addr}");
    print("eth:${wallet.ethAddr.addr}");
    print("fil:${wallet.filAddr.addr}");
    print("tron:${wallet.tronAddr.addr}");
    print("tron:${wallet.dotAddr.legacyAddr}");
    expect(wallet.btcAddr.p2shAddr, "3JJDSSFeoj4chhWxMvaFC9juJb4YQjM7q8");
    expect(wallet.btcAddr.legacyAddr, "1HgEJJxPSQeXtWgzPPBAYEdhhDiNN5hLRA");
    expect(wallet.btcAddr.base32Addr,
        "bc1q2pjk5ekrmjqt8txqhdwvnr587rfqh9f4u0stan");
    expect(wallet.ethAddr.addr, "0xc8b55A5Fb117D85297fc25863BF329026383195c");
    expect(wallet.filAddr.addr, "f1dxp7fhjsx6wsy7zxugapklbws3tkynhb6yvxswq");
    expect(wallet.tronAddr.addr, "TFfazV52kR5e88CNRuf2Bp6QS4N7U4nbS7");
  });
}
