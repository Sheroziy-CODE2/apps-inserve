
## INSPERY-POS-FLUTTER

## About The Project

---


### Built With

* Flutter


## Getting Started


Installation:

1. install FLutter SDK and add to the PATH
2. install an emulator of your choice

## Folder  structur 
inside of the lib folder you will find all of the modules, screens, widgets, .....
### components 
inside of this folder you will find some reusable components 
### models 
inside of this folder you find all of the modules used in the app 

### printer

### Providers
inside of this folder you find all of the provviders used in the app.
* Authy 
has all of user informations and login, logout functions 
* Categorys 
has a list of categories and a function to get all the categories from the backend 
* Ingredients
has a list of Ingredients and a function to gett all of the Ingredients from the backend
* Prices 
has a list of Prices and a function to get all of the prices from the backend 
* Products 
has a list of Products and a function to get all of the Products from the backend  
* Sidedishes 
has a list of Sidedishes and a function to get all of the Sidedishes from the backend  
* Tables 
has a list of Tables and a function to get all tables from the backend, a function to connect to the sockets, a function to listen to the sockets, 
a function to sink data to the sockets and a function to print a bill  
### screens 
* Homepage
in this screen you will see a numeric input that will forword you to a table after inputing the number of the table 

    [![Homepage Screen Shot][homepage-screenshot]](https://inspery.com)

* TablesViewScreen
in this screen you will see a list of available tables in the restaurant. When you click on one of them you will be forworded to the TableViewScreen.  
    [![tables Screen Shot][tables-screenshot]](https://inspery.com)

* TableViewScreen
in this screen you will see you will see 2 widgets:
    - TableOverviewFrame has a list of orders and new orders will be added to it 
    - ChooseProductFormWidget has three columns, two of them has a list of categories (Drinks and Food), the third will show a list of products when a user clicks on a category.
[![table Screen Shot][table-screenshot]](https://inspery.com)

* InvoicesViewScreen 
in this screen you will see a list of invoices from the same day, when you click on one of them you will be redirected to the InvoiceViewScreen.
[![invoices Screen Shot][invoices-screenshot]](https://inspery.com)

* InvoicesViewScreen 
in this screen you will see a detailed invoice.

[![invoice Screen Shot][invoice-screenshot]](https://inspery.com)

* ProfileScreen
in this screen the user can see information about his profile and also details about the total amount of daily invoices.

[![profile Screen Shot][profile-screenshot]](https://inspery.com)

* ProvidersApiCallsScreen
the user will be redirected to this screen after logging in. It will show a loading screen while it get all the important data about the restaurant where the user works and it make aconnection to all of the sockets. after that the user will be redirected to the homepage. 

### widgets 
inside of this folder you will find all of the widgets used in the screens

## Roadmap

---


## Coding style conventions

Rules:

- Omit needless words
- Every word should convey what your variable/function/class is doing.
- File name should follow UpperCamelCase rule. Example: SignIn
- Names of classes should follow UpperCamelCase rule. Example: FindTable.

Note:

We use the Dart plugin to format the code and fixes all the styling issues:

To automatically format your code in the current source code window, use Cmd+Alt+L (on Mac) or Ctrl+Alt+L (on Windows and Linux). Android Studio and IntelliJ also provides a check box named Format code on save on the Flutter page in Preferences (on Mac) or Settings (on Windows and Linux) which will format the current file automatically when you save it.

You can also automatically format code in the command line interface (CLI) using the flutter format command:

$ flutter format path1 path2 ...


## Contributing

Rules:

- Please commit every small change to the Github repository.
- Never push something to the main branch.
- There should be a branch for every distinct feature.
- If your feature is done, please make a pull request.
- A team member will review the code and give comments.
- If the pull request is approved, it is going to be merged with the main branch.

Steps:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/INXX-summary-of-ticket`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/INXX-summary-of-ticket`)
5. Open a Pull Request





[invoices-screenshot]: assets/img/invoices.jpeg
[invoice-screenshot]: assets/img/invoice.jpeg
[table-screenshot]: assets/img/table.jpeg
[tables-screenshot]: assets/img/tables.jpeg
[profile-screenshot]: assets/img/profile.jpeg
[homepage-screenshot]: assets/img/homepage.jpeg


