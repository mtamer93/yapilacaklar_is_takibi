import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:is_takibi/is_model.dart';

// ignore: must_be_immutable
class Detay extends StatefulWidget {
  Detay({super.key, required this.isModelList, required this.index});

  List<IsModel>? isModelList;
  int index;

  @override
  State<Detay> createState() => _DetayState();
}

class _DetayState extends State<Detay> {
  TextEditingController _aciklamaController = TextEditingController();

  String today = DateFormat('dd-MM-yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    if (widget.isModelList != null) {
      _aciklamaController.text =
          widget.isModelList![widget.index].aciklama.isNotEmpty
              ? widget.isModelList![widget.index].aciklama
              : '';
      return Scaffold(
        appBar: AppBar(
          title: Text('${today}'),
        ),
        body: Column(
          children: [
            ListTile(
              leading: widget.isModelList![widget.index].leadingIcon,
              title: widget.isModelList![widget.index].starCheck
                  ? Text(widget.isModelList![widget.index].baslik +
                      ' (Tamamlandı.)')
                  : Text(widget.isModelList![widget.index].baslik),
              subtitle: Row(
                children: [
                  Text('Oncelik durumu: '),
                  Text(
                    widget.isModelList![widget.index].aciliyet,
                    style: TextStyle(
                        color:
                            widget.isModelList![widget.index].aciliyet == 'Low'
                                ? Colors.green
                                : widget.isModelList![widget.index].aciliyet ==
                                        'Medium'
                                    ? Colors.orange
                                    : Colors.red),
                  ),
                ],
              ),
              trailing: InkWell(
                child: Icon(Icons.delete),
                onTap: () {
                  widget.isModelList![widget.index].isRemovedList(true);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 60,
              height: (MediaQuery.of(context).size.height) / 5,
              child: TextField(
                controller: _aciklamaController,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Enter text',
                  filled: true,
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              child: Text('Aciklama Ekle'),
              onPressed: () {
                // Navigate back to Screen 1
                widget.isModelList![widget.index].aciklama =
                    _aciklamaController.text;
              },
            ),
            ElevatedButton(
              child: Text('geri don'),
              onPressed: () {
                // Navigate back to Screen 1
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text('Liste boş'),
      );
    }
  }
}
