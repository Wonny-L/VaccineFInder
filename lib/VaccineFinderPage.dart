
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vaccine_finder/NotificationHelper.dart';
import 'package:vaccine_finder/model/data/Position.dart';
import 'package:vaccine_finder/model/data/VaccineQuantity.dart';
import 'package:vaccine_finder/model/network/http/VaccineFinderHttpHelper.dart';

class VaccineFinderPage extends StatefulWidget {
  @override
  _VaccineFinderPageState createState() => _VaccineFinderPageState();
}

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class _VaccineFinderPageState extends State<VaccineFinderPage> {
  String _latString = '';
  String _longString = '';

  String boardString = "";
  List<Position> positions = [];
  bool _isFindVaccine = false;

  void _start() {
    if(_isFindVaccine) {
      setState(() {
        _isFindVaccine = false;
      });
    } else {
      setState(() {
        _isFindVaccine = true;
      });

      const duration = const Duration(milliseconds: 0);
      new Timer(duration, () => findVaccine());
    }
  }

  void findVaccine() {
    if(!_isFindVaccine) return;

    positions.forEach((item) async {
      if(_isFindVaccine) {
        VaccineQuantity vaccineQuantity = await VaccineFinderHttpHelper().getAvailableVaccines(item.lat.toString(), item.long.toString());

        setState(() {
          item.quantity = vaccineQuantity.quantity;
          item.lastUpdated = vaccineQuantity.updateTime;

          if(item.quantity > 0) {
            DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(item.lastUpdated!));

            boardString = '${item.quantity}, lastSaved : $date';
          }
        });
      }
    });

    if(_isFindVaccine) {
      const duration = const Duration(milliseconds:500);
      new Timer(duration, () => findVaccine());
    }
  }

  void _addPosition() {
    setState(() {
      positions.add(Position(_latString, _longString));
    });
  }

  void _deletePosition(int index) {
    setState(() {
      positions.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationHelper().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              boardString,
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              margin: EdgeInsets.only(bottom:10, left: 25, right: 25),
              child: TextField(
                  onChanged: (text) {
                    _latString = text;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                  ],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '위도',
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom:10, left: 25, right: 25),
              child: TextField(
                  onChanged: (text) {
                    _longString = text;
                  },
                  inputFormatters: [
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '경도',
                  )
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom:10, right:25, left:25),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(onPressed: _start, child: Text('${_isFindVaccine?'Stop':'Start'}')),
                    ElevatedButton(onPressed: _addPosition, child: Text('ADD')),
                  ]
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: positions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 50,
                    margin: EdgeInsets.all(2),
                    color: Colors.blue[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('위도: ${positions[index].lat}'),
                            Text('경도: ${positions[index].long}')
                          ],
                        ),
                        Row(
                          children: [
                            Text('백신 개수: ${positions[index].quantity}   '),
                            Text('${positions[index].lastUpdated != null ? 'updated: ${DateTime.fromMillisecondsSinceEpoch(int.parse(positions[index].lastUpdated!))}':''}'),
                            ElevatedButton(onPressed: ()=>{_deletePosition(index)}, child: Text('Delete')),
                          ],
                        )
                      ],
                    )
                  );
                }
              )
            ),
          ],
        ),
      ),
    );
  }
}