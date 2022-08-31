%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; 
clear all; 
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% IMPORTACIÓN DE LAS MUESTRAS DE AUDIO %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Normal_1, FsNormal_1] = audioread('5.1.1 - Muestra normal.m4a');
[Normal_2, FsNormal_2] = audioread('5.1.2 - Muestra normal.m4a');
[Normal_3, FsNormal_3] = audioread('5.2.1 - Muestra normal.m4a');
[Normal_4, FsNormal_4] = audioread('5.2.2 - Muestra normal.m4a');
[Normal_5, FsNormal_5] = audioread('5.3.1 - Muestra normal.m4a');
[Normal_6, FsNormal_6] = audioread('5.3.2 - Muestra normal.m4a');

[CercaLejos_1, FsCercaLejos_1] = audioread('3.1.1 - Cerca lejos.m4a');
[CercaLejos_2, FsCercaLejos_2] = audioread('3.1.2 - Cerca lejos.m4a');

[MedioCercaLejos_1, FsMedioCercaLejos_1] = audioread('3.2.1 - Medio cerca lejos.m4a');
[MedioCercaLejos_2, FsMedioCercaLejos_2] = audioread('3.2.2 - Medio cerca lejos.m4a');
[MedioCercaLejos_3, FsMedioCercaLejos_3] = audioread('3.2.3 - Medio cerca lejos.m4a');

[LejosCerca_1, FsLejosCerca_1] = audioread('3.3.1 - Lejos cerca.m4a');
[LejosCerca_2, FsLejosCerca_2] = audioread('3.3.2 - Lejos cerca.m4a');

[SilencioLargo_1, FsSilencioLargo_1] = audioread('6.1.1 - Silencio largo.mp4');
[SilencioLargo_2, FsSilencioLargo_2] = audioread('6.1.2 - Silencio largo.mp4');
[SilencioLargo_3, FsSilencioLargo_3] = audioread('6.1.3 - Silencio largo.mp4');

[Gritos_1, FsGritos_1] = audioread('8.1.1 - Gritos.m4a');
[Gritos_2, FsGritos_2] = audioread('8.1.2 - Gritos.m4a');

[SilenciosPuerta_1, FsSilenciosPuerta_1] = audioread('7.1.1 - Silencios y puerta.m4a');
[SilenciosPuerta_2, FsSilenciosPuerta_2] = audioread('7.1.2 - Silencios y puerta.m4a');
[SilenciosSilla_1, FsSilenciosSilla_1] = audioread('7.2.1 - Silencios y silla.m4a');
[SilenciosSilla_2, FsSilenciosSilla_2] = audioread('7.2.2 - Silencios y silla.m4a');

[SusurrosMusica_1, FsSusurrosMusica_1] = audioread('9.1.1 - Susurros y musica.m4a');
[SusurrosMusica_2, FsSusurrosMusica_2] = audioread('9.1.2 - Susurros y musica.m4a');
[SusurrosMesa_1, FsSusurrosMesa_1] = audioread('9.2.1 - Susurros y mesa.m4a');
[SusurrosMesa_2, FsSusurrosMesa_2] = audioread('9.2.2 - Susurros y mesa.m4a');

[Final, FsFinal] = audioread('12 - Final.m4a');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% RMSnormal Y LOUDNESSnormal %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta parte del código está destinada al cálculo del RMS promedio de la 
% voz a partir de 6 llamadas grabadas en condiciones normales, y de igual 
% forma, el cálculo del LOUDNESS.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Separación de las partes de la señal que contienen Voz de las que son RF.
VozNormal_1 = Voz(Normal_1);
VozNormal_2 = Voz(Normal_2);
VozNormal_3 = Voz(Normal_3);
VozNormal_4 = Voz(Normal_4);
VozNormal_5 = Voz(Normal_5);
VozNormal_6 = Voz(Normal_6);

% Para comprobar que se ha hecho bien el "filtrado" de las partes de la
% señal en las que hay Voz, de las que hay RF, se hacen unos plots.

% figure(1)
% plot(VozNormal_1)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Momentos de Voz de la señal Normal 1')

% figure(2)
% plot(VozNormal_2)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Momentos de Voz de la señal Normal 2')

% figure(3)
% plot(VozNormal_3)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Momentos de Voz de la señal Normal 3')

% figure(4)
% plot(VozNormal_4)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Momentos de Voz de la señal Normal 4')

% figure(5)
% plot(VozNormal_5)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Momentos de Voz de la señal Normal 5')

% figure(6)
% plot(VozNormal_6)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Momentos de Voz de la señal Normal 6')

