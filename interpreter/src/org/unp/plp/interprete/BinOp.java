package org.unp.plp.interprete;

interface BinOp {
    Expr eval(Expr left, Expr right);
}
