
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% VOICE ACTIVITY DETECTION CON PR_RMS %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función aplica el Voice Activity Detection (VAD). La implementación
% de este algoritmo está basada en el artículo "A simple but efficient
% real-time voice activity detection algorithm" de M. H. Moattar y M. H.
% Homayounpour.
%
% Este algoritmo de detección de la voz está basado en tres
% características: -Energía. -Spectral Flatness Measure (SFM), que indica
% la planitud espectral de la señal. -F: representa la componente de la
% frecuencia más dominante en el espectro.
%
% La idea de funcionamiento de este algoritmo es calcular durante las
% primeras muestras de señal los valores de estas características y con
% ello marcar umbrales. A medida que sigue producienéndose la llamada, se
% siguen calculando dichas características, para comprobar si más de una de
% ellas está por debajo de los umbrales, se marca esa muestra como voz.

function [VAD_PR_RMS, E, SFM, F, RMSventana] = VAD_PR_RMS(muestra, fs, E_NORMAL, SFM_NORMAL, F_NORMAL, RMS_NORMAL)

    % Me creo unas variables auxiliares que usaré más adelante para
    % comprobar si ha habido más de 10 ventanas seguidas marcadas como
    % silencio y más de 5 ventanas seguidas marcadas como voz.
    contador_voz = 0;
    contador_silencio = 0;

    % Me creo una variable que me indica el tamaño de cada vetnana, en este
    % caso son 30ms.
    Tamanio_Ventana = 0.03;

    % Me creo una variable que me calcule el número de muestras que me
    % caben en una ventana y me creo dos variables, una de inicio y una de
    % fin para marcar por dónde voy en el análisis de la señal de audio,
    % para ello:
    %
    %                 fs*tiempo = Numero muestras
    % 
    Muestras_Ventana = fs*Tamanio_Ventana;
    Inicio_Muestras_Ventana = 1;
    Fin_Muestras_Ventana = fs*Tamanio_Ventana;

    % Calculo el número de ventanas que caben en la señal de audio, para
    % ello:
    % 
    %            Numero ventanas = tamaño muestra/tamaño ventana
    %
    Num_Ventanas = length(muestra)/Muestras_Ventana;

    % Redondeo al entero más próximo el número de ventanas que caben en la
    % señal para evitar errores.
    Num_Ventanas = round(Num_Ventanas);

    % Me creo e inicializo a 0 las variables que usaré más adelante.
    Min_E = 0;
    Min_F = 0;
    Min_SFM = 0;
    E_Umbral_Inicial = E_NORMAL;
    F_Umbral_Inicial = F_NORMAL;
    SFM_Umbral_Inicial = SFM_NORMAL;

    % Me creo una variable tope que me servirá para saber cuándo ha
    % finalizado la señal de audio.
    tope = length(muestra);

    % Me creo una variable G que será por la que tendré que multiplicar las
    % muestras de la ventana en la que se active la Puerta de Ruido. En
    % este caso se ha decidido que la Puerta de Ruido decremente 40dB el
    % nivel, por lo que lo primero que hay que hacer es calcular en U.N.
    % cuánto es ese decremento de 40dB.
    G = 10^(-40/20); % Se pone -40 ya que es un decremento y la G = salida/entrada.
    
    % Me creo una variable Umbral que me servirá para indicar cuando se
    % tiene que activar la Puerta de Ruido. En este caso, he decidido que
    % se active cuando el RMSventana sea 5dB mayor que el RMSNormal. Como
    % estoy trabajando en RMS en Unidades Naturales (U.N.), lo primero que
    % tengo que hacer es pasar este RMSnormala dB. Para ello:
    %
    %                           dB = 20*log10(RMS(U.N.))
    %
    RMSnormaldB = 20*log10(RMS_NORMAL);

    % Lo siguiente es crear una variable que me servirá para comparar el
    % RMS de la ventana en la que esté trabajando con el RMSNormal. En este
    % caso quiero comprobar si el RMS en la ventana es 18dB menor que el
    % RMSNormal.
    Comparacion = RMSnormaldB-18;
    Umbral = 10^(Comparacion/20);

    % Me creo una copia de la muestra original que es donde voy a aplicarTamanio_Ventana
    % los cambios ya que al haber creado una función en Matlab, necesito
    % devolver algo.
    VAD_PR_RMS(:,1) = muestra(:,1);

    % Me creo una variable que me ayudará a guardar la info calculada en
    % cada una de las ventanas.
    x = 1;
    for aux = 1:Num_Ventanas-1
        % Recorro la señal por completo.
        if x < Num_Ventanas-1
            % Cálculo de la Energía en dB de la ventana.
            Abs_cuadrado = (abs(muestra(Inicio_Muestras_Ventana:Fin_Muestras_Ventana)).^2);
            E(x,1) = 10*log10((sum(Abs_cuadrado))/0.00002);
            % Cálculo de la FFT de las muestras contenidas en la ventana.
            Fourier = fft(muestra(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1));
            L = length(muestra(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1));
            P2 = abs(Fourier/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = fs*((0:(L/2))/L);
            % Cálculo del bin en el que ocurre el máximo.
            maxP1 = max(P1);
            % Me creo un bucle para averiguar en qué posicion de P1 se ha
            % encontrado el máximo.
            y = 1;
            aux_primera_iteracion = 1;
            while y < length(P1)
                if (P1(y,1) == maxP1) && (aux_primera_iteracion == 1)
                    % Busco qué valor de frecuencia corresponde a la
                    % posición en la que se ha encontrado el máximo de P1.
                    F(x,1) = f(1,y);
                    aux_primera_iteracion = aux_primera_iteracion+1;
                    y = length(P1)+1;
                end
                y = y+1;
            end
            % Cálculo de la SFM de la ventana.
            Gm = geomean(P1);
            Am = mean(P1);      
            SFM(x,1) = 10*log10(Gm/Am);
            % Me creo un bucle para que, en la primera ventana, se tome
            % como valor de minE, minF y minSFM los valores que se hayan
            % calculado de estos.
            if x == 1
                Min_E = E(x,1);
                Min_F = F(x,1);
                Min_SFM = SFM(x,1);
            end
            if (1 < x) && (x < 30)
                if E(x,1) < Min_E
                    Min_E = E(x,1);
                end
                if F(x,1) < Min_F
                    Min_F = F(x,1);
                end
                if SFM(x,1) < Min_SFM
                    Min_SFM = SFM(x,1);
                end
            end
            % Me creo un bucle que me compruebe si he analizado las 30
            % primeras ventas, y si es así, suponiendo que alguna de estas
            % 30 primeras ventanas son silencio, calculo la Min_E, Min_F y
            % Min_SFM.
            if x == 30
                Min_E = min(E);
                Min_F = min(F);
                Min_SFM = min(SFM);
            end
            % Calculo los umbrales de E, F y SFM.
            E_Umbral = E_Umbral_Inicial*log10(Min_E);
            F_Umbral = F_Umbral_Inicial;
            SFM_Umbral = SFM_Umbral_Inicial;
            % Me creo una variable que me servirá de contador.
            contador_temp = 0;
            % Añado 1 al valor del contador si la energía de la ventana
            % menos el mínimo de la energía es mayor o igual que el
            % E_Umbral.
            if (E(x,1) - Min_E) >= E_Umbral
                contador_temp = contador_temp+1;
            end
            % Añado 1 al valor del contador si la F de la ventana menos el
            % mínimo de la F es mayor o igual que el F_Umbral.
            if (F(x,1) - Min_F) >= F_Umbral
                contador_temp = contador_temp+1;
            end
            % Añado 1 al valor del contador si la SFM de la ventana menos
            % el mínimo de la SFM es mayor o igual que el SFM_Umbral.
            if (SFM(x,1) - Min_SFM) >= SFM_Umbral
                contador_temp = contador_temp+1;
            end
            % Si el contador es mayor que 1, marco la ventana en la que
            % estoy trabajando como ventana con Voz; por el contrario, la
            % marco como Silencio.
            if contador_temp > 1
                contador_voz = contador_voz+1;
                % Si la ventana con la que estoy trabajando es marcada como
                % voz, el contador_silencio se pone a 0 para indicar que no
                % hay x ventanas_silencio seguidas, para posteriores
                % comprobaciones.
                contador_silencio = 0;
            else
                contador_silencio = contador_silencio+1;
                % Si la ventana con la que estoy trabajando es marcada como
                % silencio, el contador_voz se pone a 0 para indicar que no
                % hay x ventanas_voz seguidas, para posteriores
                % comprobaciones.
                contador_voz = 0;
                % Si he marcado la ventana como silencio, recalculo el
                % Min_E.
                Min_E = (((contador_silencio*Min_E)+E(x,1))/(contador_silencio+1));
            end
            % Recalculo el E_Umbral con el nuevo valor de Min_E.
            E_Umbral = E_Umbral_Inicial*log10(Min_E);
            % Me creo dos variables que me indicarán si la ventana en la
            % que estoy se ha marcado como silencio (ventana_silencio = 1)
            % o como voz (ventana_voz = 1).
            ventana_silencio = 0;
            ventana_voz = 0;
            % Marco la ventana como silencio si hay más de 10 ventanas
            % sucesivas marcadas como silencio.
            if contador_silencio >= 10
                ventana_silencio = 1;
            end
            % Marco la ventana como voz si hay más de 5 ventanas sucesivas
            % marcadas como voz.
            if contador_voz >= 5
                ventana_voz = 1;
            end
            
            % Calculo el RMS en la ventana.
            RMSventana(x,1) = rms(muestra(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1));
            % Si el RMS de la ventana está por debajo del umbral, sea voz o
            % no, se asume que no se quiere transmitir, por lo que se
            % activa la puerta de ruido, la cual aplica una ganancia que 
            % disminuye sustancialemente el nivel.
            if RMSventana(x,1) < Umbral
                VAD_PR_RMS(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1) = VAD_PR_RMS(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1)*G;
                % Avanzo el inicio y el fin de las Muestras_Ventana
                % para avanzar a la siguiente ventana, comprobando que
                % si he llegado al final de la señal de voz.
                Inicio_Muestras_Ventana = Fin_Muestras_Ventana;
                Fin_Muestras_Ventana = Inicio_Muestras_Ventana+Muestras_Ventana;
                copia_Fin_Muestras_Ventana = Fin_Muestras_Ventana;
                % Compruebo que no esté intentando coger valores por
                % encima del final de la señal.
                if Fin_Muestras_Ventana>tope
                    % Si sí he llegado al final de la señal, digo que
                    % el final de la ventana será el final de la
                    % señal.
                    Inicio_Muestras_Ventana = copia_Fin_Muestras_Ventana;
                    Fin_Muestras_Ventana = tope;
                end
                 x = x+1;
             % Si el RMS de la ventana está por encima del umbral, hay dos
             % opciones, o que sea voz o que no.
             elseif RMSventana(x,1) > Umbral
                 % Si lo que se ha detectado es voz, se transmite.
                 if ventana_voz == 1 || ventana_silencio == 0 
                     % Avanzo el inicio y el fin de las Muestras_Ventana
                     % para avanzar a la siguiente ventana, comprobando que
                     % si he llegado al final de la señal de voz.
                     Inicio_Muestras_Ventana = Fin_Muestras_Ventana;
                     Fin_Muestras_Ventana = Inicio_Muestras_Ventana+Muestras_Ventana;
                     copia_Fin_Muestras_Ventana = Fin_Muestras_Ventana;
                     % Compruebo que no esté intentando coger valores por
                     % encima del final de la señal.
                     if Fin_Muestras_Ventana>tope
                         % Si sí he llegado al final de la señal, digo que
                         % el final de la ventana será el final de la
                         % señal.
                         Inicio_Muestras_Ventana = copia_Fin_Muestras_Ventana;
                         Fin_Muestras_Ventana = tope;
                     end
                     x = x+1;
                 % Si lo que se ha detectado no es voz, se activa la puerta
                 % de ruido, la cual aplica una ganancia que disminuye
                 % sustancialemente el nivel.
                 elseif ventana_silencio == 1 || ventana_voz == 0
                    VAD_PR_RMS(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1) = VAD_PR_RMS(Inicio_Muestras_Ventana:Fin_Muestras_Ventana,1)*G;
                    % Avanzo el inicio y el fin de las Muestras_Ventana
                    % para avanzar a la siguiente ventana, comprobando que
                    % si he llegado al final de la señal de voz.
                    Inicio_Muestras_Ventana = Fin_Muestras_Ventana;
                    Fin_Muestras_Ventana = Inicio_Muestras_Ventana+Muestras_Ventana;
                    copia_Fin_Muestras_Ventana = Fin_Muestras_Ventana;
                    % Compruebo que no esté intentando coger valores por
                    % encima del final de la señal.
                    if Fin_Muestras_Ventana>tope
                        % Si sí he llegado al final de la señal, digo que
                        % el final de la ventana será el final de la
                        %  señal.
                        Inicio_Muestras_Ventana = copia_Fin_Muestras_Ventana;
                        Fin_Muestras_Ventana = tope;
                    end
                    x = x+1;
                 end
             end
         end
    end
end