% Cálculo del RMS de las partes de Voz de las Muestras Normales.
RMSVozNormal_1 = rms(VozNormal_1);
RMSVozNormal_2 = rms(VozNormal_2);
RMSVozNormal_3 = rms(VozNormal_3);
RMSVozNormal_4 = rms(VozNormal_4);
RMSVozNormal_5 = rms(VozNormal_5);
RMSVozNormal_6 = rms(VozNormal_6);

% Cálculo del promedio de los RMS de las partes de Voz de las Muestras
% Normales.
%
%                 Promedio = Sumatorio(Valores)/Nº de valores
%
SumaRMS = RMSVozNormal_1+RMSVozNormal_2+RMSVozNormal_3+RMSVozNormal_4+RMSVozNormal_5+RMSVozNormal_6;
RMSnormal = SumaRMS/6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% LOUDNESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cálculo del LOUDNESS de las partes de Voz de las Muestras Normales.
LOUDNESSVozNormalSenial_1 = LOUDNESS_NORMAL(VozNormal_1,FsNormal_1);
LOUDNESSVozNormalSenial_2 = LOUDNESS_NORMAL(VozNormal_2,FsNormal_2);
LOUDNESSVozNormalSenial_3 = LOUDNESS_NORMAL(VozNormal_3,FsNormal_3);
LOUDNESSVozNormalSenial_4 = LOUDNESS_NORMAL(VozNormal_4,FsNormal_4);
LOUDNESSVozNormalSenial_5 = LOUDNESS_NORMAL(VozNormal_5,FsNormal_5);
LOUDNESSVozNormalSenial_6 = LOUDNESS_NORMAL(VozNormal_6,FsNormal_6);

% Dado que de cada señal se han obtenido 11 ventanas en las que caldular el
% LOUDNESS, se hace el promedio de cada una de las ventanas de cada señal.
PromLOUDNESS_1 = sum(LOUDNESSVozNormalSenial_1,1)/11;
PromLOUDNESS_2 = sum(LOUDNESSVozNormalSenial_2,1)/11;
PromLOUDNESS_3 = sum(LOUDNESSVozNormalSenial_3,1)/11;
PromLOUDNESS_4 = sum(LOUDNESSVozNormalSenial_4,1)/11;
PromLOUDNESS_5 = sum(LOUDNESSVozNormalSenial_5,1)/11;
PromLOUDNESS_6 = sum(LOUDNESSVozNormalSenial_6,1)/11;

% Se realiza la suma de los promedios de las ventanas de las señales.
SumaLOUDNESS = PromLOUDNESS_1+PromLOUDNESS_2+PromLOUDNESS_3+PromLOUDNESS_4+PromLOUDNESS_5+PromLOUDNESS_6;

% Cálculo del promedio de los LOUDNESS de las partes de Voz de las Muestras
% Normales.
%
%                 Promedio = Sumatorio(Valores)/Nº de valores
%
LOUDNESSnormal = SumaLOUDNESS/6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% CONTROL DE GANANCIA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este algoritmo se va a aplicar a las muestras: 
% - Empiezan cerca del móvil y se aleja (CercaLejos_x)
% - Empiezan a una distancia media del móvil, se acerca y se aleja
% (MedioCercaLejos_x)
% - Empieza lejos y se acerca (LejosCerca_x)
% - Señales con silencios largos (SilencioLargo_x)

%%%%%%%%%%%%%%%%%%%%%%%%% BASADO EN EL RMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El control de ganancia hace que la señal de la voz se encuentre dentro
% de unos límites. En este caso estos límites vendrán marcados por un RMS 
% "normal" de unas muestras grabadas en condiciones normales (sin RF ni 
% cambios de nivel, etc), a una distancia de unos 60cm (móvil-boca). Este 
% RMSnormal será el promedio de los RMS de las partes de Voz de las 
% Muestras Normales.
%
% Una vez que se ha calculado este RMSnormal, que marcará el límite, será
% necesario aplicar a la llamada una ventana deslizante, la cual cada 1s se
% desplazará 700ms, es decir, se producirá un solape entre ventanas de 
% 300ms,y aplicará la ganancia necesaria a la siguiente ventana.
%
% Para el cálculo de la ganancia se calcula el RMS de la ventana en la que
% se está analizando (RMSventana) y este valor se divide entre el
% RMSnormal:
%
%                     Ganancia = RMSventana/RMSnormal
% 
% Para saber si esta ganancia tiene que multiplicar, porque hay que
% aumentar el novel; o si tiene que dividir, porque hay que disminuir el 
% nivel; hay que comprobar si RMSventana es mayor o menor que RMSnormal. 
% Si es mayor, habrá que hacer:
%
%                      RMSventana/Ganancia
%
% si es menor, habrá que hacer:
%
%                      RMSventana*Ganancia
%

