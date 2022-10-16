import '../store/alarme.store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

final store = AlarmeStore();

class ListaMinutosHoras extends StatefulWidget {
  Function adicionarNumero;
  Function adicionarHora;
  int hora;
  int minuto;
  ListaMinutosHoras(
      this.adicionarNumero, this.adicionarHora, this.hora, this.minuto);

  @override
  State<ListaMinutosHoras> createState() => _ListaMinutosHorasState();
}

class _ListaMinutosHorasState extends State<ListaMinutosHoras> {
  double _constIconSize = 50;

  @override
  Widget build(BuildContext context) {
    final _controllerHora =
        FixedExtentScrollController(initialItem: widget.hora);
    final _controllerMinuto =
        FixedExtentScrollController(initialItem: widget.minuto);

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          Positioned(
            child: Center(
              child: Text(
                ':',
                style: TextStyle(
                    fontSize: 46,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    onSelectedItemChanged: (value) => setState(() {
                      widget.adicionarHora(value);
                    }),
                    controller: _controllerHora,
                    itemExtent: 65,
                    diameterRatio: 2.5,
                    useMagnifier: true,
                    perspective: 0.005,
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 24,
                        builder: (context, index) {
                          return Container(
                            child: Center(
                                child: Text(
                              '${index < 10 ? '0' + index.toString() : index}',
                              style: TextStyle(
                                  fontSize: 50,
                                  color: _controllerHora.selectedItem != index
                                      ? const Color(0xff6D6D6D)
                                      : Colors.white),
                            )),
                          );
                        }),
                  ),
                ),
                const SizedBox(width: 35),
                Container(
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    onSelectedItemChanged: (value) => setState(() {
                      widget.adicionarNumero(value);
                    }),
                    controller: _controllerMinuto,
                    itemExtent: 65,
                    diameterRatio: 2,
                    perspective: 0.005,
                    physics: FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 60,
                        builder: (context, index) {
                          return Container(
                            child: Center(
                                child: Text(
                              '${index < 10 ? '0' + index.toString() : index}',
                              style: TextStyle(
                                  fontSize: 50,
                                  color: _controllerMinuto.selectedItem != index
                                      ? const Color(0xff6D6D6D)
                                      : Colors.white),
                            )),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
