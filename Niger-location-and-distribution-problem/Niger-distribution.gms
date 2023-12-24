
$Title Níger segunda parte

Set
i ciudades origen /Niamey, Gaya, Dosso, Tahoua, Maradi, Tanout, Agadez, Zinder/
k tipos de camión /1, 2/;

Alias(i,j);
Alias(i,m);

Parameters
T_totales toneladas totales para trasladar a los centros /450/

Disp_Niamey toneladas de suministros disponibles en Niamey /800/

Disp_Gaya toneladas de suministros disponibles en Gaya /500/

Dem_Agadez toneladas demandadas en Agadez /237/

Dem_Zinder toneladas demandadas en Zinder /519/

Presupuesto presupuesto en euros disponible para una jornada /80000/

Cap(k) capacidad en toneladas del camión de tipo k
/1 1.5, 2 3/

C_fijo(k) coste fijo por mover el camión de tipo k vacío durante 100 km
/1 10, 2 15/

C_variable coste variable en euros por tonelada transportada por cada 100 km /2.5/;

Table Num_vehiculos(i,k) cantidad de vehículos del tipo k que hay en la ciudad i 
            1     2
Niamey     60    20
Gaya       55    40
Dosso      10    20
Tahoua      8    30
Maradi      5     5
Tanout      0     0
Agadez      0     0
Zinder      0     0
;

Table Dist(i,j) distancia de la ciudad i a la j
          Niamey  Gaya  Dosso  Tahoua  Maradi  Tanout  Agadez  Zinder
Niamey       0     286   138    564      0        0      0       0 
Gaya        286     0    151     0      626       0      0       0
Dosso       138    151    0     413     523       0      0       0
Tahoua      564     0    413     0      347      486    406      0
Maradi       0     626   523    347      0       313     0      235
Tanout       0      0     0     486     313       0     300     145
Agadez       0      0     0     406      0       300     0       0
Zinder       0      0     0      0      235      145     0       0
;

Table Camino(i,j) 1 si existe la carretera que une la ciudad i con la j y 0 si no
          Niamey  Gaya  Dosso  Tahoua  Maradi  Tanout  Agadez  Zinder
Niamey       0      1     1      1       0        0      0       0 
Gaya         1      0     1      0       1        0      0       0
Dosso        1      1     0      1       1        0      0       0
Tahoua       1      0     1      0       1        1      1       0
Maradi       0      1     1      1       0        1      0       1
Tanout       0      0     0      1       1        0      1       1
Agadez       0      0     0      1       0        1      0       0
Zinder       0      0     0      0       1        1      0       0
;

Variables
T(i,j) toneladas que transportan de la ciudad i a la j
Cam(i,j,k) número de camiones del tipo k que van de i a j
obj variable de la función objetivo que minimizaremos;

Positive variable T(i,j);
Integer variable Cam(i,j,k);

Equations
FObjetivo función objetivo que minimizaremos
Camino_Camiones(i,k) evita que salgan más camiones de los disponibles
Toda_Ayuda exige que se reparta toda la ayuda de la jornada
Llegada todas las toneladas llegan a Agadez y Zinder
Exceso_Agadez evita suministrar más recursos de los demandados en Agadez
Exceso_Zinder evita suministrar más recursos de los demandados en Zinder
Flujo(j) exige que todos los suministros vayan de una ciudad a otra sin detenerse
Capacidad_Camiones(i,j) las toneladas transportadas deben caber en los camiones
Existe_Camino(i,j,k) evita mandar camiones de i a j si no existe ese camino directo y en caso de haberlo que salgan una cantidad menor o igual de los que hay
Coste no permite pasarse del presupuesto máximo;


FObjetivo.. obj =E= sum(i, sum(j, (Dist(i,j)/100) * (C_variable*T(i,j) + sum(k, 2*C_fijo(k)*Cam(i,j,k)))));
Camino_Camiones(i,k).. sum(j,Cam(i,j,k)) =L= sum(j, Cam(j,i,k)) + Num_vehiculos(i,k);
Toda_Ayuda.. sum(j, T('Niamey',j) + T('Gaya',j) - T(j,'Niamey') - T(j,'Gaya')) =E= T_totales;
Llegada.. sum(i, T(i,'Agadez') + T(i,'Zinder') - T('Agadez',i) - T('Zinder', i)) =E= T_totales;
Exceso_Agadez.. sum(i, T(i,'Agadez') - T('Agadez',i)) =L= Dem_Agadez;
Exceso_Zinder.. sum(i, T(i,'Zinder') - T('Zinder',i)) =L= Dem_Zinder;
Flujo(j)$(ord(j)>2 and ord(j)<7).. sum(i, T(i,j)) =E= sum(i, T(j,i));
Capacidad_Camiones(i,j).. T(i,j) =L= sum(k, Cam(i,j,k) * Cap(k));
Existe_Camino(i,j,k).. Cam(i,j,k) =L= (Num_vehiculos(i,k) + sum(m, Cam(m,i,k))) * Camino(i,j);
Coste.. sum(i, sum(j, (Dist(i,j)/100) * (C_variable*T(i,j) + sum(k, 2*C_fijo(k)*Cam(i,j,k))))) =L= Presupuesto;


Model funcion /all/;
Solve funcion using MIP minimizing obj;
