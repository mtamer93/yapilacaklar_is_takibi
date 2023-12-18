import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_takibi/detay.dart';
import 'package:is_takibi/is_model.dart';
import 'package:uuid/uuid.dart';

void main() {
  // runApp(MyWidget());
  runApp(MaterialApp(home: MyWidget()));
}

class MyWidget extends StatefulWidget {
  MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String headingList = '';
  String subtitleList = 'Low';
  String? selectedValue = '';
  TextEditingController _controller = TextEditingController();
  bool inkwellStar = false;
  Icon leadingIcon = Icon(Icons.star_border);

  List<IsModel> isModelList = [];
  // IsModel('1. Deneme', 'Low', 'Aciklama ekleyiniz', const Uuid().v4(), false,
  //     Icon(Icons.star_border), false)
  // ];

  void addItemToList(IsModel newItem) {
    setState(() {
      isModelList.add(newItem);
    });
  }

  Widget _textField() {
    return TextField(
      controller: _controller,
      obscureText: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter text',
      ),
    );
  }

  Widget _cards() {
    return Card(
      child: ListView.builder(
        itemCount: isModelList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: isModelList[index].starCheck
                ? Text(isModelList[index].baslik,
                    style: TextStyle(decoration: TextDecoration.lineThrough))
                : Text(isModelList[index].baslik),
            subtitle: Row(
              children: [
                Text('Oncelik durumu: '),
                Text(
                  isModelList[index].aciliyet,
                  style: TextStyle(
                      color: isModelList[index].aciliyet == 'Low'
                          ? Colors.green
                          : isModelList[index].aciliyet == 'Medium'
                              ? Colors.orange
                              : Colors.red),
                ),
              ],
            ),
            leading: InkWell(
              child: isModelList[index].leadingIcon,
              onTap: () {
                setState(() {
                  if (isModelList[index].starCheck == false) {
                    isModelList[index].starCheck = true;
                    isModelList[index].leadingIcon = Icon(Icons.star);
                  } else {
                    isModelList[index].starCheck = false;
                    isModelList[index].leadingIcon = Icon(Icons.star_border);
                  }
                });
              },
            ),
            trailing: InkWell(
              child: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  isModelList.removeAt(index);
                });
              },
            ),
            onTap: () {
              setState(() {
                try {
                  if (isModelList.isNotEmpty &&
                      index >= 0 &&
                      index < isModelList.length) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Detay(
                              isModelList: isModelList,
                              index: index,
                            )));
                  }
                } catch (e) {}
              });
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int indexOfRemove = -1;
    for (var i = 0; i < isModelList.length; i++) {
      if (isModelList[i].isRemoved) {
        indexOfRemove = i;
      }
    }
    if (indexOfRemove >= 0) {
      isModelList.removeAt(indexOfRemove);
    }

    double width = MediaQuery.of(context).size.width;
    String today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // double height = MediaQuery.of(context).size.height;
    // _cards()
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('${today}'),
        ),
        // body: _cards(),
        body: Stack(children: [_cards()]), //_textField()
        floatingActionButton: Stack(children: [
          Padding(
            padding: EdgeInsets.only(left: width / 20),
            child: Container(width: (width / 4) * 3, child: _textField()),
          ),
          Padding(
            padding: EdgeInsets.only(left: (width / 4) * 3.3),
            child: FloatingActionButton.extended(
                onPressed: () async {
                  if (!_controller.text.isEmpty) {
                    selectedValue = await _showPopup(context);
                    setState(() {
                      headingList = _controller.text;
                      inkwellStar = false;
                      subtitleList = selectedValue!;
                      leadingIcon = Icon(Icons.star_border);
                      isModelList.add(IsModel(
                          headingList,
                          subtitleList,
                          'Açıklama ekleyiniz',
                          const Uuid().v4(),
                          inkwellStar,
                          leadingIcon,
                          false));
                      _controller.clear();
                      print('Width: ${width}');
                    });
                  }
                },
                label: Text('Add Item')),
          ),
        ]),
      ),
    );
  }

  Future<String?> _showPopup(BuildContext context) async {
    Completer<String?> completer = Completer<String?>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Please select importance Level'),
          content: PopupMenuButton<String>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Low',
                  child: Text('Low'),
                ),
                PopupMenuItem<String>(
                  value: 'Medium',
                  child: Text('Medium'),
                ),
                PopupMenuItem<String>(
                  value: 'High',
                  child: Text('High'),
                ),
              ];
            },
            onSelected: (String value) {
              // Complete the Future with the selected value
              completer.complete(value);

              // Close the pop-up window
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Complete the Future with a default value
                completer.complete('Low');

                // Close the pop-up window
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );

    // Return the Future for the selected value
    return completer.future;
  }
}
