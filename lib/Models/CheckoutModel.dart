

class CheckoutModel{
  final DateTime dateTime;
  final int id;
  final List<InvoiceItemsModel> invoiceItemList;
  final num amount;
  final int dailyInvoice;
  final int tableID;
  final int user;
  final int type;

  CheckoutModel({
    required this.id,
    required this.dateTime,
    required this.invoiceItemList,
    required this.amount,
    required this.dailyInvoice,
    required this.type,
    required this.tableID,
    required this.user,
  });

  factory CheckoutModel.fromJson(response, context) {
    var jsonResponse = response as Map<String, dynamic>;
    return CheckoutModel(
      dateTime:
          DateTime.fromMillisecondsSinceEpoch(int.parse(jsonResponse["date"]) * 1000),
      id: jsonResponse["id"] as int,
      user: jsonResponse["user"] as int,
      dailyInvoice: jsonResponse["dailyInvoice"] as int,
      tableID: jsonResponse["table"] as int,
      amount: jsonResponse["amount"] as num,
      invoiceItemList: List.generate((jsonResponse["invoice_items"] as List<dynamic>).length, (index) => InvoiceItemsModel.fromJson((jsonResponse["invoice_items"] as List<dynamic>)[index])),
      type: jsonResponse["table"] as int,
    );
  }
}


class InvoiceItemsModel{
  final num amount;
  final int id;
  final int quantity;
  final InvoiceOrderItemModel order;


  InvoiceItemsModel({
    required this.id,
    required this.amount,
    required this.order,
    required this.quantity,
  });

  factory InvoiceItemsModel.fromJson(response){
    var jsonResponse = response as Map<String, dynamic>;
    return InvoiceItemsModel(
        amount: jsonResponse["amount"] as num,
        id: jsonResponse["id"] as int,
        quantity: jsonResponse["quantity"] as int,
        order: InvoiceOrderItemModel.fromJson(jsonResponse["order"]),

    );
  }
}

class InvoiceOrderItemModel{
  final int id;
  final int table;
  final int saved_tabke;
  final int user;
  final String product;
  final List<int> dips;
  //final List<int> selected_price;
  final List<int> side_products;
  final int quantity;
  final num total_price;
  final List<int> added_ingredients;
  final List<int> deleted_ingredients;
  final String date;
  //final status;

  InvoiceOrderItemModel({
    required this.id,
    required this.table,
    required this.saved_tabke,
    required this.user,
    required this.product,
    required this.dips,
    //required this.selected_price,
    required this.side_products,
    required this.quantity,
    required this.total_price,
    required this.added_ingredients,
    required this.deleted_ingredients,
    required this.date,
  });

  factory InvoiceOrderItemModel.fromJson(response){
    var jsonResponse = response as Map<String, dynamic>;
    return InvoiceOrderItemModel(
      id:  jsonResponse["id"] as int,
      table:  jsonResponse["table"] as int,
      saved_tabke:  jsonResponse["saved_table"] as int,
      user:  jsonResponse["user"] as int,
      product:  jsonResponse["product"] as String,
      dips:  List<int>.from(jsonResponse["dips"] as List<dynamic>),
      //selected_price:  List<int>.from(jsonResponse["selected_price"] as List<dynamic>),
      side_products:  List<int>.from(jsonResponse["side_products"] as List<dynamic>),
      quantity:  jsonResponse["quantity"] as int,
      total_price:  jsonResponse["total_price"] as num,
      added_ingredients:  List<int>.from(jsonResponse["added_ingredients"] as List<dynamic>),
      deleted_ingredients:  List<int>.from(jsonResponse["deleted_ingredients"] as List<dynamic>),
      date:  jsonResponse["date"] as String,
    );
  }

}