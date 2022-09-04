%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FUENTE: MATHWORKS HELP CENTER-DENOISE SPEECH USING DEEP LEARNING NETWORKS
% ( https://ww2.mathworks.cn/help/audio/ug/denoise-speech-using-deep-learning-networks.html )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% ADICION DE RUIDO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función añade ruido a una señal limpia.

function [ADICION_RUIDO] = ADICION_RUIDO(muestra_limpia, ruido)
    % Extracción de un segmento de la señal de ruido en un momento
    % aleatorio.
    ind = randi(numel(ruido) - numel(muestra_limpia) + 1,1,1);
    segmentoRuido = ruido(ind:ind + numel(muestra_limpia) - 1);
    % Cálculo de la energía de la señal limpia.
    energiaVoz = sum(muestra_limpia.^2);
    % Cálculo de la energía de la señal de ruido.
    energiaRuido = sum(segmentoRuido.^2);
    % Adición del ruido a la señal limpia.
    ADICION_RUIDO = muestra_limpia + sqrt(energiaVoz/energiaRuido)*segmentoRuido;
end