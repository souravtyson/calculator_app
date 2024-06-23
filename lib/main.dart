import 'package:flutter/material.dart';

void main() {
  runApp(const MyCalculator());
}

class MyCalculator extends StatefulWidget {
  const MyCalculator({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyCalculatorState();
  }
}

class _MyCalculatorState extends State<MyCalculator> {
  final List<String> _operatorsOptions = ['+', '-', '*', '/'];
  String _input = '';
  String _operator = '';
  String _displayText = '0';
  String _result = '';

  /// Clears all inputs and resets the calculator
  void _clearAll() {
    _displayText = '0';
    _input = '';
    _operator = '';
    _result = '';
  }

  /// Sets the operator and prepares for the next input
  void _setOperator(String value) {
    if (_result.isNotEmpty && _input.isEmpty) {
      _operator = value;
      _displayText = '$_result $_operator';
    } else if (_input.isNotEmpty) {
      _calculateResult();
      _operator = value;
      _displayText = '$_result $_operator';
      _input = '';
    }
  }

  /// Calculates the result based on the current operator and inputs
  void _calculateResult() {
    if (_operator.isNotEmpty && _input.isNotEmpty) {
      double num2;
      double num1;
      try {
        num2 = double.parse(_input);
        num1 = double.parse(_result.isEmpty ? '0' : _result);
      } catch (e) {
        _displayText = 'Error';
        return;
      }

      switch (_operator) {
        case '+':
          _result = (num1 + num2).toString();
          break;
        case '-':
          _result = (num1 - num2).toString();
          break;
        case '*':
          _result = (num1 * num2).toString();
          break;
        case '/':
          _result = (num2 != 0) ? (num1 / num2).toString() : 'Error';
          break;
      }
    }
    _displayText = _result == 'Error' ? 'Can\'t divide by 0' : _result;
    _input = '';
    _operator = '';
  }

  /// Appends a value to the current input
  void _appendValue(String value) {
    if (value == '.' && _input.contains('.')) {
      return;
    }
    if (_operator.isEmpty) {
      _input += value;
      _displayText = _input;
      _result = _input;
    } else {
      _displayText += value;
      _input += value;
    }
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clearAll();
      } else if (_operatorsOptions.contains(value)) {
        _setOperator(value);
      } else if (value == '=') {
        _calculateResult();
      } else {
        _appendValue(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Calculator'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Column(
          children: [
            DisplayArea(displayText: _displayText),
            Expanded(child: ButtonGrid(onButtonPressed: _onButtonPressed))
          ],
        ),
      ),
    );
  }
}

class DisplayArea extends StatelessWidget {
  final String displayText;
  const DisplayArea({super.key, required this.displayText});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150,
        color: Colors.black,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          reverse: true,
          child: Text(
            displayText,
            style: const TextStyle(color: Colors.white, fontSize: 48),
          ),
        ));
  }
}

class ButtonGrid extends StatelessWidget {
  final Function(String) onButtonPressed;
  const ButtonGrid({required this.onButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 4,
      children: [
        createButton('7'),
        createButton('8'),
        createButton('9'),
        createButton('+'),
        createButton('4'),
        createButton('5'),
        createButton('6'),
        createButton('-'),
        createButton('1'),
        createButton('2'),
        createButton('3'),
        createButton('*'),
        createButton('0'),
        createButton('C'),
        createButton('='),
        createButton('/'),
        createButton('.'),
      ],
    );
  }

  Widget createButton(String text) {
    return ElevatedButton(
        onPressed: () => onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(15),
          textStyle: const TextStyle(fontSize: 20),
        ),
        key: Key(text),
        child: Text(text),
      );
  }
}
