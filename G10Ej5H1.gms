$TITLE **** Grupo 10 // Hoja 1 Problema 5 ****
sets
i meses /1*4/;
parameters
Dem(i) demanda de producto /1 400, 2 300, 3 300, 4 800/
Compra(i) coste de compra /1 1.7, 2 1.5, 3 1.8, 4 1.4/
h(i) coste de almacenamiento /1 0.05, 2 0.05, 3 0.05, 4 0.05/
Venta(i) coste de venta /1 2.3, 2 2.4, 3 2.5, 4 2.6/
CosteRotura(i) coste de rotura /1 0.1, 2 0.1, 3 0.1, 4 0.1/;
variables
x(i) uds compradas en el mes i
Inv(i) uds almacenadas el mes i
Rotura(i) uds no satisfechas el mes i
obj objetivo
obj2 objetivo del b;
positive variables
x
Inv
Rotura;
equations
fobj coste total
fbalance(i) ecuacion de balance
flimite(i) limite del almacen
ffinal inventario final
fobj2 coste total con rotura
fbalance2(i) ecuacion de balance con rotura
demanda satisfacer toda la demanda;
fobj.. obj =E= sum(i, Compra(i)*x(i) + h(i)*Inv(i));
fbalance(i).. Inv(i-1)+x(i)-Dem(i) =E= Inv(i);
flimite(i).. Inv(i) =L= 500;
ffinal.. Inv("4") =E= 100;
fobj2.. obj2 =E= sum(i, Compra(i)*x(i) + h(i)*Inv(i) + CosteRotura(i)*Rotura(i));
fbalance2(i).. Inv(i-1)+x(i)-Dem(i)-Rotura(i-1)+Rotura(i) =E= Inv(i);
demanda.. Rotura("4") =E= 0;
model almacen /fobj, fbalance, flimite, ffinal/;
solve almacen using mip minimizing obj;
model almacen2 /fobj2, fbalance2, flimite, ffinal, demanda/;
solve almacen2 using mip minimizing obj2;