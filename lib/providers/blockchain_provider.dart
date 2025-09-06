import 'package:flutter/foundation.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;

class BlockchainProvider extends ChangeNotifier {
  Web3Client? _client;
  EthereumAddress? _currentAddress;
  EtherAmount? _balance;
  bool _isConnected = false;
  
  Web3Client? get client => _client;
  EthereumAddress? get currentAddress => _currentAddress;
  EtherAmount? get balance => _balance;
  bool get isConnected => _isConnected;

  Future<void> connectToNetwork(String rpcUrl) async {
    try {
      _client = Web3Client(rpcUrl, http.Client());
      _isConnected = true;
      notifyListeners();
    } catch (e) {
      _isConnected = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> connectWallet(String privateKey) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      _currentAddress = credentials.address;
      await _updateBalance();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _updateBalance() async {
    if (_client != null && _currentAddress != null) {
      try {
        _balance = await _client!.getBalance(_currentAddress!);
        notifyListeners();
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<String> sendTransaction({
    required String to,
    required EtherAmount amount,
    EtherAmount? gasPrice,
  }) async {
    if (_client == null || _currentAddress == null) {
      throw Exception('Wallet not connected');
    }

    try {
      final credentials = EthPrivateKey.fromHex('your_private_key_here');
      
      final transaction = Transaction(
        to: EthereumAddress.fromHex(to),
        value: amount,
        gasPrice: gasPrice ?? await _client!.getGasPrice(),
      );

      final hash = await _client!.sendTransaction(
        credentials,
        transaction,
        chainId: 1, // Ethereum mainnet
      );

      await _updateBalance();
      return hash;
    } catch (e) {
      rethrow;
    }
  }

  void disconnect() {
    _client?.dispose();
    _client = null;
    _currentAddress = null;
    _balance = null;
    _isConnected = false;
    notifyListeners();
  }
}
