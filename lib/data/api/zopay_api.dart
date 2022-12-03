import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/data/model/zopay/abank.dart';
import 'package:sixam_mart/data/model/zopay/contact_model.dart';
import 'package:sixam_mart/data/model/zopay/new_referrals.dart';
import 'package:sixam_mart/data/model/zopay/new_user.dart';
import 'package:sixam_mart/data/model/zopay/response_zopay.dart';
import 'package:sixam_mart/data/model/zopay/transaction_zopay.dart';
import 'package:sixam_mart/data/model/zopay/user_info.dart';

import '../model/zopay/add_money.dart';
import '../model/zopay/cash_out_money.dart';
import '../model/zopay/user_wallet.dart';

class ApiZopay extends GetxController implements GetxService {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser.uid ?? ""
      : "";
  static const String USERS = "users";
  static const String BANKS_ACCOUNT = "account";
  static const String NEW_USER_LIST = "new_users";
  static const String WALLET = "wallets";
  static const String TRANSACTION_HISTORY = "transaction_history";
  static const String REFERRAL = "referrals";
  static const String PUBLIC_INFO = "public_info";
  static const String BANK_INFO = "banks";
  static const String ADD_MONEY = "add_money";
  static const String CASH_OUT = "cash_out";
  static const String STATUS_NEED_CANCEL = "need_cancel";

  static const String STATUS_SUCCESS = "status_success";
  static const String STATUS_FAIL = "status_fail";

  bool isLogin() => FirebaseAuth.instance.currentUser != null;

  CollectionReference getUserCollection() => db.collection(USERS);

  CollectionReference getNewUserCollection() => db.collection(NEW_USER_LIST);

  CollectionReference getWalletCollection() => db.collection(WALLET);

  CollectionReference getTransactionHistoryCollection() =>
      db.collection(TRANSACTION_HISTORY);

  CollectionReference getReferralsCollection() => db.collection(REFERRAL);

  CollectionReference getPublicUserCollection() => db.collection(PUBLIC_INFO);

  CollectionReference getBankCollection() => db.collection(BANK_INFO);

  CollectionReference getAddMoneyCollection() => db.collection(ADD_MONEY);

  CollectionReference getCashOutCollection() => db.collection(CASH_OUT);

