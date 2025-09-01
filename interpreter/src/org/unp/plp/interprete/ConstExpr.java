package org.unp.plp.interprete;

class ConstExpr implements Expr {
    int valor;
    ConstExpr(int v) { valor = v; }
    public int eval(int i, int j) { return valor; }
}

