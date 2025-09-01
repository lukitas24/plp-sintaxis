// fuente 'jflex' para interprete

package org.unp.plp.interprete;

%%

%class Lexer
%byaccj

%{

  private Parser yyparser;

  /** constructor del analizador sintáctico
  *** acepta como parámetro el lector de caracteres a usar
  **/

  public Lexer(java.io.Reader r, Parser p )
  {
    this(r);
    yyparser = p  ;
  }

  /** devuelve el numero de linea donde está el último caracter leido
  **/

  public int lineaActual()
  {
     return yyline;
  }

%}

%%

world
  {  
      return Parser.WORLD;
  }

x
  {
   return Parser.X; 
  }

put {return Parser.PUT;}
gold {return Parser.GOLD;}
hero {return Parser.HERO;}
wumpus {return Parser.WUMPUS;}
pit {return Parser.PIT;}
in {return Parser.IN;}
i {return Parser.I;}
j {return Parser.J;}
print {return Parser.PRINT;}

\(   { return Parser.PARENTESIS_ABRE; }
\)   { return Parser.PARENTESIS_CIERRA; }

\[  { return Parser.CORCHETE_ABRE; }
\]   { return Parser.CORCHETE_CIERRA; }

= {return Parser.IGUAL;}
\< {return Parser.MENOR;}
> {return Parser.MAYOR;}
>= {return Parser.MAYORI;}
\<= {return Parser.MENORI;}


[\-\+\/\*] {
    /** Deja pasar los caracteres únicos como literales **/
    /** No es ninguna expresión regular, sólo los caracteres literales **/
    yyparser.yylval = yytext();
    return yytext().charAt(0);
  }
,
{return Parser.COMA;}

[0-9]+
   {  yyparser.yylval = Integer.valueOf(yytext());
      return Parser.CONSTANT;
   }




\r|\n|\r\n
  { // lleva la cuenta de lineas
    yyline++ ;
    return Parser.NL;
  }

[ \t]+ {  /** accion vacia: se ignoran los espacios y tabuladores **/
       }

.      {  /** token desconocido: se produce un mensaje de error **/
          yyparser.yyerror("El lexema '"+yytext()+"' no corresponden a ningún token conocido");
       }
