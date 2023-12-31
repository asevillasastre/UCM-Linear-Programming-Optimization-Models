$Title Níger - TECO 3

File matriz introducir la ruta de destino del archivo /C:\Matriz_pagos.txt/;
File archivo_1 introducir la ruta de destino del archivo /C:\Pareto_1.txt/;
File archivo_2 introducir la ruta de destino del archivo /C:\Pareto_2.txt/;
File archivo_3 introducir la ruta de destino del archivo /C:\Pareto_3.txt/;
Set
i centros /Tanout,Agadez,Zinder,Maradi/
j ciudades /In-Gall,Aderbissinat,Tessaoua,Dakoro,Tatokou,Bakatchiraba,Mayahi,Koundoumaoua,Sabon_Kafi/
columnas número de funciones objetivo para las que calculamos la frontera de pareto /1,2/
m funciones objetivo /1*4/
;

Parameters
dem(j) demanda
/In-Gall 156,Aderbissinat 81,Tessaoua 129,Dakoro 213,Tatokou 39,Bakatchiraba 30,Mayahi 273,Koundoumaoua 30,Sabon_Kafi 18/

dem_total valor total de la demanda a satisfacer /969/

Cud(i) coste por unidad del centro i
/Tanout 70,Agadez 50,Zinder 30,Maradi 90/

k coste fijo por el uso de un centro /1000/

centro_max máximo número de centros que podemos abrir /3/

T_total toneladas totales que tenemos para poder repartir /850/

Presupuesto /40000/

lambda peso de cada función objetivo en las iteraciones del bucle

delta(m) parámetro que activa o desactiva la función objetivo m-ésima

adv contador en el bucle que resuelve cada función objetivo individualmente

indice contador para la construcción de la matriz de pagos

count contador en los bucles que calculan la frontera de Pareto

sep número de segmentos que vamos a usar para estimar la frontera de Pareto /100/

metas(m) vector de metas que nos fijamos /1 119,2 35000,3 105000,4 0.53942/
;

Table dist(i,j) distancia de i a j
        In-Gall Aderbissinat Tessaoua Dakoro Tatokou Bakatchiraba Mayahi Koundoumaoua Sabon_Kafi
Tanout    396        147        191     244     43        8         252      197          43
Agadez    119        161        492     562    258       306        553      490         336
Zinder    541        286        114     300    188       152        156       71         102
Maradi    625        454        122     124    355       320         95      183         269
;

Table y(i,j) 1 si la distancia i j es menor de 200
         In-Gall Aderbissinat Tessaoua Dakoro Tatokou Bakatchiraba Mayahi Koundoumaoua Sabon_Kafi
Tanout      0         1           1       0      1          1         0         1           1
Agadez      1         1           0       0      0          0         0         0           0
Zinder      0         0           1       0      1          1         1         1           1
Maradi      0         0           1       1      0          0         1         1           0
;

Variables
T(i,j) Toneladas que van de i a j.
a(i) variable binaria que indica si abrimos al centro i.
z(m) Valor a optimizar en las distintas funciones objetivo
P_1 Variable necesaria para resolver la primera frontera de pareto
P_2 Variable necesaria para resolver la segunda frontera de pareto
P_3 Variable necesaria para resolver la tercera frontera de pareto
obj Variable auxiliar para la resolución de las funciones objetivo en un solo bucle
n(m)   Cuántos nos quedamos cortos en la función objetivo m-ésima
p(m)   Cuántos nos pasamos en la función objetivo m-ésima
meta   Valor que minimiza lo que nos pasamos en las metas ponderadas
;

Positive variable T(i,j), n(m), p(m);
Binary variables a(i);

Equations
pareto_1 buscamos la frontera de pareto enre la demanda no satisfecha y el reparto equitativo
pareto_2 buscamos la frontera de pareto enre la demanda no satisfecha y el coste
pareto_3 buscamos la frontera de pareto enre la demanda no satisfecha y la distancia recorrida
metas_ponderadas función que minimiza de forma ponderada lo que nos pasamos en las funciones objetivo.
insatisfecha función objetivo que minimiza la demanda no satisfecha.
coste función objetivo que minimiza el coste total.
distancia función objetivo que minimiza la distancia recorrida total.
equitativo función objetivo que busca un reparto mas equitativo.
toneladas máximo de toneladas disponibles.
demanda(j) no suministrar más toneladas de las demandadas.
apertura(i,j) no enviar suministros desde i si no se abre ese centro ni si está más lejos de 200 km.
maxcoste el coste total no puede superar el presupuesto.
maxapertura no se pueden abrir mas de 3 centros.
mindemanda se debe satisfacer un minimo de la demanda.
aux restricción que nos permite resolver cada función objetivo en un solo bucle
restr_metas(m) restricciones para el método de las metas ponderadas;

pareto_1.. P_1 =E= lambda*z('1')/119 + (1-lambda)*z('4')/0.53942;
pareto_2.. P_2 =E= lambda*z('1')/119 + (1-lambda)*z('2')/20690;
pareto_3.. P_3 =E= lambda*z('1')/119 + (1-lambda)*z('3')/57313.033;
metas_ponderadas.. meta =E= sum(m, p(m)/metas(m));
insatisfecha.. z('1') =E= dem_total - sum(j, sum(i, T(i,j)));
coste.. z('2') =E= k*sum(i, a(i)) + sum(j, sum(i, Cud(i)*T(i,j)));
distancia.. z('3') =E= sum(j, sum(i, dist(i,j)*T(i,j)));
equitativo.. z('4') =E= sum(j, (dem(j) - sum(i, T(i,j)))/dem(j));
toneladas.. sum(j, sum(i, T(i,j))) =L= T_total;
demanda(j).. sum(i, T(i,j)) =L= dem(j);
apertura(i,j).. T(i,j) =L= dem(j)*a(i)*y(i,j);
maxcoste.. k*sum(i, a(i)) + sum(j, sum(i, Cud(i)*T(i,j))) =L= Presupuesto;
maxapertura.. sum(i, a(i)) =L= centro_max;
mindemanda.. sum(j, sum(i, T(i,j))) =G= 0.6*dem_total;
aux.. obj =E= sum(m, delta(m)*z(m));
restr_metas(m).. z(m)+n(m)-p(m) =E= metas(m);



Model funcion_metas /metas_ponderadas,insatisfecha,coste,distancia,equitativo,
toneladas,demanda,apertura,maxcoste,maxapertura,mindemanda,restr_metas/;
Solve funcion_metas using MIP Minimizing meta;
