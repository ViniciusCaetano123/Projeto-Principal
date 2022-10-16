import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:path/path.dart';

class SemanasCard extends StatefulWidget {
  String titulo;
  int isSelect;
  SemanasCard(this.titulo, this.isSelect);

  @override
  State<SemanasCard> createState() => _SemanasCardState();
}

class _SemanasCardState extends State<SemanasCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Text(
        style: TextStyle(
            color:
                widget.isSelect == 1 ? const Color(0xffFF7527) : Colors.white),
        '${widget.titulo}',
      ),
    );
  }
}
