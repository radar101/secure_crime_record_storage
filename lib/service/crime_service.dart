import 'dart:convert';
import 'dart:io';
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
  late ContractFunction _cases;
  late ContractFunction _caseImageHashes;
  late ContractFunction _getImageHash;
  bool isLoading = true;
  List<CrimeRecord> crimeRecord = [];

  // Remote Procedure Call URL
  final String _rpcUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'http://127.0.0.1:7545';

  // Web Socket URL
  final String _wsUrl =
      Platform.isAndroid ? 'http://10.0.2.2:7545' : 'ws://127.0.0.1:7545';

  final String _privateKey =
      "0x1aff51dca1a85b890be0b62b31f88c6e92ccb91c6404f5649bec56987636511b";

  CrimeService() {
    init();
  }

  Future<void> init() async {
    _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

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
    _cases = _deployedContract.function("cases");
    _caseImageHashes = _deployedContract.function("caseImageHashes");
    _getImageHash = _deployedContract.function("getImageHash");
    // await fetchNotes();
  }

  Future<void> getCaseData(String caseNumber) async {
    // List totalTaskList = await _web3client
    //     .call(contract: _deployedContract, function: _noteCount, params: []);
    // print("The task list is $totalTaskList");
    // int totalTaskLen = totalTaskList[0].toInt();
    crimeRecord.clear();
    var temp = await _web3client.call(
        contract: _deployedContract,
        function: _cases,
        params: [BigInt.from(int.parse(caseNumber) - 1)]);
    print(temp);
    isLoading = false;
    notifyListeners();
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
          gasPrice:
              EtherAmount.inWei(BigInt.from(20000000000)), // Reduced gas price
          maxGas: 6721975, // Reduced gas limit
        ),
        chainId: 1337,
      );
      // Get the transaction receipt
      var receipt = await _web3client.getTransactionReceipt(response);

      // Check if the receipt is available
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
