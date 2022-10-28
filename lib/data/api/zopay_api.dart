import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sixam_mart/data/model/zopay/transaction_zopay.dart';
import 'package:sixam_mart/data/model/zopay/user_wallet.dart';
import 'package:sixam_mart/data/model/zopay/new_user.dart';
import 'package:sixam_mart/data/model/zopay/user_info.dart';

class ApiZopay {
  final db = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser.uid;
  static const String USERS = "users";
  static const String BANKS_ACCOUNT = "account";
  static const String NEW_USER_LIST = "new_users";
  static const String WALLET = "wallets";
  static const String TRANSACTION_HISTORY = "transaction_history";

  CollectionReference getUserCollection() => db.collection(USERS);

  CollectionReference getNewUserCollection() => db.collection(NEW_USER_LIST);

  CollectionReference getWalletCollection() => db.collection(WALLET);

  CollectionReference getTransactionHistoryCollection() =>
      db.collection(TRANSACTION_HISTORY);

  DocumentReference getUser() => getUserCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserInfoZopay.fromJson(snapshot, options),
          toFirestore: (UserInfoZopay user, options) => user.toJson())
      .doc(uid);

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

  //todo need delete when done app
  //nếu là tk mới thì đăng ký (tạo mới hồ sơ trên firestore), tạo mới trong danh sách new user
  //người dùng chỉ có quyền sau:
  // quyền write, read, update trên collection users
  // quyền create trên collection new users
  //quyền read trên collection transaction history
  // mọi giao dịch đều thông qua admin trung gian (user ->admin -> user/vendor) (tự động 100%)
  //admin sẽ có trách nhiệm kiểm tra danh sách new user, tạo ví ban đầu cho người dùng.

  //giao dịch được lọc tại client lần 1, check lại tại admin lần 2, xác minh giao dịch đạt, duyệt giao dịch.

  Future<bool> register(UserInfoZopay userZopay) async =>
      getUser().set(userZopay).then((value) => true).catchError((onError)=> false);

  // Future<void> getWallet(UserWallet userWallet) async =>

  //quyền create vào thư mục user mới, không có quyền update, sửa.
  Future<void> requestMoneyForFirstTime(NewUser newUser) async =>
      getNewUser().set(newUser);

  //for zopay wallet xem tài khoản hiện tại
  DocumentReference getUserWallet() => getWalletCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              UserWallet.fromJson(snapshot, options),
          toFirestore: (UserWallet wallet, options) => wallet.toJson())
      .doc(uid);

  // nhận toàn bộ lịch sử gửi tiền
  Query getSendMoneyTransactionHistory() => getTransactionHistoryCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              TransactionZopay.fromJson(snapshot, options),
          toFirestore: (TransactionZopay transaction, options) =>
              transaction.toJson())
      .where('uid_sender', isEqualTo: uid)
      .where('create_at', isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch).limit(50);

  //nhận toàn bộ lịch sử nhận tiền
  Query getReceiveMoneyTransactionHistory() => getTransactionHistoryCollection()
      .withConverter(
          fromFirestore: (snapshot, options) =>
              TransactionZopay.fromJson(snapshot, options),
          toFirestore: (TransactionZopay transaction, options) =>
              transaction.toJson())
      .where('uid_receiver', isEqualTo: uid)
      .where('create_at', isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch).limit(50);

  //tạo 1 giao dịch mới
  Future<void> createNewTransaction(TransactionZopay transactionZopay) =>
      getTransactionHistoryCollection()
          .withConverter(
              fromFirestore: (snapshot, options) =>
                  TransactionZopay.fromJson(snapshot, options),
              toFirestore: (TransactionZopay transaction, options) =>
                  transaction.toJson())
          .doc(transactionZopay.transactionId)
          .set(transactionZopay);

  //cho mua bán: đặt hàng chọn thanh toán qua zopay thì sẽ ngay lập tức tạo 1 giao dịch chờ,
// trừ số tiền của người dùng tại tk khuyển mại
//nếu tk khuyến mại hết, tiếp tục trừ bên tài khoản chính.
}
