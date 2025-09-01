package org.unp.plp.interprete;

class BinOpPor implements BinOp {
    public Expr eval(Expr left, Expr right) {
        return new Expr() {
            public int eval(int i, int j) {
                return left.eval(i,j) * right.eval(i,j);
            }
        };
    }
}


