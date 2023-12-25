$TITLE **** Grupo 10 Coordinacion Hidrotermica ****
sets
t termicas /GAL, CAT, MAD, VAL, EXT-AND, CASTL/
g hidraulicos /Tajo, Duero, Sil/
h horas /1*4/
s escenarios /1*4/
alias (s,s2);
;
parameters
pmax(t) Potencia máxima de cada térmico [MW]
/GAL 400, CAT 500, MAD 700, VAL 400, EXT-AND 900, CASTL 800/
pmin(t) Potencia mínima de cada térmico [MW]
/GAL 100, CAT 150, MAD 150, VAL 50, EXT-AND 450, CASTL 200 /
rs(t) Rampa de subida [Mw por hora]
/GAL 200, CAT 300, MAD 500, VAL 300, EXT-AND 600, CASTL 400/
rb(t) Rampa de bajada [Mw por hora]
/GAL 300, CAT 300, MAD 200, VAL 100, EXT-AND 600, CASTL 400/
a(t) Término independiente [€]
/GAL 50, CAT 30, MAD 30, VAL 25, EXT-AND 80, CASTL 70/
b(t) Término lineal de producción (Coste unitario) [€ por MWh]
/GAL 4, CAT 5, MAD 4.2, VAL 4.5, EXT-AND 2, CASTL 3/
d(h) Demanda por horas [MW]
/1 2500 ,2 2800 ,3 3900 ,4 3000/
pmaxtur(g) potencia maxima [Mw] de la turbina del grupo hidraulico g
/Tajo 700,Duero 1500,Sil 600/
rmax(g) reserva maxima del grupo [Mw] hidraulico g
/Tajo 4180000,Duero  6790000,Sil  2600000/
rmin(g) reserva minima del [Mw] grupo hidraulico g
/Tajo 4179000,Duero  6789000,Sil  2598000/
RHI(g) reserva inicial [Mw] del grupo hidraulico g
/Tajo 4179000,Duero  6789000,Sil  2599000/
f(g) fluyente [Mw] del grupo hidraulico g
/Tajo 160,Duero  440,Sil  200/
TI(t) Término independiente [€]
/GAL 400, CAT 450, MAD 500, VAL 200, EXT-AND 600, CASTL 1000/
TL(t) Término lineal de producción [€ por MWh]
/GAL 0.25, CAT 0.2, MAD 0.2, VAL 0.01, EXT-AND 0.1, CASTL 0.2/
TC(t) Término cuadrático [€MWh2]
/ GAL 0.007, CAT 0.006, MAD 0.0045, VAL 0.009, EXT-AND 0.0015, CASTL 0.002/
ca(t) Coste de arranque [€]
/GAL 10, CAT 20, MAD 10, VAL 15, EXT-AND 20, CASTL 15/
cp(t) Coste de parada [€]
/GAL 5, CAT 10, MAD 5, VAL 10, EXT-AND 15, CASTL 10/
PROB(s) probabilidad cada escenario [p.u.] /1 0.36, 2 0.24, 3 0.24, 4 0.16/
;
table apor(h,g) aportacion hidraulica [Mwh] de cada rio
   Tajo Duero Sil
1  190  500   220
2  200  550   250
3  250  600   300
4  180  470   200
;
table DEMS(s,h) demanda estocástica [MW] para escenario y hora
    1     2     3     4
1   2500  2800  4290  3300
2   2500  2800  4290  2550
3   2500  2800  3315  3300
4   2500  2800  3315  2550
;
table P(s,h) probabilidad de cada escenario en cada hora
    1     2     3       4
1   1     1     0.6     0.36
2   1     1     0.6     0.24
3   1     1     0.4     0.24
4   1     1     0.4     0.16
;
table LUCI(s,h)
    1     2     3     4
1   1     1     1     1
2   1     1     1     2
3   1     1     3     3
4   1     1     3     4
;
variables
obj el valor [€] de la funcion objetivo
PT(t,h) produccion [MW] del grupo termico t la hora h
PH(g,h) produccion [MW] del grupo hidraulico g la hora h
Y1(t,h) esta acoplado el grupo termico t la hora h
RH(g,h) reserva [Mwh] del grupo g la hora h
casa(h) precio de casacion [€] la hora h
V(g,h) vertido [Mwh] del grupo g la hora h
Par(t,h) el grupo termico t para en la hora h
Arr(t,h) el grupo termico t arranca en la hora h

