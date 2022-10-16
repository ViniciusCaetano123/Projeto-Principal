// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarme.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AlarmeStore on _AlarmeStore, Store {
  late final _$horaAtom = Atom(name: '_AlarmeStore.hora', context: context);

  @override
  int get hora {
    _$horaAtom.reportRead();
    return super.hora;
  }

  @override
  set hora(int value) {
    _$horaAtom.reportWrite(value, super.hora, () {
      super.hora = value;
    });
  }

  late final _$minutoAtom = Atom(name: '_AlarmeStore.minuto', context: context);

  @override
  int get minuto {
    _$minutoAtom.reportRead();
    return super.minuto;
  }

  @override
  set minuto(int value) {
    _$minutoAtom.reportWrite(value, super.minuto, () {
      super.minuto = value;
    });
  }

  late final _$_AlarmeStoreActionController =
      ActionController(name: '_AlarmeStore', context: context);

  @override
  void alterarHora(dynamic value) {
    final _$actionInfo = _$_AlarmeStoreActionController.startAction(
        name: '_AlarmeStore.alterarHora');
    try {
      return super.alterarHora(value);
    } finally {
      _$_AlarmeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarMinuto(dynamic value) {
    final _$actionInfo = _$_AlarmeStoreActionController.startAction(
        name: '_AlarmeStore.alterarMinuto');
    try {
      return super.alterarMinuto(value);
    } finally {
      _$_AlarmeStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hora: ${hora},
minuto: ${minuto}
    ''';
  }
}
