import 'dart:convert';

///this Model is used when you checkout
class InvoiceItemDictModel {
  final int tableID;
  final String tipType;
  final num tip;
  final List<InvoiceItemsDictModelItems> items;
  final List<InvoiceItemsDictModelPayments> payments;

  InvoiceItemDictModel({
    required this.tip,
    required this.tableID,
    required this.items,
    required this.payments,
    required this.tipType,
  });

  getJson(){
    return jsonEncode({
      "tip": tip,
      "table": tableID,
      "items": List.generate(items.length, (index) => items[index].getMap()),
      "payments" : List.generate(payments.length, (index) => payments[index].getMap()),
      "tip_type": tipType,
    });
  }
}

class InvoiceItemsDictModelItems{
  final int quantity;
  final int order;
  InvoiceItemsDictModelItems({
      required this.quantity,
    required this.order,
  });

  getMap(){
    return {
      "quantity": quantity,
      "order": order,
    };
  }
}

class InvoiceItemsDictModelPayments{
  final String type;
  final num price;
  InvoiceItemsDictModelPayments({
    required this.type,
    required this.price,
  });
  getMap(){
    return {
      "type": type,
      "price": price,
    };
  }
}