% Aplicación del algoritmo de Control de Ganancia basado en RMS.
CercaLejos_1_CG_RMS = CG_RMS(CercaLejos_1, FsCercaLejos_1, RMSnormal);
CercaLejos_2_CG_RMS = CG_RMS(CercaLejos_1, FsCercaLejos_2, RMSnormal);

MedioCercaLejos_1_CG_RMS = CG_RMS(MedioCercaLejos_1, FsMedioCercaLejos_1, RMSnormal);
MedioCercaLejos_2_CG_RMS = CG_RMS(MedioCercaLejos_2, FsMedioCercaLejos_2, RMSnormal);
MedioCercaLejos_3_CG_RMS = CG_RMS(MedioCercaLejos_3, FsMedioCercaLejos_3, RMSnormal);

LejosCerca_1_CG_RMS = CG_RMS(LejosCerca_1, FsLejosCerca_1, RMSnormal);
LejosCerca_2_CG_RMS = CG_RMS(LejosCerca_1, FsLejosCerca_2, RMSnormal);

SilencioLargo_1_CG_RMS = CG_RMS(SilencioLargo_1, FsSilencioLargo_1, RMSnormal);
SilencioLargo_2_CG_RMS = CG_RMS(SilencioLargo_2, FsSilencioLargo_2, RMSnormal);
SilencioLargo_3_CG_RMS = CG_RMS(SilencioLargo_3, FsSilencioLargo_3, RMSnormal);

% Prueba de escucha.
% ap = audioplayer(MedioCercaLejos_2_CG_RMS, FsSilencioLargo_1);
% playblocking(ap);

