%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNCIÓN SIN RF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función "filtra" la señal, separando los momentos de voz y los de 
% RF.
%
% Dado que el "filtrado" entre RF y voz se va a realizar en las Muestras
% Normales, simplemente con el ploteo, o con los propios valores de 
% amplitud de las señales se puede marcar un valor máximo y mínimo de 
% que marcarán los límites para la separación de la voz.
% 
% En este caso, y mediante la visualización de los plots, se ha decidido
% que el valor máximo y mínimo van a ser:
% 
%                         max = 0.04
%
%                         min = -0.04
%
% Estos valores representan el valor máximo y mínimo que tiene el RF en
% estas muestras.

function [Voz] = Voz(muestra)
    max = 0.04;
    min = -0.04;
    % Me creo dos variables que me ayudarán a guardar las muestras de Voz y
    % de RF en un array.
    contador_1 = 1;
    contador_2 = 1; 
    % Se recorre la señal entera,  muestra a muestra.
    for i=1:length(muestra)
        % Si la muestra se encuentra por encima del valor máximo del RF, se
        % marca como Voz.
        if muestra(i,1) > max
            Voz(contador_1,1) = muestra(i,1);
            contador_1 = contador_1+1;
        % Si la muestra se encuentra por debajo del valor mínimo del RF, se
        % marca como Voz.
        elseif muestra(i,1) < min
            Voz(contador_1,1) = muestra(i,1);
            contador_1 = contador_1+1;
        % Si la muestra se encuentra entre el valor máximo y mínimo del RF,
        % se marca como RF.
        elseif min < muestra(i,1) < max
            RF(contador_2,1) = muestra(i,1);
            contador_2 = contador_2+1;
        end
    end
end