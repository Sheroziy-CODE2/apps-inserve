

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
      dateTime: DateTime.fromMillisecondsSinceEpoch(jsonResponse["date"]),
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
  int? saved_table;
  final int user;
  final String product;
  final num selected_price;
  final String price_description;
  final int quantity;
  final num total_price;
  final List<String> added_ingredients;
  final List<String> deleted_ingredients;
  final List<String> side_products;
  final String date;
  //final status;

  InvoiceOrderItemModel({
    required this.id,
    required this.table,
    required this.price_description,
    required this.user,
    required this.product,
    required this.selected_price,
    required this.side_products,
    required this.quantity,
    required this.total_price,
    required this.added_ingredients,
    required this.deleted_ingredients,
    required this.date,
    this.saved_table,
  });

  factory InvoiceOrderItemModel.fromJson(response){
    var jsonResponse = response as Map<String, dynamic>;
    return InvoiceOrderItemModel(
      id:  jsonResponse["id"] as int,
      table:  jsonResponse["table"]??0,
      saved_table:  jsonResponse["saved_table"],
      user:  jsonResponse["user"] as int,
      product:  jsonResponse["product"] as String,
      selected_price:  jsonResponse["selected_price"] as num,
      price_description: jsonResponse["price_description"] as String,
      quantity:  jsonResponse["quantity"] as int,
      total_price:  jsonResponse["total_price"] as num,
      added_ingredients:  List<String>.from(jsonResponse["added_ingredients"] as List<dynamic>),
      deleted_ingredients:  List<String>.from(jsonResponse["deleted_ingredients"] as List<dynamic>),
      side_products:  List<String>.from(jsonResponse["side_products"] as List<dynamic>),
      date:  jsonResponse["date"] as String,
    );
  }

}
