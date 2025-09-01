package org.unp.plp.interprete;

class BinOpDiv implements BinOp {
    public Expr eval(Expr left, Expr right) {
        return new Expr() {
            public int eval(int i, int j) {
                int divisor = right.eval(i,j);
                if (divisor == 0) throw new ArithmeticException("División por cero en ("+i+","+j+")");
                return left.eval(i,j) / divisor;
            }
        };
    }
}