EPT(s,t,h) produccion [MW] del grupo termico t la hora h en el modelo estoc
EPH(s,g,h) produccion [MW] del grupo hidraulico g la hora h en el modelo estoc
EY1(s,t,h) esta acoplado el grupo termico t la hora h en el modelo estoc
ERH(s,g,h) reserva [Mwh] del grupo g la hora h en el modelo estoc
EV(s,g,h) vertido [Mwh] del grupo g la hora h en el modelo estoc
EPar(s,t,h) el grupo termico t para en la hora h en el modelo estoc
EArr(s,t,h) el grupo termico t arranca en la hora h en el modelo estoc
;
positive variables PT(t,h), PH(g,h), V(g,h),
EPT(s,t,h), EPH(s,g,h), EV(s,g,h)
;
binary variables Y1(t,h), Par(t,h), Arr(t,h),
EY1(s,t,h), EPar(s,t,h), EArr(s,t,h)
;
equations
fobj1 coste total modelo 1
fdem demanda
fpmax potencia maxima
fpmin potencia minima
fsubida rampa de subida
fbajada rampa de bajada
ffluyente fluyente
freservamax reserva maxima
freservamin reserva minima
fbalance restriccion de balance
frr reserva rodante
fobj2 coste total modelo 2
fcasa el precio de casacion es maximo
fobj3 coste total modelo 3
fencendido determina el encendido y apagado de los grupos
fobj4 coste total modelo 4
fc1 garantiza un modelo periodico en lo tocante a rampa de subida
fc2 garantiza un modelo periodico en lo tocante a rampaa de bajada
fc3 garantiza un modelo periodico en lo tocante a encendido

Efdem demanda
Efpmax potencia maxima
Efpmin potencia minima
Efsubida rampa de subida
Efbajada rampa de bajada
Effluyente fluyente
Efreservamax reserva maxima
Efreservamin reserva minima
Efbalance restriccion de balance
Efrr reserva rodanteo
Efobj4 coste total modelo 4
Efencendido determina el encendido y apagado de los grupos
EfbalanceI ecuacion de valance inicial
FDEM6 fijar la demanda a la estimada
;
fobj1.. obj =E= sum(h, sum(t, b(t)*PT(t,h)));
fdem(h).. d(h) =E= sum(t, PT(t,h)) + sum(g, PH(g,h));
fpmax(t,h).. PT(t,h) =L= pmax(t)*Y1(t,h);
fpmin(t,h)..  pmin(t)*Y1(t,h) =L= PT(t,h);
fsubida(t,h).. PT(t,h)-PT(t,h-1) =L= rs(t);
fbajada(t,h)..  PT(t,h-1)-PT(t,h) =L= rb(t);
ffluyente(g,h).. PH(g,h) + f(g) =L= pmaxtur(g);
freservamax(g,h).. RH(g,h) =L= rmax(g);
freservamin(g,h).. rmin(g) =L=  RH(g,h);
fbalance(g,h).. RH(g,h) =E= RH(g,h-1)$(ord(h)>1) + RHI(g)$(ord(h)=1)
- PH(g,h) + apor(h,g) - V(g,h);
frr(h).. sum(t, pmax(t)*Y1(t,h) - PT(t,h)) =G= 0.2*d(h);
fobj2.. obj =E= sum(h, d(h)*casa(h));
fcasa(t,h).. casa(h) =G= b(t)*Y1(t,h);
fobj3.. obj =E=sum(h, sum(t,TC(t)*PT(t,h)*PT(t,h) + TL(t)*PT(t,h)
+ TI(t)*Y1(t,h)) + sum(t, Arr(t,h)*ca(t) + Par(t,h)*cp(t)) );
fencendido(t,h).. Y1(t,h)-Y1(t,h-1) =E= Arr(t,h) - Par(t,h);
fobj4.. obj =E= sum(h, sum(t, b(t)*PT(t,h) + a(t)*Y1(t,h)
 + Arr(t,h)*ca(t) + Par(t,h)*cp(t)));
