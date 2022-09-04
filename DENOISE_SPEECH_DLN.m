%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% AUTORA: Blanca Miján Peña %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% FUENTE: MATHWORKS HELP CENTER-DENOISE SPEECH USING DEEP LEARNING NETWORKS
% ( https://ww2.mathworks.cn/help/audio/ug/denoise-speech-using-deep-learning-networks.html )

clc; 
clear all; 
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% DENOISE SPEECH USING DEEP LEARNING NETWORKS %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%% IMPORTACIÓN Y ADICIÓN DE RUIDO A LAS SEÑALES %%%%%%%%%%%%%%%%%

% Este archivo aplica el "Denoise Speech Using Deep Learning Networks", el
% cual permite limpiar una señal de voz la cual presenta ruido de fondo.

% Se va a trabajar con un audio limpio (sin ruido de fondo) al cual se le
% va a agregar dicho ruido de fondo. 

% Importación de las señales de voz limpias.
[MuestraLimpia_1, FsMuestraLimpia_1] = audioread('5.1.1 - Muestra normal.m4a');
[MuestraLimpia_2, FsMuestraLimpia_2] = audioread('5.1.2 - Muestra normal.m4a');
[MuestraLimpia_4, FsMuestraLimpia_4] = audioread('5.3.1 - Muestra normal.m4a');
[MuestraLimpia_5, FsMuestraLimpia_5] = audioread('5.3.2 - Muestra normal.m4a');

% Hay que asegurarse de que la longitud del audio es múltiplo del factor de
% diezmado de la frecuencia de muestreo (8kHz).
fsEntrada = 48e3;
fs = 8e3;
factorDiezmado = fsEntrada/fs;

L_1 = floor(numel(MuestraLimpia_1)/factorDiezmado);
MuestraLimpia_1 = MuestraLimpia_1(1:factorDiezmado*L_1);

L_2 = floor(numel(MuestraLimpia_2)/factorDiezmado);
MuestraLimpia_2 = MuestraLimpia_2(1:factorDiezmado*L_2);

L_4 = floor(numel(MuestraLimpia_4)/factorDiezmado);
MuestraLimpia_4 = MuestraLimpia_4(1:factorDiezmado*L_4);

L_5 = floor(numel(MuestraLimpia_5)/factorDiezmado);
MuestraLimpia_5 = MuestraLimpia_5(1:factorDiezmado*L_5);

% Creación de un "dsp.SampleRateConverter" para cambiar la frecuencia de
% muestreo del audio de 48kHz a 8kHz.
src = dsp.SampleRateConverter(InputSampleRate=fsEntrada, OutputSampleRate=fs, Bandwidth=7920);

MuestraLimpia_1= src(MuestraLimpia_1);
reset(src)

MuestraLimpia_2 = src(MuestraLimpia_2);
reset(src)

MuestraLimpia_4 = src(MuestraLimpia_4);
reset(src)

MuestraLimpia_5 = src(MuestraLimpia_5);
reset(src)

% Prueba de escucha.
% sound(MuestraLimpia_1)

% Importación del ruido que se añadirá a las señales de voz limpias.
% ruido = audioread('4.2.1 - Ruido blanco.m4a');
% ruido = audioread('13 - Puerta.m4a');
ruido = audioread('14 - Musica_1.m4a');

% Hay que asegurarse de que la longitud del audio es múltiplo del factor de
% diezmado de la frecuencia de muestreo (8kHz).
L = floor(numel(ruido)/factorDiezmado);
ruido = ruido(1:factorDiezmado*L);

% Cambio en la frecuencia de muestreo, de 48kHz a 8kHz.
ruido= src(ruido);
reset(src)

% Adición del ruido a las señales de voz limpias.
MuestraRuidosa_1 = ADICION_RUIDO(MuestraLimpia_1, ruido);
MuestraRuidosa_2 = ADICION_RUIDO(MuestraLimpia_2, ruido);
MuestraRuidosa_4 = ADICION_RUIDO(MuestraLimpia_4, ruido);
MuestraRuidosa_5 = ADICION_RUIDO(MuestraLimpia_5, ruido);

% Prueba de escucha.
% sound(MuestraRuidosa_1, fs)

% Prueba de ploteo de señal de voz limpia y señal de voz con ruido añadido.
% t = (1/fs)*(0:numel(MuestraLimpia_1) - 1);
% 
% figure(1)
% tiledlayout(2,1)
% 
% nexttile
% plot(t,MuestraLimpia_1)
% title("Muestra Limpia 1")
% grid on
% 
% nexttile
% plot(t,MuestraRuidosa_1)
% title("Muestra Ruidosa 1")
% xlabel("Time (s)")
% grid on

%%%%%%%%%%%%%%%%%%%% IMPORTACIÓN DE LA BASE DE DATOS %%%%%%%%%%%%%%%%%%%%%%

% Descarga y descompresión del zip que contiene grabaciones de frases cortas 
% con una frecuencia de muestreo de 48kHz.
archivoDescargado = matlab.internal.examples.downloadSupportFile("audio", "commonvoice.zip");
carpetaDatos = tempdir;
unzip(archivoDescargado,carpetaDatos)
datos = fullfile(carpetaDatos,"commonvoice");

% Creación del "almacén" para las muestras de entrenamiento.
entrenamiento = audioDatastore(fullfile(datos,"train"),IncludeSubfolders=true);
% Para que la ejecución sea más rápida, "speedupExample" debe estar como
% "True".
velodidadEjemplo = true;
if velodidadEjemplo
    entrenamiento = shuffle(entrenamiento);
    entrenamiento = subset(entrenamiento,1:1000);
end

% Obtención del primer archivo del almacén.
[audio, infoEntrenamiento] = read(entrenamiento);

% Prueba de escucha.
% sound(audio, infoEntrenamiento.SampleRate)

% Prueba de ploteo.
% figure(2)
% t = (1/infoEntrenamiento.SampleRate) * (0:numel(audio)-1);
% plot(t,audio)
% title("Ejemplo de señal de voz")
% xlabel("Time (s)")
% grid on

%%%%%%%%%%%%%%%%%%%%% CÓMO FUNCIONA LA RED NEURONAL %%%%%%%%%%%%%%%%%%%%%%%

% Se pasa la señal de audio del dominio del tiempo al dominio de la
% frecuencia usando el STFT (Short Time Fourier Transform), consiguiendo
% con ello lo que se conoce como espectrograma. Este espectrograma muestra
% la frecuencia vs el tiempo. 

%%%%%%%%%%%%%%%%%%%%%%%%% APLICACIÓN DE LA STFT %%%%%%%%%%%%%%%%%%%%%%%%%%%

% La STFT se va a aplicar con una ventana de longitud de 256 muestras y una
% superposición del 75% (tipo Hamming), lo que da como resultado un vector
% espectral de tamaño 129 x 8, eliminando con esto las muestras que
% corresponden a frecuencias negativas. Al aplicar el solape, la STFT final
% será calculada en función de la STFT actual y las 7 anteriores.

%%%%%%%%%%% Obtención de los objetivos y predictores de la STFT %%%%%%%%%%%

% Definición de los parámetros del sistema.
tamanioVentana = 256;
tipoVentana = hamming(tamanioVentana,"periodic");
solape = round(0.75*tamanioVentana);
tamanioFFT = tamanioVentana;
numCaracteristicas = tamanioFFT/2 + 1;
numSegmentos = 8;

% Importación del audio del "almacén" de entrenamiento.
audio = read(entrenamiento);

% Hay que asegurarse de que la longitud del audio es múltiplo del factor de
% diezmado de la frecuencia de muestreo (8kHz).
factorDiezmado = fsEntrada/fs;
L = floor(numel(audio)/factorDiezmado);
audio = audio(1:factorDiezmado*L);

% Cambio en la frecuencia de muestreo, de 48kHz a 8kHz.
audio = src(audio);
reset(src)

% Adición del ruido a la señal de audio de entrenamiento.
% Extracción de un segmento de la señal de ruido en un momento
% aleatorio.
randind = randi(numel(ruido) - numel(audio) + [1,1]);
segmentoRuido = ruido(randind:randind + numel(audio) - 1);
% Cálculo de la energía de la señal limpia.
energiaSenialLimpia = sum(audio.^2);
% Cálculo de la energía de la señal de ruido.
energiaRuido = sum(segmentoRuido.^2);
% Adición del ruido a la señal limpia.
segmentoRuido = segmentoRuido.*sqrt(energiaSenialLimpia/energiaRuido);
audioRuidoso = audio + segmentoRuido;

% Prueba de escucha.
% sound(audioRuidoso, infoEntrenamiento.SampleRate)

% Obtención de los vectores STFT a partir de los audios originales y
% ruidosos.
STFTlimpia = stft(audio, Window=tipoVentana, OverlapLength=solape, fftLength=tamanioFFT);
STFTlimpia = abs(STFTlimpia(numCaracteristicas-1:end,:));
STFTruidosa = stft(audioRuidoso, Window=tipoVentana, OverlapLength=solape, fftLength=tamanioFFT);
STFTruidosa = abs(STFTruidosa(numCaracteristicas-1:end,:));

% Generación de los 8 segmentos de las señales de entrenamiento de la STFT
% ruidosa, siendo el solape de 7 segmentos.
STFTruidosa = [STFTruidosa(:,1:numSegmentos - 1), STFTruidosa];
segmentosSTFT = zeros(numCaracteristicas, numSegmentos, size(STFTruidosa, 2) - numSegmentos + 1);
for index = 1:size(STFTruidosa, 2) - numSegmentos + 1
    segmentosSTFT(:,:,index) = STFTruidosa(:, index:index + numSegmentos - 1); 
end

% Establecimiento de los parámetros. La última dimensión de cada una de las
% variables corresponde al número de pares (predictor-objetivo) generados
% a partir de la señal de audio. El predictor tiene un tamaño de 129x8 y el
% objetivo 129x1.
objetivos = STFTlimpia;

% Comprobación del tamaño de los objetivos.
% size(objetivos)

predictores = segmentosSTFT;

% Comprobación del tamaño de los predictores.
% size(predictores)

%%%%%%%%%%%%% Extracción de las características usando Arrays %%%%%%%%%%%%%

% Para acelerar el proceso de ejecución, se extraen las características de
% los segmentos de las señales de voz del "almacén" de datos usando "arrays
% grandes". La diferencia entre "arrays de memoria" y los "arrays grandes"
% es que los "arrays grandes" normalmente permanecen sin evaluar hasta que
% la función se ejecuta, lo que permite trabajar con grandes conjuntos de
% datos de forma más rápida. Cuando se solicita la ejecución, Matlab
% combina los cálculos que tiene pendientes y usa la cantidad mínima de
% "pasadas" por los datos.

% Conversión del "almacén" de datos en un "array grande".
reset(entrenamiento)
% Al ejecutar la siguiente línea, se muestra en la ventana de comandos el
% número de filas, el cual corresponde al nímero de archivos que se tienen
% en el "almacén" de datos. M todavía no se conoce hasta que no se 
% completen los cálculos, tan solo es un marcador de posición.
T = tall(entrenamiento)

% Extracción de la magnitud STFT del objetivo y del predictor en el "array
% grande". Con esto se crean nuevas variables en el "array grande" para
% usar en cálculos posteriores.
% La función "HelperGenerateSpeechDenoisingFeatures" realiza los pasos ya
% comentados anteriormente en la sección "Obtención de los objetivos y 
% predictores de la STFT".
% El comando "cellfun" aplica "HelperGenerateSpeechDenoisingFeatures" a
% cada uno de los archivos de audio que se encuentran en el "almacén" de
% datos.
[objetivos, predictores] = cellfun(@(x)HelperGenerateSpeechDenoisingFeatures(x, ruido, src), T, UniformOutput=false);

% Evaluación de los objetivos y predictores.
[objetivos, predictores] = gather(objetivos, predictores);

% Normalización de los datos para obtener una media 0 y una desviación
% estandar de valor 1.
predictores = cat(3, predictores{:});
mediaRuido = mean(predictores(:));
desviacionRuido = std(predictores(:));
predictores(:) = (predictores(:) - mediaRuido)/desviacionRuido;

objetivos = cat(2, objetivos{:});
mediaLimpia = mean(objetivos(:));
desviacionLimpia = std(objetivos(:));
objetivos(:) = (objetivos(:) - mediaLimpia)/desviacionLimpia;

% Reajuste de los tamaños de los predictoresy objetivos con respecto a los
% esperados por las redes de aprendizaje profundo.
predictores = reshape(predictores, size(predictores, 1), size(predictores, 2), 1, size(predictores, 3));
objetivos = reshape(objetivos, 1, 1, size(objetivos, 1), size(objetivos, 2));

% Tan solo se usa el 1% de los datos de validación durante el
% entrenamiento, siendo esta útil para detectar escenarios en los que la
% red ha sufrido una sobreadaptación para estos datos de entrenamiento.

% División de manera aleatoria de los datos en el bloque de entrenamiento 
% y el de validación
inds = randperm(size(predictores,4));
L = round(0.99*size(predictores,4));

predictoresEntrenamiento = predictores(:,:,:,inds(1:L));
objetivosEntrenamiento = objetivos(:,:,:,inds(1:L));

predictoresValidados = predictores(:,:,:,inds(L+1:end));
objetivosValidados = objetivos(:,:,:,inds(L+1:end));

%%%%%%%%%%%%%%%%%%%%%%%% RED FULLY CONNECTED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Una red con capas totalmente conectadas, implica que cada neurona dentro
% de esa capa está conectada a las activaciones en la capa anterior. En 
% este tipo de redes, la entrada es multiplicada por una matriz de pesos, y
% más adelante se agrega un vector de sesgo. Las dimensiones de la matriz
% de pesos y del vector de sesgo están determinadas por el número de
% neuronas en cada capa y por el número de activaciones de la capa
% anterior.

% Definición de las capas de la red, tamaño de la entrada 
% (numeroCaracteristicas x numeroSegmentos = 129x8), número de capas
% ocultas que estarán completamente conectadas, con el número de neuronas
% en cada una (1024). 
% Como los sistemas son lineales, después de cada capa oculta completamente
% conectada, se introducirá una capa de Unidad lineal rectificada (ReLU).
% Estas capas normalizan, por lotes, las medias y las desviaciones típicas
% de las salidas. También hay que agregar una capa completamente conectada
% con 129 neuronas seguida de una capa ReLU.
capas = [
    imageInputLayer([numCaracteristicas,numSegmentos])
    fullyConnectedLayer(1024)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(1024)
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(numCaracteristicas)
    regressionLayer
    ];

% Espeficicación de las opciones de entrenamiento para la red. 
%"MiniBatchSize" (número de señales de entrenamiento que se se verán a la 
% vez) en 128.
miniBatchSize = 128; 
%"MaxEpochs" (número de pasadas a través de los datos de 
% entrenamiento) en 3; ; "Plots" como "training-progress" para
% generar los gráficos que muestran en progreso de entrenamiento a medida
% que aumenta el número de iteraciones; "Verbose" como falso para
% deshabilitar la impresión de la salida de la tabla que corresponde a los
% datos que se muestran en el gráfico en la ventana de línea de comandos;
% "Shuffle" como "every-epoch" para mezclar las secuencias de entrenamiento
% al comienzo de cada época; "LearnRateSchedule" como "piecewise" para
% disminuir la tasa de aprendizaje en un factor específico (0.9) cada vez
% que haya pasado por una determinada cantidad de épocas (1);
% "ValidationData" de los predictores y objetivos de validación;
% "ValidationFrecuency" de modo que el error cuadrático medio de validación
% se calcule un vez por época (en este caso, se usa el solucionador de
% estimación de momento adaptativo o Adam).
opciones = trainingOptions("adam", ...
    MaxEpochs=3, ...
    InitialLearnRate=1e-5,...
    MiniBatchSize=miniBatchSize, ...
    Shuffle="every-epoch", ...
    Plots="training-progress", ...
    Verbose=false, ...
    ValidationFrequency=floor(size(predictoresEntrenamiento,4)/miniBatchSize), ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.9, ...
    LearnRateDropPeriod=1, ...
    ValidationData={predictoresValidados,objetivosValidados});    

% Entrenamiento de la red con las opciones especificadas y la arquitectura
% de capas que usa "trainNetwork". Si se quiere descargar una red neuronal
% ya entrenada (ya que entrenar una lleva mucho tiempo), hay que poner
% "downloadPretainedSystem" como "true".
downloadPretrainedSystem = false;
if downloadPretrainedSystem
    archivoDescargado = matlab.internal.examples.downloadSupportFile("audio","SpeechDenoising.zip");
    carpetaDatos = tempdir;
    unzip(archivoDescargado, carpetaDatos)
    carpetaRed = fullfile(carpetaDatos, "SpeechDenoising");
    s = load(fullfile(carpetaRed, "denoisenet.mat"));
    redFullyConnectedEliminacionRuido = s.denoiseNetFullyConnected;
    mediaLimpia = s.cleanMean;
    desviacionLimpia = s.cleanStd;
    mediaRuido = s.noisyMean;
    desviacionRuido = s.noisyStd;
else
    redFullyConnectedEliminacionRuido = trainNetwork(predictoresEntrenamiento, objetivosEntrenamiento, capas, opciones);
end

% Conteo del número de pesos de las capas de la red fully connected.
numPesos = 0;
for index = 1:numel(redFullyConnectedEliminacionRuido.Layers)
    if isa(redFullyConnectedEliminacionRuido.Layers(index),"nnet.cnn.layer.FullyConnectedLayer")
        numPesos = numPesos + numel(redFullyConnectedEliminacionRuido.Layers(index).Weights);
    end
end
disp("Number of weights = " + numPesos);

%%%%%%%%%%%%%%%%%%% RED CON CAPAS CONVOLUCIONALES %%%%%%%%%%%%%%%%%%%%%%%%%

% Una red con capas convolucionales 2-D aplica filtros deslizantes a la
% capa de entrada. La convolución se realiza moviendo los filtros de forma
% vertical y horizontal a lo largo de la entrada, calculando el producto
% escalar de los pesos, y agregando un término de sesgo. Las capas
% convolucionales constan de menos parámetros que las de las redes fully
% connected.

% Definición de las 16 capas de la red convolucional. Las 15 primeras capas
% se agrupan en 3 capas repetidas 5 veces, con anchos de filtro de 9, 5 y
% 9; y número de filtros de 18, 30 y 8. La última capa tiene un ancho de
% filtro de 129. En esta red, las convoluciones se realizan en una sola
% dirección (a lo largo de una dimensión de frecuencia), y se establece el
% ancho del filtro a lo largo de la dimensión de tiempo en 1 (excepto en la
% primera capa). Las capas son seguidas por ReLU y capas de normalización 
% por lotes.
capas = [imageInputLayer([numCaracteristicas,numSegmentos])
          convolution2dLayer([9 8], 18, Stride=[1 100], Padding="same")
          batchNormalizationLayer
          reluLayer
          
          repmat( ...
          [convolution2dLayer([5 1], 30, Stride=[1 100], Padding="same")
          batchNormalizationLayer
          reluLayer
          convolution2dLayer([9 1], 8, Stride=[1 100], Padding="same")
          batchNormalizationLayer
          reluLayer
          convolution2dLayer([9 1], 18, Stride=[1 100], Padding="same")
          batchNormalizationLayer
          reluLayer],4,1)
          
          convolution2dLayer([5 1], 30, Stride=[1 100], Padding="same")
          batchNormalizationLayer
          reluLayer
          convolution2dLayer([9 1], 8, Stride=[1 100], Padding="same")
          batchNormalizationLayer
          reluLayer
          
          convolution2dLayer([129 1], 1, Stride=[1 100], Padding="same")
          
          regressionLayer
          ];

% Las opciones de entrenamiento son igual que en la red fully connected a
% excepción de la dimensión de la dimensión de las señales de validación,
% que permutan para que sean consistentes con las dimensiones esperadas.
opciones = trainingOptions("adam", ...
    MaxEpochs=3, ...
    InitialLearnRate=1e-5, ...
    MiniBatchSize=miniBatchSize, ...
    Shuffle="every-epoch", ...
    Plots="training-progress", ...
    Verbose=false, ...
    ValidationFrequency=floor(size(predictoresEntrenamiento, 4)/miniBatchSize), ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropFactor=0.9, ...
    LearnRateDropPeriod=1, ...
    ValidationData={predictoresValidados, permute(objetivosValidados, [3 1 2 4])});

% Entrenamiento de la red con las opciones especificadas y la arquitectura
% de capas que usa "trainNetwork". Si se quiere descargar una red neuronal
% ya entrenada (ya que entrenar una lleva mucho tiempo), hay que poner
% "downloadPretainedSystem" como "true".
downloadPretrainedSystem = false;
if downloadPretrainedSystem
    archivoDescargado = matlab.internal.examples.downloadSupportFile("audio","SpeechDenoising.zip");
    carpetaDatos = tempdir;
    unzip(archivoDescargado, carpetaDatos)
    carpetaRed = fullfile(carpetaDatos, "SpeechDenoising");
    s = load(fullfile(carpetaRed,"denoisenet.mat"));
    redFullyConvolutionalEliminacionRuido = s.denoiseNetFullyConvolutional;
    mediaLimpia = s.cleanMean;
    desviacionLimpia = s.cleanStd;
    mediaRuido = s.noisyMean;
    desviacionRuido = s.noisyStd;
else
    redFullyConvolutionalEliminacionRuido = trainNetwork(predictoresEntrenamiento, permute(objetivosEntrenamiento, [3 1 2 4]), capas, opciones);
end

% Conteo del número de pesos de las capas de la red fully connected.
numPesos = 0;
for index = 1:numel(redFullyConvolutionalEliminacionRuido.Layers)
    if isa(redFullyConvolutionalEliminacionRuido.Layers(index),"nnet.cnn.layer.Convolution2DLayer")
        numPesos = numPesos + numel(redFullyConvolutionalEliminacionRuido.Layers(index).Weights);
    end
end
disp("Number of weights in convolutional layers = " + numPesos);

%%%%%%%%%%%%%%%%%% TESTEO DE LAS REDES NEURONALES  %%%%%%%%%%%%%%%%%%%%%%%%

% Lectura del conjunto de datos de prueba.
% MuestraLimpiaTest = MuestraLimpia_1;
% MuestraLimpiaTest = MuestraLimpia_2;
% MuestraLimpiaTest = MuestraLimpia_4;
 MuestraLimpiaTest = MuestraLimpia_5;

% Exportación de la muestra de audio limpia original.
% audiowrite('MuestraLimpiaTestOriginal_5.wav', MuestraLimpiaTest, fs);

% Importación de ruido a la muestra limpia con un audio que no se haya usando
% en la etapa de entrenamiento.
% ruido = audioread('4.2.2 - Ruido blanco.m4a');
% ruido = audioread('13 - Puerta.m4a');
ruido = audioread('14 - Musica_2.m4a');

% Hay que asegurarse de que la longitud del audio es múltiplo del factor de
% diezmado de la frecuencia de muestreo (8kHz).
L = floor(numel(ruido)/factorDiezmado);
ruido = ruido(1:factorDiezmado*L);

% Cambio en la frecuencia de muestreo, de 48kHz a 8kHz.
ruido= src(ruido);
reset(src)

% Adición del ruido a la muestra de audio limpia.
MuestraRuidosaTest = ADICION_RUIDO_TEST(MuestraLimpiaTest, ruido);

% Exportación de la muestra de audio ruidosa.
audiowrite('MuestraRuidosaMusicaTest_5.wav', MuestraRuidosaTest, fs);

% Generación de los vectores de características de la STFT de las señales 
% ruidosas.
STFTruidosa = stft(MuestraRuidosaTest, Window=tipoVentana, OverlapLength=solape, fftLength=tamanioFFT);
faseRuido = angle(STFTruidosa(numCaracteristicas-1:end,:));
STFTruidosa = abs(STFTruidosa(numCaracteristicas-1:end,:));

% Generación de las señales predictoras de entrenamiento de 8 segmentos a
% partir de la STFT ruidosa (superposición de 7 segmentos).
STFTruidosa = [STFTruidosa(:,1:numSegmentos-1) STFTruidosa];
predictores = zeros(numCaracteristicas, numSegmentos, size(STFTruidosa,2) - numSegmentos + 1);
for index = 1:(size(STFTruidosa,2) - numSegmentos + 1)
    predictores(:,:,index) = STFTruidosa(:,index:index + numSegmentos - 1); 
end

% Normalización de la media y la desviación calculadas en la etapa de entrenamiento.
predictores(:) = (predictores(:) - mediaRuido)/desviacionRuido;

% Aplicación de las dos redes neuronales creadas.
predictores = reshape(predictores,[numCaracteristicas, numSegmentos, 1, size(predictores,3)]);
STFTFullyConnected = predict(redFullyConnectedEliminacionRuido, predictores);
STFTFullyConvolutional = predict(redFullyConvolutionalEliminacionRuido, predictores);

% Escalado de las salidas en base a la media y la desviación utilizada en
% la estapa de entrenamiento.
STFTFullyConnected(:) = desviacionLimpia*STFTFullyConnected(:) + mediaLimpia;
STFTFullyConvolutional(:) = desviacionLimpia*STFTFullyConvolutional(:) + mediaLimpia;

% Centrado de la STFT en cuanto al dominio de la frecuencia se refiere.
STFTFullyConnected = (STFTFullyConnected.').*exp(1j*faseRuido);
STFTFullyConnected = [conj(STFTFullyConnected(end-1:-1:2,:));STFTFullyConnected];
STFTFullyConvolutional = squeeze(STFTFullyConvolutional).*exp(1j*faseRuido);
STFTFullyConvolutional = [conj(STFTFullyConvolutional(end-1:-1:2,:));STFTFullyConvolutional];

% Aplicación de la eliminación de ruido a las señales de voz. Se usa la
% fase del ruido de la STFT para reconstruir la señal en el dominio del
% tiempo.
audioLimpioTest_FullyConnected = istft(STFTFullyConnected, Window=tipoVentana, OverlapLength=solape, fftLength=tamanioVentana, ConjugateSymmetric=true);                       
audioLimpioTest_FullyConvolutional = istft(STFTFullyConvolutional, Window=tipoVentana, OverlapLength=solape, fftLength=tamanioVentana, ConjugateSymmetric=true);

% Exportación de la muestra de audio limpia mediante el uso de la red 
% neuronal Fully Connected.
audiowrite('MuestraLimpiaTest_FullyConnected_5.wav', audioLimpioTest_FullyConnected, fs);

% Exportación de la muestra de audio limpia mediante el uso de la red 
% neuronal Fully Convolutional.
audiowrite('MuestraLimpiaTest_FullyConvolutional_5.wav', audioLimpioTest_FullyConvolutional, fs);

% Ploteo de la señal limpia, ruidosa y limpia tras eliminar el ruido con 
% las redes neuronales.
t = (1/fs)*(0:numel(audioLimpioTest_FullyConnected)-1);

figure(3)
tiledlayout(4,1)

nexttile
plot(t, MuestraLimpiaTest(1:numel(audioLimpioTest_FullyConnected)))
title("Señal limpia")
grid on

nexttile
plot(t, MuestraRuidosaTest(1:numel(audioLimpioTest_FullyConnected)))
title("Señal ruidosa")
grid on

nexttile
plot(t, audioLimpioTest_FullyConnected)
title("Señal limpia con red neuronal Fully Connected")
grid on

nexttile
plot(t, audioLimpioTest_FullyConvolutional)
title("Señal limpia con red neuronal Convolucional")
grid on
xlabel("Time (s)")

% Ploteo de los espectros de la señal limpia, ruidosa y limpia tras 
% eliminar el ruido con las redes neuronales.
h = figure(4);
tiledlayout(4,1)

nexttile
spectrogram(MuestraLimpiaTest, tipoVentana, solape, tamanioFFT, fs);
title("Señal limpia")
grid on

nexttile
spectrogram(MuestraRuidosaTest, tipoVentana, solape, tamanioFFT, fs);
title("Noisy Speech")
grid on

nexttile
spectrogram(audioLimpioTest_FullyConnected, tipoVentana, solape, tamanioFFT, fs);
title("Señal limpia con red neuronal Fully Connected")
grid on

nexttile
spectrogram(audioLimpioTest_FullyConvolutional, tipoVentana, solape, tamanioFFT, fs);
title("Señal limpia con red neuronal Convolucional")
grid on

p = get(h,"Position");
set(h,"Position",[p(1) 65 p(3) 800]);

% Prueba de escucha del audio ruidoso.
% sound(MuestraRuidosaTest, fs)

% Prueba de escucha del audio con el ruido eliminado mediante el uso de la
% red Fully Connected.
% sound(audioLimpioTest_FullyConnected, fs)

% Prueba de escucha del audio con el ruido eliminado mediante el uso de la
% red Convolucional.
% sound(audioLimpioTest_FullyConvolutional, fs)

% % Prueba de escucha del audio limpio.
% sound(MuestraLimpiaTest, fs)
