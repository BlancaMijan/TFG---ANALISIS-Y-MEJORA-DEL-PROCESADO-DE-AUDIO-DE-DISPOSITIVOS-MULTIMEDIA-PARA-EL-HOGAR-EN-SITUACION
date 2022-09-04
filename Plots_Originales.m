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

[RuidoBlanco_1, FsRuidoBlanco_1] = audioread('4.2.1 - Ruido blanco.m4a');
[RuidoBlanco_2, FsRuidoBlanco_2] = audioread('4.2.2 - Ruido blanco.m4a');

[Puerta, FsPuerta] = audioread('13 - Puerta.m4a');

[Musica_1, FsMusica_1] = audioread('14 - Musica_1.m4a');
[Musica_2, FsMusica_2] = audioread('14 - Musica_2.m4a');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% PLOTEO DE LAS MUESTRAS ORIGINALES DE AUDIO %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)
plot(Normal_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Normal 1')

figure(2)
plot(Normal_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Normal 2')

figure(3)
plot(Normal_3)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Normal 3')

figure(4)
plot(Normal_4)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Normal 4')

figure(5)
plot(Normal_5)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Normal 5')

figure(6)
plot(Normal_6)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Normal 6')

figure(7)
plot(CercaLejos_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Cerca Lejos 1')

figure(8)
plot(CercaLejos_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Cerca Lejos 2')

figure(9)
plot(MedioCercaLejos_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Medio Cerca Lejos 1')

figure(10)
plot(MedioCercaLejos_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Medio Cerca Lejos 2')

figure(11)
plot(MedioCercaLejos_3)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Medio Cerca Lejos 3')

figure(12)
plot(LejosCerca_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Lejos Cerca 1')

figure(13)
plot(LejosCerca_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Lejos Cerca 2')

figure(14)
plot(SilencioLargo_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Silencio Largo 1')

figure(15)
plot(SilencioLargo_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Silencio Largo 2')

figure(16)
plot(SilencioLargo_3)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Silencio Largo 3')

figure(17)
plot(Gritos_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Gritos 1')

figure(18)
plot(Gritos_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Gritos 2')

figure(19)
plot(SilenciosPuerta_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Silencios Puerta 1')

figure(20)
plot(SilenciosPuerta_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Silencios Puerta 2')

figure(21)
plot(SilenciosSilla_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal SilenciosSilla 1')

figure(22)
plot(SilenciosSilla_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Silencios Silla 2')

figure(23)
plot(SusurrosMusica_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Susurros Musica 1')

figure(24)
plot(SusurrosMusica_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Susurros Musica 2')

figure(25)
plot(SusurrosMesa_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Susurros Mesa 1')

figure(26)
plot(SusurrosMesa_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Susurros Mesa 2')

figure(27)
plot(Final)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Final')

figure(28)
plot(RuidoBlanco_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Ruido Blanco 1')

figure(29)
plot(RuidoBlanco_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Ruido Blanco 2')

figure(30)
plot(Puerta)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Puerta')

figure(31)
plot(Musica_1)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Musica 1')

figure(32)
plot(Musica_2)
xlabel('Número de muestras')
ylabel('Amplitud')
title('Señal Musica 2')
