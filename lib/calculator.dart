import 'package:flutter/material.dart';
import 'widgets/number_button.dart';
import 'widgets/zero_button.dart';
import 'widgets/binary_operator_button.dart';
import 'widgets/unary_operator_button.dart';
import 'constants.dart';

enum Operation {
  none,
  divide,
  multiply,
  subtract,
  add,
  clear,
  changeSign,
  addDecimal,
  percent,
  equals
}

enum BinaryOperation {
  divide,
  multiply,
  subtract,
  add,
}

enum UnaryOperation {
  changeSign,
  percent,
}

enum OtherOperation { clear, addDecimal, equals }

class CalculatorApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: new ThemeData(
        primaryColor: Colors.black,
      ),
      home: new HomePage(title: 'Flutter Calculator Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var operand1;
  var operand2;
  String operator;
  var result;
  bool isOperand1Completed;
  TextStyle _whiteTextStyle = TextStyle(color: Colors.white, fontSize: 35.0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialiseValues();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        operand1 != null
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  operand1 is double
                                      ? operand1.toStringAsFixed(2)
                                      : operand1.toString(),
                                  style: _whiteTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              )
                            : Container(),
                        operator != null
                            ? Text(
                                operator.toString(),
                                style: _whiteTextStyle,
                                textAlign: TextAlign.right,
                              )
                            : Container(),
                        operand2 != null
                            ? Text(
                                operand2.toString(),
                                style: _whiteTextStyle,
                                textAlign: TextAlign.right,
                              )
                            : Container(),
                        result != null
                            ? Divider(
                                height: 5.0,
                                color: Colors.white,
                              )
                            : Container(),
                        result != null
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  result is double
                                      ? result.toStringAsFixed(2)
                                      : result.toString(),
                                  style: _whiteTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  UnaryOperatorButton(
                    text: "AC",
                    onPressed: () {
                      _otherOperationAction(OtherOperation.clear);
                    },
                  ),
                  UnaryOperatorButton(
                    text: plus_or_minus_sign,
                    onPressed: (){_unaryOperationAction(UnaryOperation.changeSign);},
                  ),
                  UnaryOperatorButton(
                    text: percent_sign,
                    onPressed: (){_unaryOperationAction(UnaryOperation.percent);},
                  ),
                  BinaryOperatorButton(
                    text: divide_sign,
                    onPressed: () {
                      _binaryOperationAction(BinaryOperation.divide);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NumberButton(
                      text: "7",
                      onPressed: () {
                        _numberButtonAction("7");
                      }),
                  NumberButton(
                      text: "8",
                      onPressed: () {
                        _numberButtonAction("8");
                      }),
                  NumberButton(
                      text: "9",
                      onPressed: () {
                        _numberButtonAction("9");
                      }),
                  BinaryOperatorButton(
                    text: multiply_sign,
                    onPressed: () {
                      _binaryOperationAction(BinaryOperation.multiply);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NumberButton(
                      text: "4",
                      onPressed: () {
                        _numberButtonAction("4");
                      }),
                  NumberButton(
                      text: "5",
                      onPressed: () {
                        _numberButtonAction("5");
                      }),
                  NumberButton(
                      text: "6",
                      onPressed: () {
                        _numberButtonAction("6");
                      }),
                  BinaryOperatorButton(
                    text: minus_sign,
                    onPressed: () {
                      _binaryOperationAction(BinaryOperation.subtract);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NumberButton(
                      text: "1",
                      onPressed: () {
                        _numberButtonAction("1");
                      }),
                  NumberButton(
                      text: "2",
                      onPressed: () {
                        _numberButtonAction("3");
                      }),
                  NumberButton(
                      text: "3",
                      onPressed: () {
                        _numberButtonAction("3");
                      }),
                  BinaryOperatorButton(
                    text: add_sign,
                    onPressed: () {
                      _binaryOperationAction(BinaryOperation.add);
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ZeroButton(onPressed: (){_zeroButtonAction();},),
                  BinaryOperatorButton(
                    text: ".",
                    onPressed: () {
                      _otherOperationAction(OtherOperation.addDecimal);
                    },
                  ),
                  BinaryOperatorButton(
                    text: equal_sign,
                    onPressed: () {
                      _otherOperationAction(OtherOperation.equals);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void initialiseValues() {
    operand1 = null;
    operand2 = null;
    result = null;
    operator = null;
    isOperand1Completed = false;
  }

  void _findOutput() {
    if (operand1 == null || operand2 == null) return;
    var exp1 = double.parse(operand1.toString());
    var exp2 = double.parse(operand2.toString());
    switch (operator) {
      case add_sign:
        result = exp1 + exp2;
        break;
      case minus_sign:
        result = exp1 - exp2;
        break;
      case multiply_sign:
        result = exp1 * exp2;
        break;
      case divide_sign:
        result = exp1 / exp2;
        break;
      case percent_sign:
        result = exp1 % exp2;
        break;
    }
    if (result.toString().endsWith(".0")) {
      result = int.parse(result.toString().replaceAll(".0", ""));
    }
  }

 void _numberButtonAction(String text) {
    if (result != null) initialiseValues();
    if (isOperand1Completed) {
      if (operand2 == null) {
        operand2 = text;
      } else {
        if (operand2.toString().length < 9) operand2 += text;
      }
    } else {
      if (operand1 == null) {
        operand1 = text;
      } else {
        if (operand1.toString().length < 9) operand1 += text;
      }
    }
    setState(() {});
  }


 void _zeroButtonAction() {
    if (result != null) initialiseValues();
    if (isOperand1Completed) {
      if (operand2 == null || operand1 == "0")
        operand2 = "0";
      else {
        if (operand2.toString().length < 9) operand2 += "0";
      }
    } else {
      if (operand1 == null || operand1 == "0") {
        operand1 = "0";
      } else {
        if (operand1.toString().length < 9) operand1 += "0";
      }
    }
    setState(() {});
  }

 void _binaryOperationAction(BinaryOperation operation) {
    switch (operation) {
      case BinaryOperation.add:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = add_sign;
        isOperand1Completed = true;
        break;
      case BinaryOperation.subtract:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = minus_sign;
        isOperand1Completed = true;
        break;
      case BinaryOperation.multiply:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = multiply_sign;
        isOperand1Completed = true;
        break;
      case BinaryOperation.divide:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = divide_sign;
        isOperand1Completed = true;
        break;
    }
    setState(() {});
  }

 void _unaryOperationAction(UnaryOperation operation) {
    switch (operation) {
      case UnaryOperation.changeSign:
        if (result != null)
          result = -result;
        else if (isOperand1Completed) {
          if (operand2 != null) {
            operand2 = (-int.parse(operand2)).toString();
          }
        } else {
          if (operand1 != null) {
            operand1 = (-int.parse(operand1)).toString();
          }
        }
        break;
      case UnaryOperation.percent:
        if (result != null)
          result = result / 100;
        else if (isOperand1Completed) {
          if (operand2 != null) {
            operand2 = (double.parse(operand2) / 100).toString();
          }
        } else {
          if (operand1 != null) {
            operand1 = (double.parse(operand1) / 100).toString();
          }
        }
        break;
    }
    setState(() {});
  }

  _otherOperationAction(OtherOperation operation) {
    switch (operation) {
      case OtherOperation.clear:
        initialiseValues();
        break;
      case OtherOperation.addDecimal:
        if (result != null) initialiseValues();
        if (isOperand1Completed) {
          if (!operand2.toString().contains(".")) {
            if (operand2 == null) {
              operand2 = ".";
            } else {
              operand2 += ".";
            }
          }
        } else {
          if (!operand1.toString().contains(".")) {
            if (operand1 == null) {
              operand1 = ".";
            } else {
              operand1 += ".";
            }
          }
        }
        break;
      case OtherOperation.equals:
        if (result == null) _findOutput();

        break;
    }
    setState(() {});
  }
}
