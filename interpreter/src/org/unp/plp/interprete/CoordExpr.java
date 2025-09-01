package org.unp.plp.interprete;


class CoordExpr implements Expr {
    String coord; // "i" o "j"
    CoordExpr(String c) { coord = c; }
    public int eval(int i, int j) { return coord.equals("i") ? i : j; }
}