% Plots de las señales con el CG basado en RMS aplicado.
% figure(7)
% plot(CercaLejos_1_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Cerca Lejos 1 con CG RMS')
% 
% figure(8)
% plot(CercaLejos_2_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Cerca Lejos 2 con CG RMS')
% 
% figure(9)
% plot(MedioCercaLejos_1_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Medio Cerca Lejos 1 con CG RMS')
% 
% figure(10)
% plot(MedioCercaLejos_2_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Medio Cerca Lejos 2 con CG RMS')
% 
% figure(11)
% plot(MedioCercaLejos_3_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Medio Cerca Lejos 3 con CG RMS')
% 
% figure(12)
% plot(LejosCerca_1_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Lejos Cerca 1 con CG RMS')
% 
% figure(13)
% plot(LejosCerca_2_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Lejos Cerca 2 con CG RMS')
% 
% figure(14)
% plot(SilencioLargo_1_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 1 con CG RMS')
% 
% figure(15)
% plot(SilencioLargo_2_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 2 con CG RMS')
% 
% figure(16)
% plot(SilencioLargo_3_CG_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 3 con CG RMS')

% Exportación de las señales de audio.
% audiowrite('CercaLejos_1_CG_RMS.wav',CercaLejos_1_CG_RMS,FsCercaLejos_1);
% audiowrite('CercaLejos_2_CG_RMS.wav',CercaLejos_2_CG_RMS,FsCercaLejos_2);
% 
% audiowrite('MedioCercaLejos_1_CG_RMS.wav',MedioCercaLejos_1_CG_RMS,FsMedioCercaLejos_1);
% audiowrite('MedioCercaLejos_2_CG_RMS.wav',MedioCercaLejos_2_CG_RMS,FsMedioCercaLejos_2);
% audiowrite('MedioCercaLejos_3_CG_RMS.wav',MedioCercaLejos_3_CG_RMS,FsMedioCercaLejos_3);
% 
% audiowrite('LejosCerca_1_CG_RMS.wav',LejosCerca_1_CG_RMS,FsLejosCerca_1);
% audiowrite('LejosCerca_2_CG_RMS.wav',LejosCerca_2_CG_RMS,FsLejosCerca_2);
% 
% audiowrite('SilencioLargo_1_CG_RMS.wav',SilencioLargo_1_CG_RMS,FsSilencioLargo_1);
% audiowrite('SilencioLargo_2_CG_RMS.wav',SilencioLargo_2_CG_RMS,FsSilencioLargo_2);
% audiowrite('SilencioLargo_3_CG_RMS.wav',SilencioLargo_3_CG_RMS,FsSilencioLargo_3);

%%%%%%%%%%%%%%%%%%%%%%% BASADO EN EL LOUDNESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El planteamiento es el mismo que el CG basado en RMS, pero en vez de usar
% RMSnormal, se usará LOUDNESSnormal, y las ganancias se aplicarán de la
% misma forma pero comparando valores de LOUDNESSventana.

% Aplicación del algoritmo de Control de Ganancia basado en LOUDNESS.
CercaLejos_1_CG_LOUDNESS = CG_LOUDNESS(CercaLejos_1, FsCercaLejos_1, LOUDNESSnormal);
CercaLejos_2_CG_LOUDNESS = CG_LOUDNESS(CercaLejos_1, FsCercaLejos_2, LOUDNESSnormal);

MedioCercaLejos_1_CG_LOUDNESS = CG_LOUDNESS(MedioCercaLejos_1, FsMedioCercaLejos_1, LOUDNESSnormal);
MedioCercaLejos_2_CG_LOUDNESS = CG_LOUDNESS(MedioCercaLejos_2, FsMedioCercaLejos_2, LOUDNESSnormal);
MedioCercaLejos_3_CG_LOUDNESS = CG_LOUDNESS(MedioCercaLejos_3, FsMedioCercaLejos_3, LOUDNESSnormal);

LejosCerca_1_CG_LOUDNESS = CG_LOUDNESS(LejosCerca_1, FsLejosCerca_1, LOUDNESSnormal);
LejosCerca_2_CG_LOUDNESS = CG_LOUDNESS(LejosCerca_1, FsLejosCerca_2, LOUDNESSnormal);

SilencioLargo_1_CG_LOUDNESS = CG_RMS(SilencioLargo_1, FsSilencioLargo_1, RMSnormal);
SilencioLargo_2_CG_LOUDNESS = CG_RMS(SilencioLargo_2, FsSilencioLargo_2, RMSnormal);
SilencioLargo_3_CG_LOUDNESS = CG_RMS(SilencioLargo_3, FsSilencioLargo_3, RMSnormal);

% Prueba de escucha.
% ap = audioplayer(CercaLejos_1_CG_LOUDNESS, FsCercaLejos_1);
% playblocking(ap);

% Plots de las señales con el CG basado en LOUDNESS aplicado.
% figure(8)
% plot(CercaLejos_1_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Cerca Lejos 1 con CG LOUDNESS')
% 
% figure(9)
% plot(CercaLejos_2_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Cerca Lejos 2 con CG LOUDNESS')
% 
% figure(10)
% plot(MedioCercaLejos_1_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Medio Cerca Lejos 1 con CG LOUDNESS')
% 
% figure(11)
% plot(MedioCercaLejos_2_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Medio Cerca Lejos 2 con CG LOUDNESS')
% 
% figure(12)
% plot(MedioCercaLejos_3_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Medio Cerca Lejos 3 con CG LOUDNESS')
% 
% figure(13)
% plot(LejosCerca_1_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Lejos Cerca 1 con CG LOUDNESS')
% 
% figure(14)
% plot(LejosCerca_2_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Lejos Cerca 2 con CG LOUDNESS')
% 
% figure(15)
% plot(SilencioLargo_1_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 1 con CG LOUDNESS')
% 
% figure(16)
% plot(SilencioLargo_2_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 2 con CG LOUDNESS')
% 
% figure(17)
% plot(SilencioLargo_3_CG_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 3 con CG LOUDNESS')

% Exportación de las señales de audio.
% audiowrite('CercaLejos_1_CG_LOUDNESS.wav',CercaLejos_1_CG_LOUDNESS,FsCercaLejos_1);
% audiowrite('CercaLejos_2_CG_LOUDNESS.wav',CercaLejos_2_CG_LOUDNESS,FsCercaLejos_2);
% 
% audiowrite('MedioCercaLejos_1_CG_LOUDNESS.wav',MedioCercaLejos_1_CG_LOUDNESS,FsMedioCercaLejos_1);
% audiowrite('MedioCercaLejos_2_CG_LOUDNESS.wav',MedioCercaLejos_2_CG_LOUDNESS,FsMedioCercaLejos_2);
% audiowrite('MedioCercaLejos_3_CG_LOUDNESS.wav',MedioCercaLejos_3_CG_LOUDNESS,FsMedioCercaLejos_3);
% 
% audiowrite('LejosCerca_1_CG_LOUDNESS.wav',LejosCerca_1_CG_LOUDNESS,FsLejosCerca_1);
% audiowrite('LejosCerca_2_CG_LOUDNESS.wav',LejosCerca_2_CG_LOUDNESS,FsLejosCerca_2);
% 
% audiowrite('SilencioLargo_1_CG_LOUDNESS.wav',SilencioLargo_1_CG_LOUDNESS,FsSilencioLargo_1);
% audiowrite('SilencioLargo_2_CG_LOUDNESS.wav',SilencioLargo_2_CG_LOUDNESS,FsSilencioLargo_2);
% audiowrite('SilencioLargo_3_CG_LOUDNESS.wav',SilencioLargo_3_CG_LOUDNESS,FsSilencioLargo_3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% PUERTA DE RUIDO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este algoritmo se va a aplicar a las muestras: 
% - Señales con largos periodos de silencio (SilencioLargo_x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASADA EN RMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Una puerta de Ruido hace que se cierre o se reduzca sustancialmente el
% nivel de ruido en un determinado umbral. En este caso, se va a usar para
% "cerrar" esta puerta cuando el interlocutor no esté hablando, para
% conseguir que en estos momentos de silencio no se cuelen ruidos
% indeseados.

% Aplicación del algoritmo de Puerta de Ruido basada en RMS.
SilencioLargo_1_PR_RMS = PR_RMS(SilencioLargo_1, FsSilencioLargo_1, RMSnormal);
SilencioLargo_2_PR_RMS = PR_RMS(SilencioLargo_2, FsSilencioLargo_2, RMSnormal);
SilencioLargo_3_PR_RMS = PR_RMS(SilencioLargo_3, FsSilencioLargo_3, RMSnormal);

% Prueba de escucha.
% ap = audioplayer(SilencioLargo_1_PR_RMS, FsSilencioLargo_1);
% playblocking(ap);

% Prueba de plots.
% figure(18)
% plot(SilencioLargo_1_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 1 con PR RMS')
% 
% figure(19)
% plot(SilencioLargo_2_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 2 con PR RMS')
% 
% figure(20)
% plot(SilencioLargo_3_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 3 con PR RMS')

% Exportación de las señales de audio.
% audiowrite('SilencioLargo_1_PR_RMS.wav',SilencioLargo_1_PR_RMS,FsSilencioLargo_1);
% audiowrite('SilencioLargo_2_PR_RMS.wav',SilencioLargo_2_PR_RMS,FsSilencioLargo_2);
% audiowrite('SilencioLargo_3_PR_RMS.wav',SilencioLargo_1_PR_RMS,FsSilencioLargo_3);

%%%%%%%%%%%%%%%%%%%%%%%%%% BASADA EN LOUDNESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% La idea de funcionamiento es la misma que en PR_RMS, pero en vez de
% comparar valores de RMSnomarl con RMSventana, se compararán valores de
% LOUDNESSnormal con LOUDNESSventana.

% Aplicación del algoritmo de la Puerta de Ruido basado en LOUDNESS.
SilencioLargo_1_PR_LOUDNESS = PR_LOUDNESS(SilencioLargo_1, FsSilencioLargo_1, LOUDNESSnormal);
SilencioLargo_2_PR_LOUDNESS = PR_LOUDNESS(SilencioLargo_2, FsSilencioLargo_2, LOUDNESSnormal);
SilencioLargo_3_PR_LOUDNESS = PR_LOUDNESS(SilencioLargo_3, FsSilencioLargo_3, LOUDNESSnormal);

% Prueba de escucha.
% ap = audioplayer(SilencioLargo_2_PR_LOUDNESS, FsSilencioLargo_2);
% playblocking(ap);

% Prueba de plot.
% figure(21)
% plot(SilencioLargo_1_PR_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 1 con PR LOUDNESS')
% 
% figure(22)
% plot(SilencioLargo_2_PR_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 2 con PR LOUDNESS')
% 
% figure(23)
% plot(SilencioLargo_3_PR_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 3 con PR LOUDNESS')

% Exportación de las señales de audio.
% audiowrite('SilencioLargo_1_PR_LOUDNESS.wav',SilencioLargo_1_PR_LOUDNESS,FsSilencioLargo_1);
% audiowrite('SilencioLargo_2_PR_LOUDNESS.wav',SilencioLargo_2_PR_LOUDNESS,FsSilencioLargo_2);
% audiowrite('SilencioLargo_3_PR_LOUDNESS.wav',SilencioLargo_1_PR_LOUDNESS,FsSilencioLargo_3);

%%%%%%%%%%%%%%%%%%%%%%% EXPANSORA BASADA EN RMS %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este tipo de Puerta de Ruido aplica la misma filosofía que una Puerta
% de Ruido convencional cambiando la forma en la que se decrementan los
% niveles que se encuentran por debajo del Umbral. 
% En este caso los niveles decrementarán su valor según la siguiente
% fórmula:
%
%                        Ls = Le*Re-Te*(Re-1)
%
% Siendo Le el los valores de las muestras pertenecientes a la ventana que
% se está analizando en ese momento; Te el Umbral de expansión, que en este
% caso será igual al Umbral de detección de activación de la Puerta de 
% Ruido; y Re, la relación de expansión.

% Aplicación del algoritmo de Puerta de Ruido Expansora basada en RMS.
SilencioLargo_1_PR_EXP_RMS = PR_EXP_RMS(SilencioLargo_1, FsSilencioLargo_1, RMSnormal);
SilencioLargo_2_PR_EXP_RMS = PR_EXP_RMS(SilencioLargo_2, FsSilencioLargo_2, RMSnormal);
SilencioLargo_3_PR_EXP_RMS = PR_EXP_RMS(SilencioLargo_3, FsSilencioLargo_3, RMSnormal);

% Prueba de escucha.
% ap = audioplayer(SilencioLargo_1_PR_EXP_RMS, FsSilencioLargo_1);
% playblocking(ap);

% Prueba de plot.
% figure(24)
% plot(SilencioLargo_1_PR_EXP_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 1 con PR EXP RMS')
% 
% figure(25)
% plot(SilencioLargo_2_PR_EXP_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 2 con PR EXP RMS')
% 
% figure(26)
% plot(SilencioLargo_3_PR_EXP_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 3 con PR EXP RMS')

% Exportación de las señales de audio.
% audiowrite('SilencioLargo_1_PR_EXP_RMS.wav',SilencioLargo_1_PR_EXP_RMS,FsSilencioLargo_1);
% audiowrite('SilencioLargo_2_PR_EXP_RMS.wav',SilencioLargo_2_PR_EXP_RMS,FsSilencioLargo_2);
% audiowrite('SilencioLargo_3_PR_EXP_RMS.wav',SilencioLargo_1_PR_EXP_RMS,FsSilencioLargo_3);

%%%%%%%%%%%%%%%%%%%% EXPANSORA BASADA EN LOUDNESS %%%%%%%%%%%%%%%%%%%%%%%%%

% Este tipo de Puerta de Ruido aplica la misma filosofía que una Puerta
% de Ruido expansora basada en RMS, pero usando como Umbral la comparación 
% del LOUDNESSnormal con el LOUDNESSventana.

% Aplicación del algoritmo de Puerta de Ruido Expansora basada en LOUDNESS.
SilencioLargo_1_PR_EXP_LOUDNESS = PR_EXP_LOUDNESS(SilencioLargo_1, FsSilencioLargo_1, LOUDNESSnormal);
SilencioLargo_2_PR_EXP_LOUDNESS = PR_EXP_LOUDNESS(SilencioLargo_2, FsSilencioLargo_2, LOUDNESSnormal);
SilencioLargo_3_PR_EXP_LOUDNESS = PR_EXP_LOUDNESS(SilencioLargo_3, FsSilencioLargo_3, LOUDNESSnormal);

% Prueba de escucha.
% ap = audioplayer(SilencioLargo_3_PR_EXP_LOUDNESS, FsSilencioLargo_3);
% playblocking(ap);

% Prueba de plot.
% figure(27)
% plot(SilencioLargo_1_PR_EXP_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 1 con PR EXP LOUDNESS')
% 
% figure(28)
% plot(SilencioLargo_2_PR_EXP_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 2 con PR EXP LOUDNESS')
% 
% figure(29)
% plot(SilencioLargo_3_PR_EXP_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Silencios Largos 3 con PR EXP LOUDNESS')

% Exportación de las señales de audio.
% audiowrite('SilencioLargo_1_PR_EXP_LOUDNESS.wav',SilencioLargo_1_PR_EXP_LOUDNESS,FsSilencioLargo_1);
% audiowrite('SilencioLargo_2_PR_EXP_LOUDNESS.wav',SilencioLargo_2_PR_EXP_LOUDNESS,FsSilencioLargo_2);
% audiowrite('SilencioLargo_3_PR_EXP_LOUDNESS.wav',SilencioLargo_1_PR_EXP_LOUDNESS,FsSilencioLargo_3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% COMPRESOR LIMITADOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este algoritmo se va a aplicar a las siguientes muestras:
% - Señales con niveles muy muy altos, como pueden ser gritos (Gritos_x).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASADO EN RMS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Un Compresor Limitador hace que a partir de un cierto Umbral (por encima
% de él), se aplique una limitación de los niveles de la señal. Esta
% limitación se realiza a través de la multiplicación por una Ganancia
% positiva, pero de valor menor que 0.

% Aplicación del algoritmo del Compresor Limitador basado en RMS.
Gritos_1_CL_RMS = CL_RMS(Gritos_1, FsGritos_1, RMSnormal);
Gritos_2_CL_RMS = CL_RMS(Gritos_2, FsGritos_2, RMSnormal);

% Prueba de escucha.
% ap = audioplayer(Gritos_1_CL_RMS, FsGritos_1);
% playblocking(ap);

% Prueba de plot.
% figure(30)
% plot(Gritos_1_CL_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Gritos 1 con CL RMS')
% 
% figure(31)
% plot(Gritos_2_CL_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Gritos 2 con CL en RMS')

% Exportación de las señales de audio.
% audiowrite('Gritos_1_CL_RMS.wav',Gritos_1_CL_RMS,FsGritos_1);
% audiowrite('Gritos_2_CL_RMS.wav',Gritos_2_CL_RMS,FsGritos_2);

%%%%%%%%%%%%%%%%%%%%%%%%%% BASADO EN LOUDNESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% El planteamiento es el mismo que el CL basado en RMS, pero en vez de usar
% RMSnormal, se usará LOUDNESSnormal, y la ganancia se aplicará de la
% misma forma pero comparando valores de LOUDNESSventana.

% Aplicación del algoritmo del Compresor Limitador basado en RMS.
Gritos_1_CL_LOUDNESS = CL_LOUDNESS(Gritos_1, FsGritos_1, LOUDNESSnormal);
Gritos_2_CL_LOUDNESS = CL_LOUDNESS(Gritos_2, FsGritos_2, LOUDNESSnormal);

% Prueba de escucha.
% ap = audioplayer(Gritos_1_CL_LOUDNESS, FsGritos_1);
% playblocking(ap);

% Prueba de plot.
% figure(32)
% plot(Gritos_1_CL_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Gritos 1 con CL LOUDNESS')
% 
% figure(33)
% plot(Gritos_2_CL_LOUDNESS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Gritos 2 con CL LOUDNESS')

% Exportación de las señales de audio.
% audiowrite('Gritos_1_CL_LOUDNESS.wav',Gritos_1_CL_LOUDNESS,FsGritos_1);
% audiowrite('Gritos_2_CL_LOUDNESS.wav',Gritos_2_CL_LOUDNESS,FsGritos_2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% VOICE ACTIVITY DETECTION %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este algoritmo se va a aplicar a las muestras que, en los periodos en los
% que no hay voz, se escuchan ruido indeseados:
% - Ruidos de alguien tocando a una puerta (SilenciosPuerta_X)
% - Ruidos de alguien moviendo una silla (SilenciosSilla_X)

%%%%%%%%%%%%%%%%%%%%% VAD UN UMBRAL, VALORES FIJOS %%%%%%%%%%%%%%%%%%%%%%%%

% Este algoritmo permitirá saber si en un cierto momento, hay voz o no. Si
% no la hay, en ese momento se le aplicará a esa ventana una ganancia 
% positiva, pero menor que 0, lo que hará que se baje el nivel y no se 
% escuche tan fuerte el ruido indeseado.

% Aplicación del algoritmo VAD.
SilenciosPuerta_1_VAD = VAD(SilenciosPuerta_1, FsSilenciosPuerta_1, 40, 5, 145);
SilenciosPuerta_2_VAD = VAD(SilenciosPuerta_2, FsSilenciosPuerta_2, 45, 5, 145);
SilenciosSilla_1_VAD = VAD(SilenciosSilla_1, FsSilenciosSilla_1, 40, 5, 145);
SilenciosSilla_2_VAD = VAD(SilenciosSilla_2, FsSilenciosSilla_2, 40, 3, 145);

% Prueba de escucha.
% ap = audioplayer(SilenciosPuerta_1_VAD, FsSilenciosSilla_1);
% playblocking(ap);
% 
% Prueba de plot de las señales.
% figure(34)
% plot(SilenciosPuerta_1_VAD)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SilenciosPuerta 1 con VAD')
% 
% figure(35)
% plot(SilenciosPuerta_2_VAD)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SilenciosPuerta 2 con VAD ')
% 
% figure(36)
% plot(SilenciosSilla_1_VAD)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SilenciosSilla 1 con VAD')
% 
% figure(37)
% plot(SilenciosSilla_2_VAD)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SilenciosSilla 2 con VAD')

% Esportación de las señales de audio.
% audiowrite('SilenciosPuerta_1_VAD.wav', SilenciosPuerta_1_VAD, FsSilenciosPuerta_1);
% audiowrite('SilenciosPuerta_2_VAD.wav', SilenciosPuerta_2_VAD, FsSilenciosPuerta_2);
% audiowrite('SilenciosSilla_1_VAD.wav', SilenciosSilla_1_VAD, FsSilenciosSilla_1);
% audiowrite('SilenciosSilla_2_VAD.wav', SilenciosSilla_2_VAD, FsSilenciosSilla_2);


%%%%%%%%%%%%%%%%% VAD_PR_RMS UN UMBRAL, VALORES FIJOS %%%%%%%%%%%%%%%%%%%%%

% Este algoritmo, además de permitirte saber si, en un cierto momento, hay
% voz o no, te permite saber si esa voz está por debajo de un Umbral. Si
% no hay voz, en ese momento se le aplicará a esa ventana una ganancia 
% positiva, pero menor que 0, lo que hará que se baje el nivel y no se 
% escuche tan fuerte el ruido indeseado; si si hay voz y si esta se 
% encuentra por debajo del Umbral, también se aplicará la Ganancia, ya que
% entiende que es una voz que no pertenece a la conversación, y que por lo 
% tanto, no se quiere transmitir.

% Aplicación del algoritmo.
SusurrosMusica_1_VAD_PR_RMS = VAD_PR_RMS(SusurrosMusica_1, FsSusurrosMusica_1, 40, 3.7, 140, RMSnormal); 
SusurrosMusica_2_VAD_PR_RMS = VAD_PR_RMS(SusurrosMusica_2, FsSusurrosMusica_2, 60, 5.7, 160, RMSnormal);
SusurrosMesa_1_VAD_PR_RMS = VAD_PR_RMS(SusurrosMesa_1, FsSilenciosSilla_1, 48, 4, 145, RMSnormal);
SusurrosMesa_2_VAD_PR_RMS = VAD_PR_RMS(SusurrosMesa_2, FsSilenciosSilla_2, 50, 6, 155, RMSnormal);

% Prueba de escucha.
% ap = audioplayer(SusurrosMusica_1_VAD_PR_RMS, FsSusurrosMusica_1);
% playblocking(ap);

% Prueba de plot.
% figure(38)
% plot(SusurrosMusica_1_VAD_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SusurrosMusica 1 con VAD PR RMS')
% 
% figure(39)
% plot(SusurrosMusica_2_VAD_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SusurrosMusica 2 con VAD PR RMS')
% 
% figure(40)
% plot(SusurrosMesa_1_VAD_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SusurrosMesa 1 con VAD PR RMS')
% 
% figure(41)
% plot(SusurrosMesa_2_VAD_PR_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal SusurrosMesa 2 con VAD PR RMS')

% Exportación de las señales de audio.
% audiowrite('SusurrosMusica_1_VAD_PR_RMS.wav', SusurrosMusica_1_VAD_PR_RMS, FsSusurrosMusica_1);
% audiowrite('SusurrosMusica_2_VAD_PR_RMS.wav', SusurrosMusica_2_VAD_PR_RMS, FsSusurrosMusica_2);
% audiowrite('SusurrosMesa_1_VAD_PR_RMS.wav', SusurrosMesa_1_VAD_PR_RMS, FsSusurrosMesa_1);
% audiowrite('SusurrosMesa_2_VAD_PR_RMS.wav', SusurrosMesa_2_VAD_PR_RMS, FsSusurrosMesa_2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% ALGORITMO FINAL BASADO EN RMS %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Este algoritmo se va a aplicar a una señal que presenta las siguientes
% características:
% - Cambios de nivel.
% - Sonido de alguien llamando a una puerta.
% - Sonido de una alarma a un nivel muy alto.
% - Susurros.
% - Nivel normal de voz.

% Este algoritmo aplica todos los algoritmos anteriormente vistos:
% - Control de ganancia
% - Puerta de Ruido
% - Compresor Limitador
% - VAD
% Esto permite que, en el momento en el que se producen cambios de nivel,
% estos se aplica una Ganancia multiplicando o dividiendo a las muestras de
% esa ventana, para obetener unos niveles en torno al RMS Normal y que no
% se noten estos cambios de nivel; en el momento en el que se detecta voz
% pero esta se encuentra por debajo del Umbral de la Puerta de Ruido, se
% aplica una Ganancia positiva, pero menor que 0, que hace que estos
% susurros no se escuchen; en el momento en el que hay un nivel muy alto,
% si se trata de algo que no sea voz, se aplica la Puerta de Ruido, y si se
% trata de voz, se aplica una Ganancia que baja el nivel, pero permite que
% se siga escuchando; en el momento en el que no hay voz, y el ruido está
% entre el Umbral de la Puerta de Ruido y del Compresor Limitador, se
% aplica la Puerta de Ruido para que este ruido no se escuche.

% Aplicación del algoritmo.
[Final_FINAL_RMS, E, SFM, F, RMSventana] = FINAL_RMS(Final, FsFinal, 45, 12, 140, 0.04);

% Prueba de escucha.
% ap = audioplayer(Final_FINAL_RMS, FsFinal);
% playblocking(ap);

% Prueba de plot de la señal de audio.
% figure(41)
% plot(Final_FINAL_RMS)
% xlabel('Número de muestras')
% ylabel('Amplitud')
% title('Señal Final con FINAL RMS')

% Exportación de la señal de audio.
% audiowrite('Final_FINAL_RMS.wav', Final_FINAL_RMS, FsFinal);
