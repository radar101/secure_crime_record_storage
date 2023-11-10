import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seminar_blockchain/service/crimeRecordModel.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';

class CrimeService extends ChangeNotifier {
  late Web3Client _web3client;
  late Credentials _creds;
  late ContractAbi _abiCode;
  late EthereumAddress _contractAddress;
  late DeployedContract _deployedContract;
  late ContractFunction _uploadImage;
  // late ContractFunction _cases;
  // late ContractFunction _caseImageHashes;
  late ContractFunction _getImageHash;
  bool isLoading = true;
  List<CrimeRecord> crimeRecord = [];
  List<String> ipfsHash = [];

  // Remote Procedure Call URL
  final String _rpcUrl = 'http://192.168.196.64:7545';
  // Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';

  // Web Socket URL
  final String _wsUrl = 'ws://192.168.196.64:7545';

  // Platform.isAndroid ? 'http://10.0.2.2:7545' :
  final String _privateKey =
      "0x53f80de2407055f84cc2f1cca179208d751185f1d925e69696341bcb97bbb611";

  CrimeService() {
    init();
  }

  Future<void> init() async {
    print("Constructor called");
    try {
      _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      });
    } catch (e) {
      print("Error while initializing web3client ${e.toString()}");
    }

    EtherAmount amount = await _web3client.getBalance(
        EthereumAddress.fromHex("0x9950E04f75b077051Ee9C066D5b79Fe3cFD90299"));
    print(amount);
    await getABI();
    await getCredentials();
    await getDeployedContract();
    // putCaseData(4, "fdajfaakl", "384ewfdkjfu9qwe");
  }

  // Application Binary Interface (ABI)
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/CrimeStorage.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode = ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'CrimeStorage');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

  Future<void> getCredentials() async {
    try {
      _creds = EthPrivateKey.fromHex(_privateKey);
      print("${_creds.address} this is credential");
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _uploadImage = _deployedContract.function("uploadImage");
    _getImageHash = _deployedContract.function("getImageHash");
  }

  Future<List<String>> getCaseData(String caseNumber) async {
    ipfsHash.clear();
    print("Called get case data");
    try {
      var temp = await _web3client.call(
          contract: _deployedContract,
          function: _getImageHash,
          params: [BigInt.from(int.parse(caseNumber))]);
      print(temp);
      temp = temp[0];
      for (int i = 0; i < temp.length; i++) {
        ipfsHash.add(temp[i]);
      }

      isLoading = false;
      notifyListeners();
      return ipfsHash;
    } catch (e) {
      print("Error while making get request ${e.toString()}");
      return [];
    }
  }

  Future<void> putCaseData(
      int caseNumber, String description, String ipfsHash) async {
    try {
      print("PutcaseData started now ");
      var response = await _web3client.sendTransaction(
        _creds,
        Transaction.callContract(
          contract: _deployedContract,
          function: _uploadImage,
          parameters: [BigInt.from(caseNumber), description, ipfsHash],
          gasPrice: EtherAmount.inWei(BigInt.from(20000000000)),
          maxGas: 6721975,
        ),
        chainId: 1337,
      );
      // Get the transaction receipt
      var receipt = await _web3client.getTransactionReceipt(response);

      if (receipt != null) {
        print("Transaction Hash: ${receipt.transactionHash}");
        print("Block Number: ${receipt.blockNumber}");
        print("Gas Used: ${receipt.gasUsed}");
        // Add more information from the receipt as needed
      } else {
        print(
            "Transaction receipt not available yet. Please wait and check again later.");
      }
    } catch (e) {
      print("Error while sending transaction: $e");
    }
  }
}