fc1(t,h).. PT(t,h)-PT(t,h--1) =L= rs(t);
fc2(t,h).. PT(t,h--1)-PT(t,h) =L= rb(t);
fc3(t,h).. Y1(t,h)-Y1(t,h--1) =E= Arr(t,h) - Par(t,h);
Efobj4.. obj =E= SUM((s,t,h)$(ord(s)=LUCI(s,h)), P(s,h)* (a(t)*EY1(s,t,h)
+ b(t)*EPT(s,t,h) + ca(t)*EArr(s,t,h) + cp(t)*Epar(s,t,h)));
Efdem(s,h)$(ord(s)=LUCI(s,h)).. DEMS(s,h) =E= sum(t, EPT(s,t,h))
+ sum(g, EPH(s,g,h));
Efpmax(s,t,h)$(ord(s)=LUCI(s,h)).. EPT(s,t,h) =L= pmax(t)*EY1(s,t,h);
Efpmin(s,t,h)$(ord(s)=LUCI(s,h)).. pmin(t)*EY1(s,t,h) =L= EPT(s,t,h);
Efsubida(s,t,h,s2)$(ord(s)=LUCI(s,h) and (ord(s2)=LUCI(s,h-1) or ord(h)=1))..
 EPT(s,t,h) - EPT(s2,t,h-1) =L= rs(t);
Efbajada(t,h,s,s2)$(ord(s)=LUCI(s,h) and (ord(s2)=LUCI(s,h-1) or ord(h)=1))..
 EPT(s2,t,h-1) - EPT(s,t,h) =L= rb(t);
Effluyente(s,g,h)$(ord(s)=LUCI(s,h)).. EPH(s,g,h) + f(g) =L= pmaxtur(g);
Efreservamax(s,g,h)$(ord(s)=LUCI(s,h)).. ERH(s,g,h) =L= rmax(g);
Efreservamin(s,g,h)$(ord(s)=LUCI(s,h)).. rmin(g) =L=  ERH(s,g,h);
Efbalance(s,g,h)$(ord(h)>1).. ERH(s,g,h) =E= sum(s2$(ord(s2)=LUCI(s,h-1)),
ERH(s2,g,h-1)) - EPH(s,g,h) +apor(h,g)-EV(s,g,h);
EfbalanceI(s,g,h)$(ord(h)=1).. ERH(s,g,h) =E= RHI(g) - EPH(s,g,h)
+ apor(h,g) - EV(s,g,h);
Efrr(s,h)$(ord(s)=LUCI(s,h))..
 sum(t, pmax(t)*EY1(s,t,h) - EPT(s,t,h)) =G=0.2*DEMS(s,h);
Efencendido(s,t,h,s2)$(ord(s)=LUCI(s,h) and(ord(s2)=LUCI(s,h-1) or ord(h)=1))..
EY1(s,t,h)-EY1(s2,t,h-1) =E= EArr(s,t,h) - EPar(s,t,h);
FDEM6(h).. d(h) =E= sum(s, PROB(s) * DEMS(s,h));
model modelo_1 /fobj1, fdem, fpmax, fpmin, fsubida, fbajada, ffluyente,
freservamax, freservamin, fbalance, frr/;
model modelo_2 /fobj2, fdem, fpmax, fpmin, fsubida, fbajada, ffluyente,
freservamax, freservamin, fbalance, frr, fcasa/;
model modelo_3 /fobj3, fdem, fpmax, fpmin, fsubida, fbajada, ffluyente,
freservamax, freservamin, fbalance, frr, fencendido/;
model modelo_4 /fobj4, fdem, fpmax, fpmin, fsubida, fbajada, ffluyente,
freservamax, freservamin, fbalance, frr, fencendido/;
model modelo_5 /fobj4, fdem, fpmax, fpmin, ffluyente,
 freservamax, freservamin, fbalance, frr, fencendido/;
solve modelo_1 using MIP minimizing obj;
solve modelo_2 using MIP minimizing obj;
option MIQCP = cplex;
solve modelo_3 using MIQCP minimizing obj;
solve modelo_4 using MIP minimizing obj;
solve modelo_5 using MIP minimizing obj;
MODEL MODELO_6_DETERM /fobj4, fdem, fpmax, fpmin, ffluyente, fbajada, fsubida,
 freservamax, freservamin, fbalance, frr, fencendido/;
*loop(s,
*d(h) = DEMS(s,h);
*solve MODELO_6_DETERM using MIP minimizing obj;)
*MODEL MODELO_6_ESTOC /Efobj4, Efdem, Efpmax, Efpmin, Effluyente, Efsubida,
*Efbajada, Efreservamax, Efreservamin, Efbalance, Efrr, Efencendido, EfbalanceI/;
*solve MODELO_6_ESTOC using MIP minimizing obj;
MODEL MODELO_6_ESTIM /fobj4, fdem, fpmax, fpmin, ffluyente,
 freservamax, freservamin, fbalance, frr, fencendido, FDEM6/;
solve MODELO_6_ESTIM using MIP minimizing obj;