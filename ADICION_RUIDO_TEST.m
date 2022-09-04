%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FUENTE: MATHWORKS HELP CENTER-DENOISE SPEECH USING DEEP LEARNING NETWORKS
% ( https://ww2.mathworks.cn/help/audio/ug/denoise-speech-using-deep-learning-networks.html )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% ADICION DE RUIDO EN TEST %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Esta función añade ruido a una señal limpia.

function [ADICION_RUIDO_TEST] = ADICION_RUIDO_TEST(muestra_limpia, ruido)
    % Extracción de un segmento de la señal de ruido en un momento
    % aleatorio.
    randind = randi(numel(ruido) - numel(muestra_limpia), [1,1]);
    segmentoRuido = ruido(randind:randind + numel(muestra_limpia) - 1);
    % Cálculo de la energía de la señal limpia.
    energiaLimpia = sum(muestra_limpia.^2);
    % Cálculo de la energía de la señal de ruido.
    energiaRuido = sum(segmentoRuido.^2);
    segmentoRuido = segmentoRuido.*sqrt(energiaLimpia/energiaRuido);
    % Adición del ruido a la señal limpia.
    ADICION_RUIDO_TEST = muestra_limpia + segmentoRuido;
end