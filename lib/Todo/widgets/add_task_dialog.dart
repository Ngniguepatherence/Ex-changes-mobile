import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/chart.dart';
import '../../models/currency.dart';
import '../../models/currency_info.dart';
import '../../models/exchange_rate.dart';
import '../../pages/responsive.dart';
import '../../services/currency_service.dart';
import '../../widget/chart_widget.dart';
import '../../widget/trending_widget.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AddTaskAlertDialog extends StatefulWidget {
  const AddTaskAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTaskAlertDialog> createState() => _AddTaskAlertDialogState();
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final List<String> taskTags = ['Offre', 'Demande', 'Other'];
  late String selectedValue = '';

  String _fromCurrency = 'EUR';
  double _amount = 5;
  String _toCurrency = 'USD';
  final TextEditingController _textEditingController =
      TextEditingController(text: '5');

  Future<List<Currency>> getCurrencyForDropdown =
      CurrencyService().getCurrencyList();
  Future<List<CurrencyInfo>> getTrendingList =
      CurrencyService().getTrendingList();
  late Future<ExchangeRate> getExchangeRate =
      CurrencyService().getExchangeRate(_fromCurrency, _toCurrency, _amount);
  List<Indicator> chartData = [];

  Future<void> generateChartData(String from) async {
    List<Indicator> indicators = await CurrencyService().getCurrencyChart(from);
    setState(() {
      chartData = indicators;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Nouvelle Annonce',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
          child: Container(
        child: Column(
          children: [
            Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: taskNameController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      hintText: 'Raison de transaction Prop/demande',
                      hintStyle: const TextStyle(fontSize: 14),
                      icon: const Icon(CupertinoIcons.square_list,
                          color: Colors.brown),
                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                    ),
                  ),
                  SizedBox(width: 16),
                  const SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      const Icon(CupertinoIcons.tag, color: Colors.brown),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          isExpanded: true,
                          hint: const Text(
                            "Type d'annonce..",
                            style: TextStyle(fontSize: 14),
                          ),
                          // validator: (value) => value == null
                          //     ? 'Please select the task tag' : null,
                          items: taskTags
                              .map(
                                (item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (String? value) => setState(
                            () {
                              if (value != null) selectedValue = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Card(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: !Responsive.isSmallScreen(context)
                          ? Container(
                              padding: EdgeInsets.only(top: 50, bottom: 50),
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          amountInput(_screenSize, false),
                                          SizedBox(width: 16),
                                          fromCurrencyInput(_screenSize, false),
                                          SizedBox(width: 16),
                                          toCurrencyInput(_screenSize, false),
                                        ],
                                      ),
                                      SizedBox(height: 25),
                                      Container(
                                        width: _screenSize.width / 1.61,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'We use midmarket rates.',
                                                    style: TextStyle(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    Icons.info_outline,
                                                    color: Colors.grey[600],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  getExchangeRate =
                                                      CurrencyService()
                                                          .getExchangeRate(
                                                              _fromCurrency,
                                                              _toCurrency,
                                                              _amount);
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(15),
                                                child: Text('Convert'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  amountInput(_screenSize, true),
                                  SizedBox(height: 16),
                                  fromCurrencyInput(_screenSize, true),
                                  SizedBox(height: 16),
                                  toCurrencyInput(_screenSize, true),
                                  SizedBox(height: 16),
                                  SizedBox(height: 30),
                                  Text(
                                      'Ajouter votre offre ou demande pour etre satisfait'),
                                ],
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
          ],
        ),
      )),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final taskName = taskNameController.text;
            final taskTag = selectedValue;
            _addTasks(taskName: taskName, taskTag: taskTag);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future _addTasks({required String taskName, required String taskTag}) async {
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('tasks').add(
      {
        'taskName': taskName,
        'amount': _amount,
        'CurrencyFrom': _fromCurrency,
        'CurrencyTo': _toCurrency,
        'taskTag': taskTag,
        'State': true
      },
    );
    String taskId = docRef.id;

    await FirebaseFirestore.instance.collection('tasks').doc(taskId).update(
      {'id': taskId},
    );
    _clearAll();
  }

  void _clearAll() {
    taskNameController.text = '';
    taskDescController.text = '';
  }

  Column toCurrencyInput(Size _screenSize, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: !isMobile ? _screenSize.width : double.infinity,
          child: FutureBuilder(
            future: getCurrencyForDropdown,
            builder: (context, AsyncSnapshot<List<Currency>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return DropdownButtonFormField(
                    value: _toCurrency,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _toCurrency = value as String;
                        getExchangeRate = CurrencyService().getExchangeRate(
                            _fromCurrency, _toCurrency, _amount);
                      });
                    },
                    items: snapshot.data?.map((c) {
                      return DropdownMenuItem<String>(
                        value: c.code,
                        child: Container(
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 22,
                                  minHeight: 22,
                                  maxWidth: 22,
                                  maxHeight: 22,
                                ),
                                child: Image.asset('assets/images/${c.code}.png'
                                    .toLowerCase()),
                              ),
                              SizedBox(width: 5),
                              Text(
                                !isMobile
                                    ? (Responsive.isLargeScreen(context))
                                        ? '${c.name}'
                                        : '${c.code}'
                                    : '${c.code} - ${c.name}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Center(
                    child: Text('Error loading data.'),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Column fromCurrencyInput(Size _screenSize, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: !isMobile ? _screenSize.width : double.infinity,
          child: FutureBuilder(
            future: getCurrencyForDropdown,
            builder: (context, AsyncSnapshot<List<Currency>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return DropdownButtonFormField(
                    value: _fromCurrency,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _fromCurrency = value as String;
                        getExchangeRate = CurrencyService().getExchangeRate(
                            _fromCurrency, _toCurrency, _amount);
                        generateChartData(_fromCurrency);
                      });
                    },
                    items: snapshot.data?.map((c) {
                      return DropdownMenuItem<String>(
                        value: c.code,
                        child: Container(
                          child: Row(
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 22,
                                  minHeight: 22,
                                  maxWidth: 22,
                                  maxHeight: 22,
                                ),
                                child: Image.asset('assets/images/${c.code}.png'
                                    .toLowerCase()),
                              ),
                              SizedBox(width: 5),
                              Text(
                                !isMobile
                                    ? (Responsive.isLargeScreen(context))
                                        ? '${c.name}'
                                        : '${c.code}'
                                    : '${c.code} - ${c.name}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return Center(
                    child: Text('Error loading data.'),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Container converterView(Size _screenSize) {
    return Container(
      child: FutureBuilder(
        future: getExchangeRate,
        builder: (context, AsyncSnapshot<ExchangeRate> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              ExchangeRate? rate = snapshot.data;
              return Container(
                width: _screenSize.width / 1.61,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Card(
                        elevation: 0,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_amount $_fromCurrency equals',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${rate!.totalFromCurrencyRate} $_toCurrency',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '$_amount $_toCurrency equals',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${rate.totalToCurrencyRate} $_toCurrency',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                  '1 $_fromCurrency = ${rate.fromCurrencyRate} $_toCurrency'),
                              SizedBox(height: 5),
                              Text(
                                  '1 $_toCurrency = ${rate.toCurrencyRate} $_fromCurrency'),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!Responsive.isSmallScreen(context))
                      Container(
                        width: (_screenSize.width / 1.61) / 1.5,
                        child: Card(
                          elevation: 0,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: DataTable(
                                    horizontalMargin: 0,
                                    columnSpacing: 5,
                                    columns: [
                                      DataColumn(
                                          label: Container(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Row(
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                minHeight: 22,
                                                minWidth: 22,
                                                maxHeight: 22,
                                                maxWidth: 22,
                                              ),
                                              child: Image.asset(
                                                  'assets/images/$_fromCurrency.png'),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '$_fromCurrency',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                      DataColumn(
                                        label: Text(
                                          'Last Price',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Change',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          '% Change',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(
                                            Container(
                                              padding: EdgeInsets.only(left: 8),
                                              child: Text(
                                                '$_fromCurrency/$_toCurrency',
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.marketPrice!.fmt}',
                                              style: TextStyle(
                                                color:
                                                    (!'${rate.fromCurrencyInfo!.marketPrice!.fmt}'
                                                            .startsWith('-'))
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.marketChange!.fmt}',
                                              style: TextStyle(
                                                color:
                                                    (!'${rate.fromCurrencyInfo!.marketChange!.fmt}'
                                                            .startsWith('-'))
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.marketChangePercent!.fmt}',
                                              style: TextStyle(
                                                color:
                                                    (!'${rate.fromCurrencyInfo!.marketChangePercent!.fmt}'
                                                            .startsWith('-'))
                                                        ? Colors.green
                                                        : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Container(
                                  width: double.infinity,
                                  child: DataTable(
                                    horizontalMargin: 0,
                                    columnSpacing: 5,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          'Previous Close',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Open',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Day Low',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'DayHigh',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                    rows: [
                                      DataRow(
                                        cells: [
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.summaryDetail!.previousClose}',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.summaryDetail!.open}',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.summaryDetail!.dayLow}',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              '${rate.fromCurrencyInfo!.summaryDetail!.dayHigh}',
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Error loading data'),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Column amountInput(Size _screenSize, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Montant',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: !isMobile ? _screenSize.width : double.infinity,
          child: TextFormField(
            controller: _textEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(
                RegExp(r'^(\d+)?\.?\d{0,2}'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _amount = double.parse(value);
                getExchangeRate = CurrencyService()
                    .getExchangeRate(_fromCurrency, _toCurrency, _amount);
              });
            },
          ),
        ),
      ],
    );
  }
}
