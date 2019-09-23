import 'package:flutter/material.dart';
import 'package:my_njupt_library/components/common/CommonItemsConstructor.dart';

class PaymentItem extends StatelessWidget {
  Map<String, String> items = new Map();
  PaymentItem(
    String id,
    String bookId,
    String name,
    String author,
    String borrowDate,
    String returnDate,
    String place,
    String expectPayment,
    String actualPayment,
    String status,
  ) {
    items['书名'] = name;
    items['作者'] = author;
    items['借阅时间'] = borrowDate;
    items['归还时间'] = returnDate;
    items['位置'] = place;
    items['应缴费用'] = expectPayment;
    items['实际缴纳'] = actualPayment;
    items['状态'] = status;
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new Card(
        elevation: 15,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        child: Column(
          children: CommonItemsConstructor(this.items)
        ),
      ),
    );
  }
}
