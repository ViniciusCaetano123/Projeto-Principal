import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:projeto/alarme_editar_page.dart';
import 'package:projeto/login_page.dart';
import 'package:projeto/models/Alarme.dart';
import 'package:projeto/notificacao_page.dart';
import 'package:projeto/store/alarme.store.dart';

import 'alarme_criacao_page.dart';
import 'componentes/semanas_card.dart';
import 'models/AlarmeProvider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'models/Semana.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition(
      forceAndroidLocationManager: true,
      desiredAccuracy: LocationAccuracy.high);
}

const apiKey = "283e742d547debf5c79ac5fc32ffe840";
const openWeatherMapURL = "https://api.openweathermap.org/data/2.5/";
Future<String> getasa(double latitude, double longitude) async {
  http.Response response = await http.get(Uri.parse(
      "${openWeatherMapURL}weather?lat=${latitude}&lon=${longitude}&appid=$apiKey&units=metric&lang=pt_br"));
  return response.body;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AlarmeStore>(
          create: (_) => AlarmeStore(),
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/notificacao': (context) => const NotificacaoPage(),
          '/': (context) => const LoginPage(),
        },
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _repeat = [
    Semana('S', false, 1),
    Semana('T', false, 2),
    Semana('Q', false, 3),
    Semana('Q', false, 4),
    Semana('S', false, 5),
    Semana('S', false, 6),
    Semana('D', false, 7),
  ];

  int umidade = 0;
  double vento = 0;
  String maxMin = '';
  String cidade = '';
  String icone = 'https://openweathermap.org/img/wn/10d@2x.png';
  double tempo = 0;

  List<Alarme> lista_2 = [];

  void _refreshJournals() async {
    await AlarmeProvider.getItems().then((value) {
      setState(() {
        lista_2 = value;
      });
    });
  }

  void editarAlarme(
      String nome, int hora, int minuto, dynamic semana, int index) {
    setState(() {
      lista_2[index].nome = nome;
      lista_2[index].hora = hora;
      lista_2[index].minuto = minuto;
      lista_2[index].segunda = semana[0].isSelect ? 1 : 0;
      lista_2[index].terca = semana[1].isSelect ? 1 : 0;
      lista_2[index].quarta = semana[2].isSelect ? 1 : 0;
      lista_2[index].quinta = semana[3].isSelect ? 1 : 0;
      lista_2[index].sexta = semana[4].isSelect ? 1 : 0;
      lista_2[index].sabado = semana[5].isSelect ? 1 : 0;
      lista_2[index].domingo = semana[6].isSelect ? 1 : 0;
      //  lista_2.add(alarme);
    });
  }

  void adicionarAlarme(Alarme alarme) {
    setState(() {
      lista_2.add(alarme);
    });
  }

  Future<void> cancelarNotificacao(Alarme alarme) async {
    if (alarme.segunda == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}1'));
    }
    if (alarme.terca == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}2'));
    }
    if (alarme.quarta == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}3'));
    }
    if (alarme.quinta == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}4'));
    }
    if (alarme.sexta == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}5'));
    }
    if (alarme.sabado == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}6'));
    }
    if (alarme.domingo == 1) {
      AwesomeNotifications().cancel(int.parse('${alarme.id}7'));
    }

    await AlarmeProvider.updateAtivoAlarme(alarme, alarme.id);
  }

  Future<void> criarNotificacao(Alarme alarme) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    _repeat.forEach((e) => {
          print(e),
          if (e.isSelect)
            {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: int.parse('${alarme.id}${e.weekday}'),
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
                  hour: alarme.hora,
                  millisecond: 0,
                  second: 0,
                  minute: alarme.minuto,
                  timeZone: localTimeZone,
                  preciseAlarm: true,
                ),
              )
            }
        });
    await AlarmeProvider.updateAtivoAlarme(alarme, alarme.id);
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().actionStream.listen((event) {
      /* navigatorKey.currentState.pushAndRemoveUntil(
          
          MaterialPageRoute(builder: (_) => NotificacaoPage()),
          (route) => route.isFirst);*/
    });
    _refreshJournals();
    _determinePosition().then((value) => {
          print(value.latitude),
          print(value.longitude),
          getasa(value.latitude, value.longitude).then((value) {
            final body = json.decode(value);
            print(body);
            final icon = body["weather"][0]["icon"];
            print(icon);
            final urlCon =
                'http://openweathermap.org/img/wn/' + icon + '@2x.png';
            print(urlCon);
            setState(() {
              umidade = body["main"]["humidity"];
              vento = body["wind"]["speed"];
              maxMin = '${body["main"]["temp_min"]}' +
                  '° C' +
                  '...' +
                  '${body["main"]["temp_max"]}' +
                  '° C';
              tempo = body["main"]["temp"];
              cidade = body["name"];
              icone = urlCon;
            });
            print(icone);
            print(umidade);
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: const Color(0xff27272F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cidade} ${tempo}° C ',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        Row(
                          children: [
                            Image.network(icone),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Umidade : ${umidade}%',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('Vento : ${vento}km/h',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text('Minima/Máxima : ${maxMin}',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14))
                              ],
                            )
                          ],
                        )
                      ]),
                ),
                /* ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => NotificacaoPage()),
                          (route) => false);
                    },
                    child: Text('Page Layot Notificação')),*/
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: constraints.maxHeight * 0.80 -
                      10 -
                      80 -
                      20 -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  child: ListView.builder(
                      itemCount: lista_2.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: InkWell(
                            onTap: () {
                              _repeat[0].isSelect = lista_2[index].segunda == 1;
                              _repeat[1].isSelect = lista_2[index].terca == 1;
                              _repeat[2].isSelect = lista_2[index].quarta == 1;
                              _repeat[3].isSelect = lista_2[index].quinta == 1;
                              _repeat[4].isSelect = lista_2[index].sexta == 1;
                              _repeat[5].isSelect = lista_2[index].sabado == 1;
                              _repeat[6].isSelect = lista_2[index].domingo == 1;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlarmeEditarPage(
                                        index,
                                        editarAlarme,
                                        _repeat,
                                        lista_2[index].id,
                                        lista_2[index].hora,
                                        lista_2[index].minuto,
                                        lista_2[index].ativo)),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: const Color(0xff3D3D56),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 6, bottom: 6),
                                child: ListTile(
                                    isThreeLine: true,
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Switch.adaptive(
                                        value: lista_2[index].ativo == 1,
                                        activeColor: const Color(0xffFF7527),
                                        onChanged: (bool value) async {
                                          setState(() {
                                            lista_2[index].ativo =
                                                lista_2[index].ativo == 1
                                                    ? 0
                                                    : 1;
                                          });

                                          if (lista_2[index].ativo == 0) {
                                            print('cancelando');
                                            await cancelarNotificacao(
                                                lista_2[index]);
                                          } else {
                                            await criarNotificacao(
                                              lista_2[index],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    subtitle: Row(children: [
                                      SemanasCard('S', lista_2[index].segunda),
                                      SemanasCard('T', lista_2[index].terca),
                                      SemanasCard('Q', lista_2[index].quarta),
                                      SemanasCard('Q', lista_2[index].quinta),
                                      SemanasCard('S', lista_2[index].sexta),
                                      SemanasCard('S', lista_2[index].sabado),
                                      SemanasCard('D', lista_2[index].domingo)
                                    ]),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'nome do alarme',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Text(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 36,
                                                  color: Colors.white),
                                              '${lista_2[index].hora < 10 ? '0' + lista_2[index].hora.toString() : lista_2[index].hora}' +
                                                  ':' +
                                                  '${lista_2[index].minuto < 10 ? '0' + lista_2[index].minuto.toString() : lista_2[index].minuto} '),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          onPressed: () async {
            _repeat.forEach((element) {
              element.isSelect = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AlarmeCriacaoPage(adicionarAlarme, _repeat)),
            );
          },
          backgroundColor: const Color(0xffFF7527),
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
