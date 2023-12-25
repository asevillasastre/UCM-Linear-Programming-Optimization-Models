$Title Emergencia en Niger

File fichero_1  /C:\Pareto_1.txt/;
File fichero_2  /C:\Pareto_2.txt/;

Set
i centros /Tanout,Agadez,Zinder,Maradi/
j ciudades /In-Gall,Aderbissinat,Tessaoua,Dakoro,Tatokou,Bakatchiraba,
            Mayahi,Koundoumaoua,Sabon_Kafi/

k funciones objetivo /1*3/
;

Parameters
dem(j) demanda
    /In-Gall 156,Aderbissinat 81,Tessaoua 129,Dakoro 213,Tatokou 39,
     Bakatchiraba 30,Mayahi 273,Koundoumaoua 30,Sabon_Kafi 19/

dem_total Valor total de la demanda a satisfacer /970/

coste_fijo Coste por construir un centro /1000/

coste_u(i) Coste por unidad del centro i
    /Tanout 70,Agadez 50,Zinder 30,Maradi 90/

centro_max máximo número de centros que podemos abrir /3/

ton_total toneladas totales que tenemos para poder repartir /850/

presupuesto /40000/

lambda peso de cada función objetivo en las iteraciones del bucle

pasos número de segmentos que vamos a usar para estimar la frontera de Pareto /100/

c contador del bucle

cota_equidad


*para un vector de metas /1 203, 2 22720, 3 0.54/ con todos los objetivos 10% peores que lo deseado no existe solucion factible

metas(k) /1 203, 2 22720, 3 0.9/
;

Table dist(i,j) distancia de i a j
        In-Gall Aderbissinat Tessaoua Dakoro Tatokou Bakatchiraba Mayahi Koundoumaoua Sabon_Kafi
Tanout    396        147        191     244     43        8         252      197          43
Agadez    119        161        492     562    258       306        553      490         336
Zinder    541        286        114     300    188       152        156       71         102
Maradi    625        454        122     124    355       320         95      183         269
;

Table dist_optm(i,j) 1 si la distancia i j es menor de 200
         In-Gall Aderbissinat Tessaoua Dakoro Tatokou Bakatchiraba Mayahi Koundoumaoua Sabon_Kafi
Tanout      0         1           1       0      1          1         0         1           1
Agadez      1         1           0       0      0          0         0         0           0
Zinder      0         0           1       0      1          1         1         1           1
Maradi      0         0           1       1      0          0         1         1           0
;

Variables
Ton(i) Toneladas enviadas al centro i.
Y(i) variable binaria que indica si abrimos al centro i.
X(i,j) Población j recoge en el centro i.
Ayuda(i,j) Cantidad recogida por j en i.

Eq equidad.
coste_obj obj coste
dist_obj OBJ distancia
UD_obj obj demanda insatisfecha

P_1 frontera de pareto 1
P_2 frontera de pareto 2

meta
n(k)
p(k)
obj(k)
;

Positive variables Ton, Ayuda, n(k), p(k);
Binary variables X, Y;

Equations
F_insatisfecha función objetivo que minimiza la demanda no satisfecha.
F_coste función objetivo que minimiza el coste total.
F_distancia función objetivo que minimiza la distancia recorrida total.

coste_total El coste no puede superar el presupuesto.
lim_centros Límite de construcción de centros.
lim_dist(i,j) Límite de distancia para recoger ayuda
lim_ton Límite de toneladas transportadas al centro i.
lim_ayu(i) Límite de toneladas de ayuda que puede dar centro i.
lim_dem_sat Porcentaje límite de demanda satisfecha.
ayuda_pob(j) Límite de toneladas de ayuda que puede recibir una población.
max_ayuda(i,j) Limita a 0 la ayuda si no se cumplen las condiciones
construir(i,j)
construir2(i,j)
max_prop(j) Máxima proporción de demanda satisfecha.

restric_epsilon para el metodo de las epsilon-restricciones

pareto_1 frontera de Pareto 1
pareto_2

f_metas
f_ponderacion
fobj1
fobj2
fobj3
;

