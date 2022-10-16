import '/models/AlarmeProvider.dart';
import '/models/Semana.dart';
import './store/alarme.store.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/Alarme.dart';

import 'componentes/lista_minutos_horas.dart';

final store = AlarmeStore();

class AlarmeCriacaoPage extends StatefulWidget {
  Function adicionarAlarme;
  List<Semana> _repeat;
  AlarmeCriacaoPage(this.adicionarAlarme, this._repeat);

  @override
  State<AlarmeCriacaoPage> createState() => _AlarmeCriacaoPage();
}

class _AlarmeCriacaoPage extends State<AlarmeCriacaoPage> {
  DateTime _dateTime = DateTime.now();
  int minuto = DateTime.now().minute;
  int hora = DateTime.now().hour;

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
    minuto = num;
    print(minuto);
  }

  void adicionarHora(int num) {
    hora = num;
    print(hora);
  }

  Future<int> _addItem() async {
    int id = 0;
    await AlarmeProvider.createAlarme(
            'Alarme 1',
            hora,
            minuto,
            widget._repeat[6].isSelect ? 1 : 0,
            widget._repeat[0].isSelect ? 1 : 0,
            widget._repeat[1].isSelect ? 1 : 0,
            widget._repeat[2].isSelect ? 1 : 0,
            widget._repeat[3].isSelect ? 1 : 0,
            widget._repeat[4].isSelect ? 1 : 0,
            widget._repeat[5].isSelect ? 1 : 0,
            1)
        .then((value) {
      id = value;
    });
    return id;
  }

  void criarAlarme() async {
    int id = await _addItem();
    print(id);
    setState(() {
      widget.adicionarAlarme(Alarme(
        id: id,
        nome: 'teste',
        hora: hora,
        minuto: minuto,
        domingo: widget._repeat[6].isSelect ? 1 : 0,
        sabado: widget._repeat[5].isSelect ? 1 : 0,
        segunda: widget._repeat[0].isSelect ? 1 : 0,
        terca: widget._repeat[1].isSelect ? 1 : 0,
        quarta: widget._repeat[2].isSelect ? 1 : 0,
        quinta: widget._repeat[3].isSelect ? 1 : 0,
        sexta: widget._repeat[4].isSelect ? 1 : 0,
        ativo: 1,
      ));
    });

    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    widget._repeat.forEach((e) => {
          if (e.isSelect)
            {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: int.parse('${id}${e.weekday}'),
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
                  hour: hora,
                  millisecond: 0,
                  second: 0,
                  minute: minuto,
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
      backgroundColor: const Color(0xff27272F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFF7527),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 30,
                    width: 30,
                    child: Center(
                        child: const Text(
                      '<',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                  Row(
                    children: [
                      Switch.adaptive(
                          value: true,
                          activeColor: const Color(0xffFF7527),
                          onChanged: (bool value) async {
                            setState(() {});
                          })
                    ],
                  ),
                  SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      height: constraints.maxHeight -
                          70 -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                      child: Column(
                        children: [
                          Container(
                              height: 200,
                              child: ListaMinutosHoras(adicionarNumero,
                                  adicionarHora, hora, minuto)),
                          const SizedBox(height: 50),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Repetir',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: e.isSelect
                                              ? Color(0xffFF7527)
                                              : Color(0xffD9D9D9))),
                                );
                              }).toList()),
                          const SizedBox(height: 45),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () =>
                                    {AwesomeNotifications().cancelAll()},
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
                                  onPressed: criarAlarme,
                                  child: Text('Salvar'))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }
}
