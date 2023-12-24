$TITLE Antonio Sevilla Hoja 1 Problema 7
sets
T tipos de aceite /V1,V2,N1,N2,N3/
V(T) aceites vegetales /V1,V2/
N(T) aceites no vegetales /N1*N3/
M meses /1*6/ ;
table prec(T,M) precios de cada tipo de aceite T en el mes M (euros por litro)
               1          2         3         4          5            6
          V1  1.10       1.30      1.10      1.20       1.00         0.90
          V2  1.20       1.30      1.40      1.10       1.20         1.00
          N1  1.30       1.10      1.30      1.20       1.50         1.40
          N2  1.10       0.90      1.00      1.20       1.10         0.80
          N3  1.15       1.15      0.95      1.20       1.05         1.35;
parameter
dur(T) indice de dureza /V1 8.8,V2 16.1,N1 2.0,N2 4.2,N3 5.0/;
scalar
prev precio de venta aceite refinado (euros por litro) /1.5/
costal coste almacenamiento (euros por litro) /0.05/
limal limite de almacenamiento por aceite y mes (litros) /10000/;
variables
I(T,M) cantidad en el inventario de aceite T el mes M
X(T,M) cantidad comprada de aceite T el mes M
R(T,M) cantidad refinada de aceite T el mes M
obj valor de la funcion objetivo;
positive variables
I
X
R;
equations
fobj fijar valor de obj
fbalance(T,M) ecuacion de balance
finicial(T) cantidad de inventario inicial
ffinal(T) cantidad de inventario final
flimite(T,M) limite inventario
fvegetal(M) cantidad de refinado vegetal
fmanteca(M) cantidad de refinado no vegetal
fdurezamax(M) indice maximo de dureza aceptable
fdurezamin(M) indice minimo de dureza aceptable;
fobj.. obj =E= sum(M,sum(T, prev*R(T,M) - costal*I(T,M) - prec(T,M)*X(T,M)));
fbalance(T,M)$(ord(M)>1).. I(T,M) =E= I(T,M-1) + X(T,M) - R(T,M);
finicial(T).. 500 + X(T,"1") - R(T,"1") =E= I(T,"1");
ffinal(T).. 500 =E= I(T,"6");
flimite(T,M).. I(T,M) =L= 10000;
fvegetal(M).. R("V1",M)+R("V2",M) =L= 2000;
fmanteca(M).. R("N1",M)+R("N2",M)+R("N3",M) =L= 2500;
fdurezamax(M).. 3*sum(T, R(T,M)) =L= sum(T, R(T,M)*dur(T));
fdurezamin(M).. 6*sum(T, R(T,M)) =G= sum(T, R(T,M)*dur(T));
model aceite /all/;
solve aceite using LP maximizing obj;
