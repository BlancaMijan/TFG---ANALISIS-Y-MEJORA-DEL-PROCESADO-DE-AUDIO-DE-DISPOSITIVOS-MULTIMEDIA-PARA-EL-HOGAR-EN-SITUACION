%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% CÁLCULO DEL LOUDNESS_NORMAL EN VENTANAS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función calcula el LOUDNESSnormal, pero en vez de haciendo el 
% promedio de los LOUDNESS de las señales normales completas, haciendo el 
% promedio de los LOUDNESS de las ventanas de las señales normales.

function [LOUDNESS_NORMAL] = LOUDNESS_NORMAL(voz, fs)
    % Creo dos variables que me servirán para marcar el inicio y el fin de
    % la ventana deslizante en la que tengo que calcular el LOUDNESS.
    inicio_loudness = 1;
    fin_loudness = inicio_loudness+(fs*1);
    
    % Creo una variable Tope para evitar errores, cuando el valor final de la 
    % ventana sobrepase este "tope", el fin será la última muestra de la señal.
    tope = length(voz);
    
    % Me creo una variable que calcula el número de vetanas de 1s que tendrá la
    % señal a estudiar. Para ello uso la siguiente fórmula:
    % 
    %                        fs*tiempo = num_muestras
    %
    % Teniendo en cuenta que lo que quiero saber es el número de segundos que
    % dura la señal, ya que las ventanas duran 1s. 
    %
    %                        tiempo = num_muestras/fs
    %
    cont = length(voz)/fs;
    contador = round(cont);
    
    % Me creo una copia de la muestra original que es donde voy a aplicar los
    % cambios ya que al haber creado una función en Matlab, necesito devolver
    % algo.
    LOUDNESS_NORMAL = zeros(contador,1);
    
    while fin_loudness < tope
        for i=1:cont
            % Calculo el LOUDNESS de la ventana y lo guardo en la posición que
            % corresponda del array que luego se devuelve.
            LOUDNESS_NORMAL(i,1) = acousticLoudness(voz(inicio_loudness:fin_loudness,1), fs);
            % Avanzo la ventana en la que voy a calcular el próximo LOUDNESS.
            inicio_loudness = fin_loudness;
            fin_loudness = inicio_loudness+(fs*1);
            copia_fin_loudness = fin_loudness;
            % Compruebo que no esté intentando coger valores por encima del
            % final de la muestra.
            if fin_loudness>tope
                % Si sí he llegado al final de la muestra, digo que el
                % final de la ventana será el final de la muestra.
                inicio_loudness = copia_fin_loudness;
                fin_loudness = tope;
            end
        end
    end 
end


