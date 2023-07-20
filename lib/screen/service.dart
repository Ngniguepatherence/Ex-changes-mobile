import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../models/chart.dart';
import '../models/currency.dart';
import '../models/currency_info.dart';
import '../models/exchange_rate.dart';
import '../pages/responsive.dart';
import '../services/currency_service.dart';
import '../widget/chart_widget.dart';
import '../widget/trending_widget.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AddTaskAlertDialog extends StatefulWidget {
  const AddTaskAlertDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskAlertDialogState createState() => _AddTaskAlertDialogState();
}

class _AddTaskAlertDialogState extends State<AddTaskAlertDialog> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'New Task',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        height: height * 0.35,
        width: width,
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Task',
                  hintStyle: const TextStyle(fontSize: 14),
                  icon: const Icon(CupertinoIcons.square_list,
                      color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  amountInput(_screenSize, false),
                  SizedBox(width: 16),
                  fromCurrencyInput(_screenSize, false),
                  SizedBox(width: 16),
                  toCurrencyInput(_screenSize, false),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  hintText: 'Description',
                  hintStyle: const TextStyle(fontSize: 14),
                  icon: const Icon(CupertinoIcons.bubble_left_bubble_right,
                      color: Colors.brown),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: const <Widget>[
                  Icon(CupertinoIcons.tag, color: Colors.brown),
                  SizedBox(width: 15.0),
                  // TaskTags(),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.popUntil(context, (route) => false);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ],
    );
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
          width: !isMobile ? _screenSize.width / 5 : double.infinity,
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
          width: !isMobile ? _screenSize.width / 5 : double.infinity,
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

  Column amountInput(Size _screenSize, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: !isMobile ? _screenSize.width / 5 : double.infinity,
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
