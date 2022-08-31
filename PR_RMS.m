%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% PUERTA DE RUIDO BASADA EN RMS %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función aplica la Puerta de Ruido basada en RMS.
% En este caso, la Puerta de Ruido basada en RMS se activará cuando el
% RMSventana se encuentre sustancialmente por debajo del RMSnormal. Cuando
% se active, a las muestras pertenecientes a esa ventana se las
% multiplicará por una ganancia positiva, pero menor que 0, para disminuir 
% su nivel.

function [PR_RMS] = PR_RMS(muestra, fs, RMSnormal)

    % Me creo una variable Umbral que me servirá para indicar cuando se tiene
    % que activar la Puerta de Ruido. En este caso, he decidido que se active
    % cuando el RMSventana sea sustancialmente menor que el RMSnormal,
    % considerando con ello que hay RF y no Voz. En este caso, el
    % sustancialmente más bajo quiere decir que esté 6, 10 o 12dB (a criterio 
    % del consumidor) por debajo de RMSnormal. 
    % Como estoy trabajando en RMS en Unidades Naturales (U.N.), lo primero que 
    % tengo que hacer es pasar este RMSnormala dB.
    % Para ello:
    %
    %                           dB = 20*log10(RMS(U.N.))
    %
    RMSnormaldB = 20*log10(RMSnormal);
    
    % Lo siguiente es saber qué valor marca que un nivel es sustancialmente más
    % bajo, por lo que teniendo en cuenta lo dicho anteriormente, se deben
    % comparar los dBs del RMSnormal con los 12dB menos. Al estar trabajando 
    % con RMS, los cuales están en U.N., será necesario pasar este valor de 
    % comparación a U.N., y este será mi Umbral de activación de la Puerta de
    % Ruido.
    Comparacion = RMSnormaldB-12;
    Umbral = 10^(Comparacion/20);
    
    % Me creo una variable G que será por la que tendré que multiplicar las
    % muestras de la ventana en la que se active la Puerta de Ruido.
    % En este caso se ha decidido que la Puerta de Ruido decremente 40dB el
    % nivel, por lo que lo primero que hay que hacer es calcular en U.N.
    % cuánto es ese decremento de 40dB.
    G = 10^(-40/20); % Se pone -40 ya que es un decremento y la G = salida/entrada.
    
    % Creo dos variables que me servirán para marcar el inicio y el fin de
    % la ventana deslizante en la que tengo que calcular el RMS.
    inicio_rms = 1;
    fin_rms = inicio_rms+(fs*1);
    
    % Me creo una primera ventana deslizante de 1seg de duración que me servirá
    % para empezar con los cálculos.
    inicio_primera = 1;
    fin_primera = inicio_primera+(fs*1);
    
    % Creo dos variables que me servirán para marcar el inicio y el fin del 
    % tramo en el que tengo que aplicar la Puerta de Ruido Lineal basada en RMS.
    % Voy a suponer que mientras que estoy calculando la ganancia
    % de la ventana deslizante anterior, ha pasado 1seg en el que me han 
    % llegado nuevas muestras.
    inicio_aplicacion = fin_primera;
    fin_aplicacion = inicio_aplicacion+(fs*1);
    
    % Esta variable me va a servir para meterme en el bucle que me indica que
    % estoy empezando a analizar la muestra y que tengo que usar la primera
    % ventana.
    contador = 1;
    
    % Creo una variable Tope para evitar errores, cuando el valor final de la 
    % ventana sobrepase este "tope", el fin será la última muestra de la señal.
    tope = length(muestra);
    
    % Me creo una copia de la señal original que es donde voy a aplicar los
    % cambios ya que al haber creado una función en Matlab, necesito devolver
    % algo.
    PR_RMS(:,1) = muestra(:,1);

    % Recorro la señal por completo.
    while fin_rms < tope
        % Si me encuentro al principio de la señal, es decir, en la primera
        % ventana.
        if contador == 1
            % Calculo el RMS en la primera ventana.
            RMSventana = rms(muestra(inicio_primera:fin_primera,1));      
            % Si el RMS calculado en la ventana está por debajo del Umbral 
            % marcado, aplico la Puerta de Ruido.      
            if RMSventana < Umbral
                % Aplico la Puerta de Ruido basada en RMS. 
                PR_RMS(inicio_aplicacion:fin_aplicacion,1) = PR_RMS(inicio_aplicacion:fin_aplicacion,1)*G;
                % Avanzo la ventana en la que voy a calcular el próximo RMS.
                inicio_rms = fin_rms-(fs*0.3);
                fin_rms = inicio_rms+(fs*1);
                copia_fin_rms = fin_rms;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_rms>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_rms = copia_fin_rms;
                    fin_rms = tope;
                end
                % Avanzo en la ventana en la que voy a aplicar la próxima
                % Ganancia.
                inicio_aplicacion = fin_aplicacion;
                fin_aplicacion = inicio_aplicacion+(fs*1);
                copia_fin_aplicacion = fin_aplicacion;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_aplicacion>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_aplicacion = copia_fin_aplicacion;
                    fin_aplicacion = tope;
                end
            % Si RMSventana no está por debajo del Umbral, no se aplica ninguna
            % Ganancia a las muestras, ya que no se activa la Puerta de Ruido,
            % por lo que lo único que se hace es avanzar en las ventanas.
            else
                % Avanzo la ventana en la que voy a calcular el próximo RMS.
                inicio_rms = fin_rms-(fs*0.3);
                fin_rms = inicio_rms+(fs*1);
                copia_fin_rms = fin_rms;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_rms>tope
                    % Si sí he llegado al final de la muestra, digo que el
                    % final de la ventana será el final de la muestra.
                    inicio_rms = copia_fin_rms;
                    fin_rms = tope;
                end
                % Avanzo en la ventana en la que voy a aplicar la próxima
                % Ganancia.
                inicio_aplicacion = fin_aplicacion;
                fin_aplicacion = inicio_aplicacion+(fs*1);
                copia_fin_aplicacion = fin_aplicacion;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_aplicacion>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_aplicacion = copia_fin_aplicacion;
                    fin_aplicacion = tope;
                end
            end
            % Una vez que ya he analizado los primeros Xs de la señal,
            % aumento el contador para aplicar el algoritmo en el resto de 
            % la señal.
            contador = contador + 1;
        else
            % Calculo el RMS en la siguiente ventana.
            RMSventana = rms(PR_RMS(inicio_rms:fin_rms,1));
            % Si el RMS calculado en la ventana está por debajo del Umbral 
            % marcado, aplico la Puerta de Ruido.      
            if RMSventana < Umbral
                % Aplico la Puerta de Ruido basada en RMS. 
                PR_RMS(inicio_aplicacion:fin_aplicacion,1) = PR_RMS(inicio_aplicacion:fin_aplicacion,1)*G;
                % Avanzo la ventana en la que voy a calcular el próximo RMS.
                inicio_rms = fin_aplicacion-(fs*0.3);
                fin_rms = inicio_rms+(fs*1);
                copia_fin_rms = fin_rms;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_rms>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_rms = copia_fin_rms;
                    fin_rms = tope;
                end
                % Avanzo en la ventana en la que voy a aplicar la próxima
                % Puerta de Ruido.
                inicio_aplicacion = fin_aplicacion;
                fin_aplicacion = inicio_aplicacion+(fs*1);
                copia_fin_aplicacion = fin_aplicacion;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_aplicacion>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_aplicacion = copia_fin_aplicacion;
                    fin_aplicacion = tope;
                end
            % Si RMSventana no está por debajo del Umbral, no se aplica ninguna
            % Ganancia a las muestras, ya que no se activa la Puerta de Ruido,
            % por lo que lo único que se hace es avanzar en las ventanas.
            else
                % Avanzo la ventana en la que voy a calcular el próximo RMS.
                inicio_rms = fin_rms-(fs*0.3);
                fin_rms = inicio_rms+(fs*1);
                copia_fin_rms = fin_rms;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_rms>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_rms = copia_fin_rms;
                    fin_rms = tope;
                end
                % Avanzo en la ventana en la que voy a aplicar la próxima
                % Ganancia.
                inicio_aplicacion = fin_aplicacion;
                fin_aplicacion = inicio_aplicacion+(fs*1);
                copia_fin_aplicacion = fin_aplicacion;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_aplicacion>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_aplicacion = copia_fin_aplicacion;
                    fin_aplicacion = tope;
                end
            end        
        end
    end
end