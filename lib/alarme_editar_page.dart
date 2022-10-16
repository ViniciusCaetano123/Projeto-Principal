import '/models/AlarmeProvider.dart';
import '/models/Semana.dart';
import './store/alarme.store.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'models/Alarme.dart';

import 'componentes/lista_minutos_horas.dart';

final store = AlarmeStore();

class AlarmeEditarPage extends StatefulWidget {
  Function editarAlarmePai;
  List<Semana> _repeat;
  int id;
  int ativo;
  int hora;
  int minuto;
  int index;
  AlarmeEditarPage(this.index, this.editarAlarmePai, this._repeat, this.id,
      this.hora, this.minuto, this.ativo);

  @override
  State<AlarmeEditarPage> createState() => _AlarmeEditarPage();
}

class _AlarmeEditarPage extends State<AlarmeEditarPage> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white,
              channelShowBadge: true,
              enableVibration: true,
              playSound: true,
              locked: true,
              // soundSource: "resource://raw/exemplo.m4a",
              enableLights: true,
              importance: NotificationImportance.High)
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);
    super.initState();
  }

  void adicionarNumero(int num) {
    widget.minuto = num;
  }

  void adicionarHora(int num) {
    widget.hora = num;
  }

  Future<int> _editarItem() async {
    int id = 0;
    await AlarmeProvider.updateAlarme(
            'Alarme 1',
            widget.hora,
            widget.minuto,
            widget._repeat[6].isSelect ? 1 : 0,
            widget._repeat[0].isSelect ? 1 : 0,
            widget._repeat[1].isSelect ? 1 : 0,
            widget._repeat[2].isSelect ? 1 : 0,
            widget._repeat[3].isSelect ? 1 : 0,
            widget._repeat[4].isSelect ? 1 : 0,
            widget._repeat[5].isSelect ? 1 : 0,
            widget.ativo,
            widget.id)
        .then((value) {
      id = value;
    });
    return id;
  }

  void editarAlarme() async {
    int id = await _editarItem();
    print(widget.id);
    if (widget._repeat[0].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}1'));
    }
    if (widget._repeat[1].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}2'));
    }
    if (widget._repeat[2].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}3'));
    }
    if (widget._repeat[3].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}4'));
    }
    if (widget._repeat[4].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}5'));
    }
    if (widget._repeat[5].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}6'));
    }
    if (widget._repeat[6].isSelect) {
      AwesomeNotifications().cancel(int.parse('${widget.id}7'));
    }
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    widget.editarAlarmePai(
        'Alarme 1', widget.hora, widget.minuto, widget._repeat, widget.index);
    widget._repeat.forEach((e) => {
          if (e.isSelect)
            {
              print(widget.id + e.weekday),
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: int.parse('${widget.id}${e.weekday}'),
                    notificationLayout: NotificationLayout.BigText,
                    channelKey: 'basic_channel',
                    title: 'Simple Notification',
                    body: 'Simple body',
                    category: NotificationCategory.Alarm,
                    fullScreenIntent: true,
                    criticalAlert: true,
                    displayOnBackground: true,
                    displayOnForeground: true,
                    wakeUpScreen: true),
                schedule: NotificationCalendar(
                  repeats: true,
                  weekday: e.weekday,
                  hour: widget.hora,
                  millisecond: 0,
                  second: 0,
                  minute: widget.minuto,
                  timeZone: localTimeZone,
                  preciseAlarm: true,
                ),
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0396FF),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            child: Column(children: [
              Container(
                height: 70 -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: const Text('<'),
              ),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: constraints.maxHeight -
                      70 -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0)),
                  ),
                  child: Column(
                    children: [
                      Text('${store.hora}'),
                      Container(
                          height: 200,
                          child: ListaMinutosHoras(adicionarNumero,
                              adicionarHora, widget.hora, widget.minuto)),
                      const SizedBox(height: 50),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Repetir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: widget._repeat.map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  e.isSelect = !e.isSelect;
                                });
                              },
                              child: Container(
                                  child: Text(
                                    '${e.text}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: e.text == 'D'
                                          ? e.isSelect
                                              ? Colors.red
                                              : Colors.red[200]
                                          : e.isSelect
                                              ? Color(0xff0396FF)
                                              : Colors.grey[300])),
                            );
                          }).toList()),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => {AwesomeNotifications().cancelAll()},
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: editarAlarme,
                              child: Text('Salvar'))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          );
        }),
      ),
    );
  }
}
