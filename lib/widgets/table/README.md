

Andreas Häring

Explanation of the TableOverview Widget
======================


That is the __upper Widget__ in the __[TableViewScreen.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/main/lib/screens/TableViewScreen.dart)__.

          
<img src="https://drive.google.com/uc?export=view&id=1QYU6cN01OdFtyaNkVqgCLABzFhBS0E_3" width="450" alt="animation"/>
        

| Function                    | Name                           | Providor                              |
| ----------------------- | ------------------------------ | ------------------------------------- |
| Frame | [TableOverviewFrame.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/widgets/table/TableOverviewFrame.dart) | |          
| -List with Products | [TableOverviewProductList.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/widgets/table/TableOverviewProductList.dart) | [TableItemProvidor.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/Providers/TableItemProvidor.dart) |
| --Products in the List | [TableOverviewProductItem.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/widgets/table/TableOverviewProductItem.dart) | [TabelsItemsProvidor.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/Providers/TableItemsProvidor.dart) |
| -Change Product extras | [TableOverviewChangeProduct.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/widgets/table/TableOverviewChangeProduct.dart) | [TableItemChangeProvidor.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/Providers/TableItemChangeProvidor.dart) |

_________________________
#### How to add Products to the Widget?
You can call the Function of the Providor [TableOverviewChangeProduct.dart](https://github.com/omar-ez95/inspery-pos-flutter/blob/feature/invoices_andi/lib/widgets/table/TableOverviewChangeProduct.dart) "addProduct()" to add an Product to the list.
The providor will update the TableViewScreen page. You can now see the TableOverviewChangeProduct Widget pop up. You can ignore that or change specific items for the product there, you can close this widget by swiping it to the side. Also the TableOverviewProductItem Widget will get updated and you can see the new product on the list.

The Function:
```java
    ///Call this Function to add a Product to the TableItemsProvidor
    ///In Future it will not hand it directly to the Providor, it will do it via the Websocket
  addProduct({required context, required productID, required int tableName}){
          _productID = productID;
          //TODO: Replace the next line with a Serverrequest when the WebSockets are implemented - Andi 30.03
          Provider.of<TableItemsProvidor>(context, listen: false).addProduct(productID: productID, tableName: tableName);
        showProduct(productID: productID);
 }
```
Call it with the Product ID that you want to add like:
```java
  Providor.of<TableItemChangeProvidor>(
            context: context, 
            listen: false)
        .addProduct(
            productID: PRODUCT_ID, 
            tableName: TABLE_NAME, 
            context: context,
        );
```

_________________________

💻 State of developement:
- [X] ...
- [X] Devide widget in multible widgets to make it redable
- [X] Replace StreamBuilder with a Providor the add new Products
- [ ] In TableItemChangeProvidor replace the next line with a Serverrequest when the WebSockets are implemented
- [ ] Add all the nessesary Sockets to the Providor
- [X] Let the Products in the Card be countable so that the waiter can split a table
- [ ] Connect the bill widget to the TableOverviewFrame Widget
- [ ] Add funtions to let the Backend know when something is payed
- [X] Move all specific Functions for a singel Item from TableItemsProvidor to TableItemProvidor

⚠️ Known Issues:
- [X] **SideDish Prividor**, it is always empty and causes problems when calculating the total costs of a product
- [X] **TableOverviewProductItem** is only updating the amount of products in card when you scroll to the end of the screen
