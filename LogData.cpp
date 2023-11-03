
// Declaran las Librerias a utilizar
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <algorithm>
#include <map>

using namespace std;

struct datosEntrada {
    string mes;
    string dia;
    string hora;
    string direccionIp;
    string razon;
};

// Función que convierte los nombres de los meses en números para ordenar en orden cronológico
bool compararEntradas(const datosEntrada& entrada1, const datosEntrada& entrada2) {

    map<string, int> mesNumero = {
        {"Jan", 1},
        {"Feb", 2},
        {"Mar", 3},
        {"Apr", 4},
        {"May", 5},
        {"Jun", 6},
        {"Jul", 7},
        {"Aug", 8},
        {"Sep", 9},
        {"Oct", 10},
        {"Nov", 11},
        {"Dec", 12}
    };

    int mes1 = mesNumero[entrada1.mes];
    int mes2 = mesNumero[entrada2.mes];

    int dia1 = stoi(entrada1.dia);
    int dia2 = stoi(entrada2.dia);

    int hora1 = stoi(entrada1.hora);
    int hora2 = stoi(entrada2.hora);

    // Comparar primero por mes (en formato numérico), luego por día y finalmente por hora
    if (mes1 != mes2) {
        return mes1 < mes2;
    }
    if (dia1 != dia2) {
        return dia1 < dia2;
    }
    return hora1 < hora2;
}

int fechaNumerica(const datosEntrada& entrada) {
    // Convierte la fecha en formato "Mes Día" en un valor numérico (ejemplo: "Aug 1" -> 801)
    map<string, int> mesNumero = {
        {"Jan", 1}, {"Feb", 2}, {"Mar", 3}, {"Apr", 4}, {"May", 5}, {"Jun", 6},
        {"Jul", 7}, {"Aug", 8}, {"Sep", 9}, {"Oct", 10}, {"Nov", 11}, {"Dec", 12}
    };
    int mes = mesNumero[entrada.mes];
    int dia = stoi(entrada.dia);
    return mes * 100 + dia;
}

// Función para ordenar un vector de 'datosEntrada' usando Merge Sort
void mergeSort(vector<datosEntrada>& entradas, int inicio, int fin) {
    if (inicio < fin) {
        int mitad = (inicio + fin) / 2;
        mergeSort(entradas, inicio, mitad);
        mergeSort(entradas, mitad + 1, fin);

        // Combinar las dos partes ordenadas
        vector<datosEntrada> izquierda(entradas.begin() + inicio, entradas.begin() + mitad + 1);
        vector<datosEntrada> derecha(entradas.begin() + mitad + 1, entradas.begin() + fin + 1);

        int i = 0, j = 0, k = inicio;

        while (i < izquierda.size() && j < derecha.size()) {
            if (compararEntradas(izquierda[i], derecha[j])) {
                entradas[k++] = izquierda[i++];
            } else {
                entradas[k++] = derecha[j++];
            }
        }

        while (i < izquierda.size()) {
            entradas[k++] = izquierda[i++];
        }

        while (j < derecha.size()) {
            entradas[k++] = derecha[j++];
        }
    }
}

int main() {
  // Carga y lectura del archivo
    ifstream archivo("bitacora.txt");
    if (!archivo) {
      // En caso de no encontrar archivo se despliega el mensaje
        cerr << "No se pudo abrir el archivo." << endl;
        return 1;
    }
  // Se guardan los datos del archivo en un vector
    vector<datosEntrada> entradasDatos;
    string linea;

    while (getline(archivo, linea)) {
        istringstream iss(linea);
        datosEntrada entrada;
        iss >> entrada.mes >> entrada.dia >> entrada.hora >> entrada.direccionIp;
        getline(iss, entrada.razon);
        entradasDatos.push_back(entrada);
    }
  // Se cierra el archivo
    archivo.close();

  // Ordenar usando funcion Merge Sort
    mergeSort(entradasDatos, 0, entradasDatos.size() - 1);

  // Guardar los datos ordenados en un nuevo archivo
    ofstream archivoSalida("bitacora_ordenada.txt");
    for (const datosEntrada& entrada : entradasDatos) {
        archivoSalida  << entrada.direccionIp << " " << entrada.mes << " " << entrada.dia << " " << entrada.hora << " " << entrada.razon << endl;
    }
    archivoSalida.close();

    cout << "Datos ordenados y guardados en 'bitacora_ordenada.txt'." << endl;

  // Solicitar al usuario las fechas de inicio y fin de búsqueda
    string mesInicio, diaInicio, mesFin, diaFin;
    cout << "Ingrese fecha de inicio (Ej. Aug 1): ";
    cin >> mesInicio >> diaInicio;
    cout << "Ingrese fecha de fin (Ej. Sep 4): ";
    cin >> mesFin >> diaFin;

    int fechaInicio = fechaNumerica({mesInicio, diaInicio, "", "", ""});
    int fechaFin = fechaNumerica({mesFin, diaFin, "", "", ""});

  // Filtrar y mostrar los registros correspondientes a esas fechas
    cout << "Resultados de la busqueda entre " << mesInicio << " " << diaInicio << " y " << mesFin << " " << diaFin << ":" << endl;

    for (const datosEntrada& entrada : entradasDatos) {
        int fecha = fechaNumerica(entrada);

        if (fecha >= fechaInicio && fecha <= fechaFin) {
            cout << entrada.direccionIp << " " << entrada.mes << " " << entrada.dia << " " << entrada.hora << " " << entrada.razon << endl;
        }
    }

    return 0;
}



