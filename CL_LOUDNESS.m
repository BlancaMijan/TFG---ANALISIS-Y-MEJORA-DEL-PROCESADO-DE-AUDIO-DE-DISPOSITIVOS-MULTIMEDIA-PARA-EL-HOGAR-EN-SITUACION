%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% FUNCIÓN COMPRESOR LIMITADOR BASADO EN LOUDNESS %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función aplica el Compresor Limitador, el cual hace que a partir de 
% un cierto Umbral, por encima, se limite el nivel de la señal.

function [CL_LOUDNESS] = CL_LOUDNESS(muestra, fs, LOUDNESSnormal)

    % Me creo una variable Umbral que me servirá para indicar cuando se tiene
    % que activar el Compresor Limitador. En este caso, como LOUDNESS está en
    % Sones, y estos son lineales, por lo que he decidico que el Compresor 
    % Limitador se active cuando LOUDNESSventana se encuentre 12 Sonos por
    % encima de LOUDNESSnormal.
    Umbral = LOUDNESSnormal + 12;
    
    % Creo una variable que será la Ganancia por la que se multiplicarán las
    % muestras de la ventana en la que se aplique el Compresor Limitador. Esta
    % G bajará el nivel 30 dB.
    G = 10^(-30/20); % Se pone -40 ya que es un decremento.
    
    % Creo dos variables que me servirán para marcar el inicio y el fin de
    % la ventana deslizante en la que tengo que calcular el LOUDNESS.
    inicio_loudness = 1;
    fin_loudness = inicio_loudness+(fs*1);
    
    % Me creo una primera ventana deslizante de 1seg de duración que me servirá
    % para empezar con los cálculos.
    inicio_primera = 1;
    fin_primera = inicio_primera+(fs*1);
    
    % Creo dos variables que me servirán para marcar el inicio y el fin del 
    % tramo en el que tengo que aplicar la ganancia previamente calculada.
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
    
    % Me creo una copia de la muestra original que es donde voy a aplicar los
    % cambios ya que al haber creado una función en Matlab, necesito devolver
    % algo.
    CL_LOUDNESS(:,1) = muestra(:,1);
    
    % Recorro la señal por completo.
    while fin_loudness < tope
        % Si me encuentro al principio de la muestra.
        if contador == 1
            % Calculo el LOUDNESS en la primera ventana.
            LOUDNESSventana = acousticLoudness(muestra(inicio_primera:fin_primera,1),fs);
            % Si el LOUDNESS calculado en la ventana está por encima del 
            % LOUDNESSnormal, aplico el Compresor Limitador.      
            if LOUDNESSventana > Umbral
                % Aplico el Compresor Limitador
                CL_LOUDNESS(inicio_aplicacion:fin_aplicacion,1) = CL_LOUDNESS(inicio_aplicacion:fin_aplicacion,1)*G;
                % Avanzo la ventana en la que voy a calcular el próximo LOUDNESS.
                inicio_loudness = fin_loudness-(fs*0.3);
                fin_loudness = inicio_loudness+(fs*1);
                copia_fin_loudness = fin_loudness;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_loudness>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_loudness = copia_fin_loudness;
                    fin_loudness = tope;
                end
                % Avanzo en la ventana en la que voy a aplicar la próxima
                % Ganancia que calcule.
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
            % Si LOUDNESSventana no está por encima del Umbral, no se aplica ninguna
            % Ganancia a las muestras, ya que no se activa el Compresor Limitador,
            % por lo que lo único que se hace es avanzar en las ventanas.
            else
                % Avanzo la ventana en la que voy a calcular el próximo LOUDNESS.
                inicio_loudness = fin_loudness-(fs*0.3);
                fin_loudness = inicio_loudness+(fs*1);
                copia_fin_loudness = fin_loudness;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_loudness>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_loudness = copia_fin_loudness;
                    fin_loudness = tope;
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
            % Calculo el LOUDNESS de la ventana.
            LOUDNESSventana = acousticLoudness(CL_LOUDNESS(inicio_loudness:fin_loudness,1), fs);
            % Si el LOUDNESS calculado en la ventana está por encima del Umbral,
            % aplico el Compresor Limitador.  
            if LOUDNESSventana > Umbral
                % Aplico el Compresor Limitador
                CL_LOUDNESS(inicio_aplicacion:fin_aplicacion,1) = CL_LOUDNESS(inicio_aplicacion:fin_aplicacion,1)*G;
                % Avanzo la ventana en la que voy a calcular el próximo RMS.
                inicio_loudness = fin_aplicacion-(fs*0.3);
                fin_loudness = inicio_loudness+(fs*1);
                copia_fin_loudness = fin_loudness;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_loudness>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_loudness = copia_fin_loudness;
                    fin_loudness = tope;
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
            % Si LOUDNESSventana no está por encima del Umbral, no se aplica ninguna
            % Ganancia a las muestras, ya que no se activa el Compresor Limitador,
            % por lo que lo único que se hace es avanzar en las ventanas.
            else
                % Avanzo la ventana en la que voy a calcular el próximo LOUDNESS.
                inicio_loudness = fin_loudness-(fs*0.3);
                fin_loudness = inicio_loudness+(fs*1);
                copia_fin_loudness = fin_loudness;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_loudness>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_loudness = copia_fin_loudness;
                    fin_loudness = tope;
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