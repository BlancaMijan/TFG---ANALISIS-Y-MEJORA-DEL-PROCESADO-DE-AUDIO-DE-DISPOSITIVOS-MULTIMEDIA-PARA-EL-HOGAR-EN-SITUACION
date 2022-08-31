%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% FUNCIÓN CONTROL DE GANANCIA BASADO EN EL RMS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función aplica el Control de Ganancia basado en el RMS.

function [CG_RMS] = CG_RMS(muestra, fs, RMSnormal)

    % Creo dos variables que me servirán para marcar el inicio y el fin de
    % la ventana deslizante en la que tengo que calcular la ganancia.
    inicio_ganancia = 1;
    fin_ganancia = inicio_ganancia+(fs*1);
    
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
    % estoy empezando a analizar la señal y que tengo que usar la primera
    % ventana.
    contador = 1;
    
    % Creo una variable Tope para evitar errores, cuando el valor final de la 
    % ventana sobrepase este "tope", el fin será la última muestra de la señal.
    tope = length(muestra);
    
    % Me creo una copia de la señal original que es donde voy a aplicar los
    % cambios ya que al haber creado una función en Matlab, necesito devolver
    % algo.
    CG_RMS(:,1) = muestra(:,1);
    
    % Recorro la señal por completo.
    while fin_ganancia < tope
        % Si me encuentro al principio de la señal, es decir, en la primera 
        % ventana.
        if contador == 1
            % Calculo el RMS en la primera ventana.
            RMSventana = rms(muestra(inicio_primera:fin_primera,1));
            % Si el RMS calculado en la ventana es mayor que el RMSnormal.
            if RMSventana > RMSnormal
                % Se calcula la diferencia de proporciones de RMSs, que será 
                % mi Ganancia a aplicar.
                Ganancia = RMSventana/RMSnormal;
                % Se aplica la Ganancia dividiendo para "bajar" los niveles.
                CG_RMS(inicio_aplicacion:fin_aplicacion,1) = CG_RMS(inicio_aplicacion:fin_aplicacion,1)/Ganancia;
                % Avanzo la ventana en la que voy a calcular la próxima
                % Ganancia.
                inicio_ganancia = fin_aplicacion-(fs*0.3);
                fin_ganancia = inicio_ganancia+(fs*1);
                copia_fin_ganancia = fin_ganancia;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_ganancia>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_ganancia = copia_fin_ganancia;
                    fin_ganancia = tope;
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
            % Si el RMS calculado en la ventana es menor que el RMSnormal.      
            elseif RMSventana < RMSnormal
                % Se calcula la diferencia de proporciones de RMSs, que será 
                % mi Ganancia a aplicar.
                Ganancia = RMSnormal/RMSventana;
                % Se aplica la Ganancia multiplicando para "subir" los niveles.
                CG_RMS(inicio_aplicacion:fin_aplicacion,1) = CG_RMS(inicio_aplicacion:fin_aplicacion,1)*Ganancia;
                % Avanzo la ventana en la que voy a calcular la próxima
                % Ganancia.
                inicio_ganancia = fin_aplicacion-(fs*0.3);
                fin_ganancia = inicio_ganancia+(fs*1);
                copia_fin_ganancia = fin_ganancia;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_ganancia>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_ganancia = copia_fin_ganancia;
                    fin_ganancia = tope;
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
            end
            % Una vez que ya he analizado los primeros Xs de la señal, es 
            % decir, la primera ventana, aumento el contador para aplicar el 
            % algoritmo en el resto de la señal.
            contador = contador + 1;
        else
            % Calculo el RMS de la ventana.
            RMSventana = rms(CG_RMS(inicio_ganancia:fin_ganancia,1));
            % Si el RMS calculado en la ventana es mayor que el RMSnormal.
            if RMSventana > RMSnormal
                % Se calcula la diferencia de proporciones de RMSs, que será 
                % mi Ganancia a aplicar.
                Ganancia = RMSventana/RMSnormal;
                % Se aplica la Ganancia dividiendo para "bajar" los niveles.
                CG_RMS(inicio_aplicacion:fin_aplicacion,1) = CG_RMS(inicio_aplicacion:fin_aplicacion,1)/Ganancia;
                % Avanzo la ventana en la que voy a calcular la próxima
                % Ganancia.
                inicio_ganancia = fin_aplicacion-(fs*0.3);
                fin_ganancia = inicio_ganancia+(fs*1);
                copia_fin_ganancia = fin_ganancia;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_ganancia>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_ganancia = copia_fin_ganancia;
                    fin_ganancia = tope;
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
            % Si el RMS calculado en la ventana es menor que el RMSnormal.   
            elseif RMSventana < RMSnormal
                % Se calcula la diferencia de proporciones de RMSs, que será 
                % mi Ganancia a aplicar.
                Ganancia = RMSnormal/RMSventana;
                % Se aplica la Ganancia multiplicando para "subir" los niveles.
                CG_RMS(inicio_aplicacion:fin_aplicacion,1) = CG_RMS(inicio_aplicacion:fin_aplicacion,1)*Ganancia;
                % Avanzo la ventana en la que voy a calcular la próxima
                % Ganancia.
                inicio_ganancia = fin_aplicacion-(fs*0.3);
                fin_ganancia = inicio_ganancia+(fs*1);
                copia_fin_ganancia = fin_ganancia;
                % Compruebo que no esté intentando coger valores por encima del
                % final de la señal.
                if fin_ganancia>tope
                    % Si sí he llegado al final de la señal, digo que el
                    % final de la ventana será el final de la señal.
                    inicio_ganancia = copia_fin_ganancia;
                    fin_ganancia = tope;
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
            end        
        end
    end
end