F_insatisfecha.. UD_obj =E= SUM(j, dem(j) - SUM(i, Ayuda(i,j)));
F_coste.. coste_obj =E= SUM(i, coste_fijo*Y(i))+ SUM(i, coste_u(i)*Ton(i));
F_distancia.. dist_obj =E= SUM((i,j), X(i,j)*dist(i,j));
coste_total.. SUM(i, coste_fijo*Y(i))+ SUM(i, coste_u(i)*Ton(i))=L= presupuesto;
lim_centros.. SUM(i, Y(i)) =L= 3;
lim_dist(i,j).. X(i,j)*dist(i,j) =L= 200;
lim_ton.. SUM(i, Ton(i)) =L= ton_total;
lim_ayu(i).. SUM(j,Ayuda(i,j)) =L= Ton(i);
lim_dem_sat.. SUM((i,j), Ayuda(i,j)) =G= 0.6*dem_total;
ayuda_pob(j).. SUM(i,Ayuda(i,j)) =L= dem(j);
max_ayuda(i,j).. Ayuda(i,j) =L= dem(j)*Y(i)*dist_optm(i,j);
construir(i,j).. X(i,j) =L= Y(i)*dist_optm(i,j);
construir2(i,j).. Ayuda(i,j) =L= dem(j)*X(i,j);
max_prop(j).. SUM(i,Ayuda(i,j)) =L= dem(j)*Eq;

restric_epsilon.. Eq =G= cota_equidad;

pareto_1.. P_1 =E= lambda*UD_obj/119 + (1-lambda)*Eq/0.6006;
pareto_2.. P_2 =E= lambda*Coste_obj/20720 + (1-lambda)*UD_obj/119;

f_metas(k).. obj(k) + n(k) - p(k) =E= metas(k);
f_ponderacion.. meta =E= sum(k, p(k)/metas(k));
fobj1..  obj("1") =E= UD_obj;
fobj2..  obj("2") =E= coste_obj;
fobj3..  obj("3") =E= Eq;


*MATRIZ DE PAGOS*
model Niger /F_insatisfecha, F_coste, F_distancia, coste_total, lim_centros, lim_dist,
               lim_ton, lim_ayu, lim_dem_sat, ayuda_pob, max_ayuda, construir, construir2, max_prop/;
*Solve Niger using MIP Minimizing UD_obj;
*Solve Niger using MIP Minimizing coste_obj;
*Solve Niger using MIP Minimizing Eq;
*Solve Niger using MIP Minimizing dist_obj;

*METODO DE LAS PONDERACIONES
* vs Equidad
*Model funcion_par_1 /pareto_1,F_insatisfecha, F_coste, F_distancia, coste_total, lim_centros, lim_dist,lim_ton, lim_ayu, lim_dem_sat, ayuda_pob, max_ayuda, construir, construir2, max_prop/;
*Put fichero_1;
*For(c = 1 to 99,
*    lambda=c/pasos
*    Solve funcion_par_1 using MIP Minimizing P_1
*    Put / eq.l UD_obj.l:<>:5 /);

* vs Coste
*Model funcion_par_2 /pareto_2,F_insatisfecha, F_coste, F_distancia, coste_total, lim_centros, lim_dist,lim_ton, lim_ayu, lim_dem_sat, ayuda_pob, max_ayuda, construir, construir2, max_prop/;
*Put fichero_2;
*For(c = 1 to 99,
*    lambda=c/pasos
*    Solve funcion_par_2 using MIP Minimizing P_2
*    Put / coste_obj.l UD_obj.l:<>:5 /);

*MÉTODO DE LAS EPSILON-RESTRICCIONES

* vs Equidad
*for
*(c = 0 to 1 by 0.1,
*cota_equidad = c;
*solve Niger using MIP minimizing UD_obj;)

*vs Coste
*for
*(c = 20720 to 40000 by 5000,
*presupuesto = c;
*solve Niger using MIP minimizing UD_obj;)

model Metas_ponder /F_insatisfecha, F_coste, F_distancia, coste_total, lim_centros, lim_dist,
               lim_ton, lim_ayu, lim_dem_sat, ayuda_pob, max_ayuda, construir, construir2, max_prop,
               f_metas, f_ponderacion, fobj1, fobj2, fobj3/;

solve Metas_ponder using MIP minimizing meta;



