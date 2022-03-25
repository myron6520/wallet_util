import 'dart:typed_data';

import 'package:bip39/bip39.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_util/wallet_util.dart';

void main() {
  test('adds one to input values', () {
    Uint8List seed = mnemonicToSeed(
        "process forget believe wealth tennis ski radio coral swim home clay topple");
    HDWallet wallet = HDWallet(seed: seed);

    print("ETH:${wallet.p2shAddr}");
    print("ETH:${wallet.legacyAddr}");
    print("ETH:${wallet.base32Addr}");
    expect(wallet.p2shAddr, "3JJDSSFeoj4chhWxMvaFC9juJb4YQjM7q8");
    expect(wallet.legacyAddr, "1HgEJJxPSQeXtWgzPPBAYEdhhDiNN5hLRA");
    expect(wallet.base32Addr, "bc1q2pjk5ekrmjqt8txqhdwvnr587rfqh9f4u0stan");
  });
}