  Future<bool> createNewCashOutMoneyRequest(CashOutMoney cashOutMoney) async =>
      await getCashOutCollection()
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  CashOutMoney.fromFirestore(snapshot),
              toFirestore: (CashOutMoney cashOutMoney, options) =>
                  cashOutMoney.toFirestore())
          .doc()
          .set(cashOutMoney)
          .then((value) => true)
          .catchError((onError) => false);

  Future<bool> createNewAddMoneyRequest(AddMoney addMoney) async =>
      await getAddMoneyCollection()
          .withConverter(
              fromFirestore: (snapshot, options) => AddMoney.fromJson(snapshot),
              toFirestore: (AddMoney addMoney, options) =>
                  addMoney.toFirestore())
          .doc()
          .set(addMoney)
          .then((value) => true)
          .catchError((onError) => false);

  Stream<DocumentSnapshot> getBankStream() => getBankCollection()
      .withConverter(
        fromFirestore: (snapshot, options) =>
            ABank.fromFirestore(snapshot, options),
        toFirestore: (ABank value, options) => value.toFirestore(),
      )
      .doc(uid)
      .snapshots(includeMetadataChanges: true);

  Future<bool> checkBankAccount() async {
    final response = await getBankCollection()
        .withConverter(
          fromFirestore: (snapshot, options) =>
              ABank.fromFirestore(snapshot, options),
          toFirestore: (ABank value, options) => value.toFirestore(),
        )
        .doc(uid)
        .get();
    return response.exists;
  }

  Future<bool> addBankAccount(ABank aBank) async => await getBankCollection()
      .withConverter(
        fromFirestore: (snapshot, options) =>
            ABank.fromFirestore(snapshot, options),
        toFirestore: (ABank value, options) => value.toFirestore(),
      )
      .doc(uid)
      .set(aBank)
      .then((value) => true)
      .catchError((onError) => false);

  DocumentReference getPublicUser() => getPublicUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) => ContactModel.fromJson(snapshot),
          toFirestore: (ContactModel user, options) => user.toJson())
      .doc(uid);

  DocumentReference getUser() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserInfoZopay.fromJson(snapshot, options),
          toFirestore: (UserInfoZopay user, options) => user.toJson())
      .doc(uid);


  Stream<DocumentSnapshot> getUserStream() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserInfoZopay.fromJson(snapshot, options),
          toFirestore: (UserInfoZopay wallet, options) => wallet.toJson())
      .doc(uid)
      .snapshots(includeMetadataChanges: true);

  DocumentReference getNewUser() => getNewUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              NewUser.fromJson(snapshot, options),
          toFirestore: (NewUser user, options) => user.toJson())
      .doc(uid);

  //kiểm tra tk mới hay không
  Future<bool> checkUserIsExits() async {
    DocumentSnapshot value = await getUser().get();
    return value.exists;
  }

  Future<bool> register(UserInfoZopay userZopay) async => getUser()
      .set(userZopay)
      .then((value) => true)
      .catchError((onError) => false);

  Future<ResponseZopay> requestMoneyForFirstTime(NewUser newUser) async {
    ResponseZopay responseZopay = await getNewUser()
        .set(newUser)
        .then((value) => ResponseZopay(status: STATUS_SUCCESS, message: ""))
        .onError((error, stackTrace) =>
            ResponseZopay(status: STATUS_FAIL, message: error.toString()));
    return responseZopay;
  }

  //for zopay wallet xem tài khoản hiện tại
  Stream<DocumentSnapshot> getUserWallet() => getWalletCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserWallet.fromJson(snapshot, options),
          toFirestore: (UserWallet wallet, options) => wallet.toJson())
      .doc(uid)
      .snapshots(includeMetadataChanges: true);

  // nhận toàn bộ lịch sử gửi tiền
  Stream<QuerySnapshot> getSendMoneyTransactionHistory() =>
      getTransactionHistoryCollection()
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  TransactionZopay.fromJson(snapshot, options),
              toFirestore: (TransactionZopay transaction, options) =>
                  transaction.toJson())
          .where('uid_sender', isEqualTo: uid)
          .limit(50)
          .snapshots(includeMetadataChanges: true);

  //nhận toàn bộ lịch sử nhận tiền
  Query getReceiveMoneyTransactionHistory() => getTransactionHistoryCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              TransactionZopay.fromJson(snapshot, options),
          toFirestore: (TransactionZopay transaction, options) =>
              transaction.toJson())
      .where('uid_receiver', isEqualTo: uid)
      .limit(50);

  //tạo 1 giao dịch mới
  Future<ResponseZopay> createNewTransaction(
      TransactionZopay transactionZopay) async {
    ResponseZopay response = await getTransactionHistoryCollection()
        .withConverter(
            fromFirestore: (snapshot, options) =>
                TransactionZopay.fromJson(snapshot, options),
            toFirestore: (TransactionZopay transaction, options) =>
                transaction.toJson())
        .doc(transactionZopay.transactionId)
        .set(transactionZopay)
        .then((value) => ResponseZopay(
            status: STATUS_SUCCESS, message: transactionZopay.transactionId))
        .onError((error, stackTrace) =>
            ResponseZopay(status: STATUS_FAIL, message: error.toString()));
    return response;
  }

  Future<ResponseZopay> updateOrderId(
      String transactionId, String orderId) async {
    ResponseZopay response = await getTransactionHistoryCollection()
        .withConverter(
            fromFirestore: (snapshot, options) =>
                TransactionZopay.fromJson(snapshot, options),
            toFirestore: (TransactionZopay transaction, options) =>
                transaction.toJson())
        .doc(transactionId)
        .update({"order_id": orderId})
        .then((value) => ResponseZopay(status: STATUS_SUCCESS))
        .onError((error, stackTrace) =>
            ResponseZopay(status: STATUS_FAIL, message: error.toString()));
    return response;
  }

  Future<void> cancelOrder(String orderId) async {
    final response = await getTransactionHistoryCollection()
        .withConverter(
            fromFirestore: (snapshot, options) =>
                TransactionZopay.fromJson(snapshot, options),
            toFirestore: (TransactionZopay transaction, options) =>
                transaction.toJson())
        .where("order_id", isEqualTo: orderId)
        .limit(3)
        .get();
    final transactions = response.docs;
    for (QueryDocumentSnapshot<TransactionZopay> result in transactions) {
      final transaction = result.data();
      await getTransactionHistoryCollection()
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  TransactionZopay.fromJson(snapshot, options),
              toFirestore: (TransactionZopay transaction, options) =>
                  transaction.toJson())
          .doc(transaction.transactionId)
          .update({"status": ApiZopay.STATUS_NEED_CANCEL})
          .then((value) => ResponseZopay(status: STATUS_SUCCESS))
          .onError((error, stackTrace) =>
              ResponseZopay(status: STATUS_FAIL, message: error.toString()));
    }
  }

  Future<ResponseZopay> shareMoneyForReferral(String referral) async {
    final receiverU = NewReferral(
        phoneSender: FirebaseAuth.instance.currentUser.phoneNumber
            .replaceAll("+84", "0"),
        phoneReceiver: referral,
        status: false,
        id: uid);
    ResponseZopay response = await getReferralsCollection()
        .withConverter(
            fromFirestore: (snapshot, options) =>
                NewReferral.fromJson(snapshot, options),
            toFirestore: (NewReferral newReferral, options) =>
                newReferral.toJson())
        .doc(uid)
        .set(receiverU)
        .then((value) => ResponseZopay(status: STATUS_SUCCESS, message: ""))
        .onError((error, stackTrace) =>
            ResponseZopay(status: STATUS_FAIL, message: error.toString()));
    return response;
  }
}
