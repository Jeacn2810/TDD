import 'package:flutter/material.dart';
import '/models/usuario.dart';
import '/models/vaso.dart';
import '/models/maquina_cafe.dart';
import '/models/azucarero.dart';

class PantallaPrincipal extends StatefulWidget {
  final Usuario usuario;

  PantallaPrincipal({required this.usuario});

  @override
  _PantallaPrincipalState createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  MaquinaCafe maquinaCafe = MaquinaCafe(
    10,
    Vaso('Pequeño', 20, 0),
    Vaso('Mediano', 15, 0),
    Vaso('Grande', 10, 0),
    Azucarero(20),
  );

  Vaso? vasoSeleccionado;

  int cantidadAzucarSeleccionada = 0;
  int cantidadCafeSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App de Máquina de Café'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Hola, ${widget.usuario.nombre}!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              Text('Selecciona el tamaño de vaso:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  botonVaso(maquinaCafe.vasoPequeno),
                  botonVaso(maquinaCafe.vasoMediano),
                  botonVaso(maquinaCafe.vasoGrande),
                ],
              ),
              SizedBox(height: 20),
              Text('Selecciona la cantidad de azúcar:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  botonAzucar(1),
                  botonAzucar(2),
                  botonAzucar(3),
                ],
              ),
              SizedBox(height: 20),
              Text('Selecciona la cantidad de café:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  botonCafe(1),
                  botonCafe(2),
                  botonCafe(3),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: prepararCafe,
                child: Text('Preparar Café'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget botonVaso(Vaso vaso) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (vasoSeleccionado == vaso) {
            vasoSeleccionado = null;
          } else {
            vasoSeleccionado = vaso;
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (vasoSeleccionado == vaso) {
            return Colors.blue.withOpacity(0.5);
          }
          return Colors.white;
        }),
      ),
      child:
          Text('Vaso ${vaso.tamano} - ${vaso.cantidadDisponible} disponibles'),
    );
  }

  Widget botonAzucar(int cantidad) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (cantidadAzucarSeleccionada == cantidad) {
            cantidadAzucarSeleccionada = 0;
          } else {
            cantidadAzucarSeleccionada = cantidad;
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (cantidadAzucarSeleccionada == cantidad) {
            return Colors.blue.withOpacity(0.5);
          }
          return Colors.white;
        }),
      ),
      child: Text('$cantidad Cucharadas de Azúcar'),
    );
  }

  Widget botonCafe(int cantidad) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (cantidadCafeSeleccionada == cantidad) {
            cantidadCafeSeleccionada = 0;
          } else {
            cantidadCafeSeleccionada = cantidad;
          }
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (cantidadCafeSeleccionada == cantidad) {
            return Colors.blue.withOpacity(0.5);
          }
          return Colors.white;
        }),
      ),
      child: Text('$cantidad Oz de Café'),
    );
  }

  void prepararCafe() {
    if (cantidadAzucarSeleccionada > maquinaCafe.azucarero.stockAzucar) {
      mostrarSnackBar('No hay suficiente azúcar disponible.');
      return;
    }

    if (cantidadCafeSeleccionada <= 0) {
      mostrarSnackBar('Selecciona la cantidad de café.');
      return;
    }

    if (vasoSeleccionado == null) {
      mostrarSnackBar('Selecciona un vaso.');
      return;
    }

    if (vasoSeleccionado!.contenido > 0) {
      mostrarSnackBar(
          'Ya hay un vaso seleccionado. Completa o descarta el vaso actual.');
      return;
    }

    if (vasoSeleccionado!.cantidadDisponible <= 0) {
      mostrarSnackBar('No hay vasos disponibles.');
      return;
    }

    if (maquinaCafe.stockCafe < cantidadCafeSeleccionada) {
      mostrarSnackBar(
          'No hay suficiente café disponible. Reabastece la máquina.');
      return;
    }

    setState(() {
      maquinaCafe.stockCafe -= cantidadCafeSeleccionada;
      maquinaCafe.azucarero.stockAzucar -= cantidadAzucarSeleccionada;

      vasoSeleccionado!.contenido = cantidadCafeSeleccionada;
      vasoSeleccionado!.cantidadDisponible--;
    });

    mostrarSnackBar('Café preparado con éxito. ¡Disfruta tu café!');
  }

  void mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
    ));
  }
}
