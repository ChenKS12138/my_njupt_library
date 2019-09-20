class LoginType {
  static const String STUDENT_ID = 'cert_no';
  static const String CARD_ID = 'bar_no';
  static const String EMAIL = 'email';
}

class LibraryPersonalInfo {
  String dueInFive;
  String exceedCount;
  String orderCount;
  String entrustCount;
  String name;
  String studentID;
  String barCode;
  String expiryDate;
  String registDate;
  String effectiveDate;
  String maxBorrowCount;
  String maxOrderCount;
  String maxEntrustCount;
  String studentType;
  String borrowLevel;
  String accumulatedCount;
  String violationCount;
  String arrear;
  String id;
  String department;
  String sex;
  String guaranteeDeposit;
  String serviceFee;
  LibraryPersonalInfo(
      this.dueInFive,
      this.exceedCount,
      this.orderCount,
      this.entrustCount,
      this.name,
      this.studentID,
      this.barCode,
      this.expiryDate,
      this.registDate,
      this.effectiveDate,
      this.maxBorrowCount,
      this.maxEntrustCount,
      this.studentType,
      this.borrowLevel,
      this.accumulatedCount,
      this.violationCount,
      this.arrear,
      this.id,
      this.department,
      this.sex,
      this.guaranteeDeposit,
      this.serviceFee);
  @override
  String toString() {
    return {
      'dueInFive': dueInFive,
      'exceedCount': exceedCount,
      'orderCount': orderCount,
      'entrustCount': entrustCount,
      'name': name,
      'studentID': studentID,
      'barCode': barCode,
      'expiryDate': expiryDate,
      'registDate': registDate,
      'effectiveDate': effectiveDate,
      'maxBorrowCount': maxBorrowCount,
      'maxEntrustCount': maxEntrustCount,
      'studentType': studentType,
      'borrowLevel': borrowLevel,
      'accumulatedCount': accumulatedCount,
      'violationCount': violationCount,
      'arrear': arrear,
      'id': id,
      'department': department,
      'sex': sex,
      'guaranteeDeposit': guaranteeDeposit,
      'serviceFee': serviceFee
    }.toString();
  }
}

class LibraryHistoryItem {
  String id;
  String name;
  String author;
  String borrowDate;
  String returnDate;
  String place;
  LibraryHistoryItem(this.id, this.name, this.author, this.borrowDate,
      this.returnDate, this.place);

  @override
  String toString() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'borrowDate': borrowDate,
      'returnDate': returnDate,
      'place': place
    }.toString();
  }
}

class LibraryHistory {
  List<LibraryHistoryItem> value;
  LibraryHistory(this.value);
}

class LibraryPaymentItem {
  String id;
  String bookId;
  String name;
  String author;
  String borrowDate;
  String returnDate;
  String place;
  String expectPayment;
  String actualPayment;
  String status;
  LibraryPaymentItem(
      this.id,
      this.bookId,
      this.name,
      this.author,
      this.borrowDate,
      this.returnDate,
      this.place,
      this.expectPayment,
      this.actualPayment,
      this.status);

  @override
  String toString() {
    return {
      'id': id,
      'bookId': bookId,
      'author': author,
      'borrowDate': borrowDate,
      'returnDate': returnDate,
      'place': place,
      'expectPayment': expectPayment,
      'actualPayment': actualPayment,
      'status': status
    }.toString();
  }
}

class LibraryPayment {
  List<LibraryPaymentItem> value;
  LibraryPayment(this.value);
}

class LibrarySearchItem {
  String name;
  String type;
  String author;
  String press;
  String mamarc_no;
  LibrarySearchItem(
      this.name, this.type, this.author, this.press, this.mamarc_no);
  @override
  String toString() {
    return {
      'name': name,
      'type': type,
      'author': author,
      'press': press,
      'mamarc_no': mamarc_no
    }.toString();
  }
}

class LibrarySearch {
  List<LibrarySearchItem> value;
  int allCount;
  int pageCount;
  int historyCount;
  int displaypg;
  LibrarySearch(this.value, this.allCount, this.pageCount, this.historyCount,
      this.displaypg);

  @override
  String toString() {
    return {
      'value': value.toString(),
      'allCount': allCount.toString(),
      'pageCount': pageCount.toString(),
      'historyCount': historyCount.toString(),
      'displaypg': displaypg.toString()
    }.toString();
  }
}

class LibraryRecommendItem {
  String name;
  String author;
  String press;
  String callNumber;
  String store;
  String borrowCount;
  String borrowRate;
  String marc_no;
  LibraryRecommendItem(this.name, this.author, this.press, this.callNumber,
      this.store, this.borrowCount, this.borrowRate, this.marc_no);

  @override
  String toString() {
    return {
      'name': name,
      'author': author,
      'press': press,
      'callNumber': callNumber,
      'store': store,
      'borrowCount': borrowCount,
      'borrowRate': borrowRate,
      'marc_no': marc_no
    }.toString();
  }
}

class LibraryRecommend {
  List<LibraryRecommendItem> value;
  LibraryRecommend(this.value);
}

class LibraryDetail {
  String press;
  String callNumber;
  String size;
  String name;
  String author;
  String orientation;
  String authorDetail;
  String summary;
  String audience;
  LibraryDetail(this.press, this.callNumber, this.size, this.name, this.author,
      this.orientation, this.authorDetail, this.summary, this.audience);

  @override
  String toString() {
    return {
      'press': press,
      'callNumber': callNumber,
      'size': size,
      'name': name,
      'author': author,
      'orientation': orientation,
      'authorDetail': authorDetail,
      'summary': summary,
      'audience': audience
    }.toString();
  }
}
