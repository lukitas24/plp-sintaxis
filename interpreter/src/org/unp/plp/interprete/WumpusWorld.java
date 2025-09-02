package org.unp.plp.interprete;

import java.util.ArrayList;
import java.util.List;

public class WumpusWorld {

	private int filas;
	private int columnas;
	private ELEMENTO[][] world;

	public static WumpusWorld crear(int filas, int columnas){
		System.out.println("Esto esta dentro de WumpusWorld " + filas + " " + columnas);

		return new WumpusWorld(filas, columnas);
	}

	public WumpusWorld(int filas, int columnas){
		this.filas = filas;
		this.columnas = columnas;
		this.world = new ELEMENTO[filas][columnas];
	}

	void agregarElemento(ELEMENTO elem, Celda celda){
        if(world[celda.i][celda.j]==elem){}
		world[celda.i][celda.j] = elem;
	}

	void removerElemento(ELEMENTO elem, Celda celda){
        if(world[celda.i][celda.j]==elem){
            world[celda.i][celda.j] = null;
            }
    	}


List<Celda> filtrarCeldas(String coord, String op, int valor) {
    List<Celda> resultado = new ArrayList<>();

    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < columnas; j++) {
            int comparar = coord.equals("i") ? i : j;
            boolean ok = switch(op) {
                case "="  -> comparar == valor;
                case "<"  -> comparar < valor;
                case ">"  -> comparar > valor;
                case "<=" -> comparar <= valor;
                case ">=" -> comparar >= valor;
                default   -> false;
            };

            if (ok) {
                Celda c = new Celda();
                c.i = i;
                c.j = j;
                resultado.add(c);
            }
        }
    }

    return resultado;
}

void imprimirMundoCSV() {
    // Encabezado: mundo
    System.out.println("world," + filas + "," + columnas);

    // Listado de elementos con coordenadas
    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < columnas; j++) {
            ELEMENTO elem = world[i][j];
            if (elem != null) {
                switch (elem) {
                    case HERO -> System.out.println("hero," + i + "," + j);
                    case GOLD -> System.out.println("gold," + i + "," + j);
                    case WUMPUS -> System.out.println("wumpus," + i + "," + j);
                    case PIT -> System.out.println("pit," + i + "," + j);
                }
            }
        }
    }
    imprimirMundoLindo();
}

void imprimirMundoLindo() {
    // Encabezado del mundo
    System.out.println("╔════════════════════════════╗");
    System.out.println("║   Wumpus World (" + filas + "x" + columnas + ")   ║");
    System.out.println("╚════════════════════════════╝");

    // Encabezados de columnas
    System.out.print("     ");
    for (int j = 0; j < columnas; j++) {
        System.out.printf(" %2d ", j);
    }
    System.out.println();

    // Separador
    System.out.print("    ");
    for (int j = 0; j < columnas; j++) {
        System.out.print("────");
    }
    System.out.println();

    // Filas con índices
    for (int i = 0; i < filas; i++) {
        System.out.printf("%2d │", i);
        for (int j = 0; j < columnas; j++) {
            ELEMENTO elem = world[i][j];
            String simbolo = " . ";

            if (elem != null) {
                switch (elem) {
                    case HERO -> simbolo = " H ";
                    case GOLD -> simbolo = " G ";
                    case WUMPUS -> simbolo = " W ";
                    case PIT -> simbolo = " P ";
                }
            }

            System.out.print(simbolo);
        }
        System.out.println();
    }

    System.out.println("=================================");
}


public int getFilas() { return filas; }
public int getColumnas() { return columnas; }

}


enum ELEMENTO { PIT, GOLD, WUMPUS, HERO}

class Celda {
	public int i;
	public int j;

     @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Celda)) return false;
        Celda other = (Celda) o;
        return this.i == other.i && this.j == other.j;
    }

    @Override
    public int hashCode() {
        return 31 * i + j;
    }

    @Override
    public String toString() {
        return "(" + i + "," + j + ")";
    }
}