import 'package:maquina_cafe_app/models/azucarero.dart';
import 'package:maquina_cafe_app/models/vaso.dart';

class MaquinaCafe {
  int stockCafe;
  Vaso vasoPequeno;
  Vaso vasoMediano;
  Vaso vasoGrande;
  Azucarero azucarero;

  MaquinaCafe(this.stockCafe, this.vasoPequeno, this.vasoMediano,
      this.vasoGrande, this.azucarero);
}
