%{
  import java.io.*;
  import java.util.List;
  import java.util.ArrayList;
%}


// lista de tokens por orden de prioridad

%token NL         // nueva línea
%token CONSTANT
%token WORLD   //mundo
%token X //equis
%token PUT
%token GOLD
%token HERO
%token IN
%token PARENTESIS_ABRE
%token PARENTESIS_CIERRA
%token COMA
%token WUMPUS
%token PIT
%token CORCHETE_ABRE
%token CORCHETE_CIERRA
%token I
%token J
%token IGUAL
%token MENOR
%token MAYOR
%token MAYORI
%token MENORI
%token PRINT



%%

program
  : world statement_list            // Lista de sentencias
  |                     // Programa vacio
  ;

statement_list
  : statement                // Unica sentencia
  | statement statement_list // Sentencia,y lista
  ;

statement
  : CONSTANT NL {System.out.println("constante: "+ (Integer)$1);}
  | ponerElemento NL
  | quitarElemento NL
  | imprimir NL
  ;

world
  : WORLD CONSTANT X CONSTANT NL {
        System.out.println("se creo el mundo " + (Integer)$2 + "x" + (Integer)$4);
        world = WumpusWorld.crear((int)(Integer)$2,(int)(Integer)$4);
    }
 ;

ponerElemento
  : PUT HERO IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.agregarElemento(ELEMENTO.HERO, c);
        System.out.println("Se puso HERO en (" + c.i + ", " + c.j + ")");
    }
  | PUT GOLD IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.agregarElemento(ELEMENTO.GOLD, c);
        System.out.println("Se puso GOLD en (" + c.i + ", " + c.j + ")");
    }
  | PUT WUMPUS IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.agregarElemento(ELEMENTO.WUMPUS, c);
        System.out.println("Se puso WUMPUS en (" + c.i + ", " + c.j + ")");
    }
  | PUT PIT IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.agregarElemento(ELEMENTO.PIT, c);
        System.out.println("Se puso PIT en (" + c.i + ", " + c.j + ")");
    }
  | PUT PIT IN CORCHETE_ABRE cond_list CORCHETE_CIERRA {
        List<Celda> celdas = (List<Celda>)$5;
        for (Celda c : celdas) {
            world.agregarElemento(ELEMENTO.PIT, c);
            System.out.println("Se puso PIT en (" + c.i + ", " + c.j + ")");
        }
    }
  ;

quitarElemento
    : REM HERO IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.removerElemento(ELEMENTO.HERO, c);
        System.out.println("Se quito HERO en (" + c.i + ", " + c.j + ")");
    }
  | REM GOLD IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.removerElemento(ELEMENTO.GOLD, c);
        System.out.println("Se quito GOLD en (" + c.i + ", " + c.j + ")");
    }
  | REM WUMPUS IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.removerElemento(ELEMENTO.WUMPUS, c);
        System.out.println("Se quito WUMPUS en (" + c.i + ", " + c.j + ")");
    }
  | REM PIT IN PARENTESIS_ABRE CONSTANT COMA CONSTANT PARENTESIS_CIERRA
    {
        Celda c = new Celda();
        c.i = (int)(Integer)$5;
        c.j = (int)(Integer)$7;
        world.removerElemento(ELEMENTO.PIT, c);
        System.out.println("Se quito PIT en (" + c.i + ", " + c.j + ")");
    }
  | REM PIT IN CORCHETE_ABRE cond_list CORCHETE_CIERRA {
        List<Celda> celdas = (List<Celda>)$5;
        for (Celda c : celdas) {
            world.removerElemento(ELEMENTO.PIT, c);
            System.out.println("Se quito PIT en (" + c.i + ", " + c.j + ")");
        }
    }
  ;



cond_list
  : cond COMA cond_list {
      List<Celda> a = (List<Celda>)$1;
      List<Celda> b = (List<Celda>)$3;
      List<Celda> inter = new ArrayList<>(a);
      inter.retainAll(b);
      $$ = inter;
    }
  | cond {
        $$ = (List<Celda>)$1;
    }
  ;


cond
  : expresion operador_aritmetico expresion {
        Expr left = (Expr)$1;
        String op = (String)$2;
        Expr right = (Expr)$3;
        List<Celda> res = new ArrayList<>();
        for (int i = 0; i < world.getFilas(); i++) {
            for (int j = 0; j < world.getColumnas(); j++) {
                int li = left.eval(i,j);
                int ri = right.eval(i,j);
                boolean ok = switch(op) {
                    case "="  -> li == ri;
                    case ">"  -> li > ri;
                    case "<"  -> li < ri;
                    case ">=" -> li >= ri;
                    case "<=" -> li <= ri;
                    default   -> false;
                };
                if (ok) {
                    Celda c = new Celda();
                    c.i = i; c.j = j;
                    res.add(c);
                }
            }
        }
        $$ = res;
    }
  ;


coord
  : I { $$ = "i"; }
  | J { $$ = "j"; }
  ;

operador_aritmetico
  : IGUAL  { $$ = "="; }
  | MAYOR  { $$ = ">"; }
  | MENOR  { $$ = "<"; }
  | MAYORI { $$ = ">="; }
  | MENORI { $$ = "<="; }
  ;


expresion
  : termino                          { $$ = $1; }
  | expresion operador_primario termino {
        $$ = ((BinOp)$2).eval((Expr)$1,(Expr)$3);
    }
  ;



termino
  : factor                          { $$ = $1; }
  | termino binOp factor            { $$ = ((BinOp)$2).eval((Expr)$1,(Expr)$3); }
  ;



factor
  : CONSTANT      { $$ = new ConstExpr((Integer)$1); }
  | I             { $$ = new CoordExpr("i"); }
  | J             { $$ = new CoordExpr("j"); }
  ;

binOp
 : '*' {$$ = new BinOpPor();}
 | '/' {$$ = new BinOpDiv();}
 ;

operador_primario
 : '+' { $$ = new BinOpSuma(); }
 | '-' { $$ = new BinOpResta(); }
 ;


 imprimir
 : PRINT WORLD {world.imprimirMundo();}
 ;



%%

// variables y código Java adicionales

private Lexer lexer;

private WumpusWorld world;

public Parser(java.io.Reader r)
{
    lexer = new Lexer(r, this);
}

private int yylex()
{
    int yyl_return = -1;

    try {
        yylval = new Object();
        yyl_return = lexer.yylex();
    }
    catch (java.io.IOException e) {
        System.err.println("error de E/S:" + e);
    }

    return yyl_return;
}

public void yyerror(String descripcion, int yystate, int token)
{
    System.err.println("Error en línea " + Integer.toString(lexer.lineaActual()) + " : " + descripcion);
    System.err.println("Token leído : " + yyname[token]);
}

public void yyerror(String descripcion)
{
    System.err.println("Error en línea " + Integer.toString(lexer.lineaActual()) + " : " + descripcion);
}

