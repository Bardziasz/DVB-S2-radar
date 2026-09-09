
%% parametry symulacji
wave_num=10;  % liczba zbiorów danych do wygenerowania

%% parametry sprzętu
% Symulowana satelita: Eutelsat Hotbird 13C na wys. 35 777 km
fc=10.87e9;  
simParam.chanBW = 27.5e6;   %bandwidth
c=299792458;

%% parametry celów
% samolot, helikopter, dron
target.position = [10e3,300, 120]; % distance on y axis [meters]
target.angle_odb = [60, 30, 30]; % kąt widzenia obiektu przez antene ref
target.angle_sat = [30, 15, 15]; % kąt widzenia obiektu przez satelitę
target.RCS = [18,7,-15]; %dBsm
target.velocity =[236.1, 66.6, 27.7]; %[m/s]

for k=1:length(target.position)
    target.velocity_radial_odb(k)=target.velocity(k)*cosd(target.angle_odb(k)); % prędkość kątowa odb
    target.velocity_radial_sat(k)=target.velocity(k)*cosd(target.angle_sat(k)); % prędkość kątowa sat
    target.distance_odb(k) = target.position(k)/sind(target.angle_odb(k)); %dystans bezpośredni od anteny odb
    target.distance_sat(k) = target.position(k)/sind(target.angle_sat(k)); %dystans bezpośredni od sat

    target.attenuation(k)= -20; %dB    | jeszcze nie policzone z RCS
    target.attenuation_linear(k)=10^(target.attenuation(k)/20);
    
    target.doppler(k)=(target.velocity_radial_odb(k)+target.velocity_radial_sat(k))/(c/fc); % efekt dopplera z uwzględnieniem obu prędkości kątowych

end
fprintf("[Samolot helikopter dron]");
target

%% struktura tablic
wave = repmat(struct(...
    'wave_tx', [], ...
    'wave_rx', [], ...
    'wave_awgn', [], ...
    'wave_target_awgn', [], ...
    'param', [], ...
    'ber', [], ...
    'Rsymb',[], ...
    'Fsamp', []),1,10);

%% generacja sygnałów
for k = 1:wave_num
    wave(k).param = dvbs2WaveformGenerator;
    wave(k).param.StreamFormat = "TS";
    wave(k).param.FECFrame = "short";
    wave(k).param.MODCOD = 18;
    wave(k).param.DFL = getDFL(wave(k).param.MODCOD,wave(k).param.FECFrame);
    wave(k).param.SamplesPerSymbol = 5;
    wave(k).param.RolloffFactor = 0.35;
    wave(k).param.HasPilots = true;
    wave(k).param.MinNumPackets;
    wave(k).Rsymb = simParam.chanBW/(1 + wave(k).param.RolloffFactor);
    wave(k).Fsamp = wave(k).Rsymb*wave(k).param.SamplesPerSymbol;

end

fs=wave(1).Fsamp;

%% message bits parameters
numFrames = 1;                       % frame count
syncBits = [0 1 0 0 0 1 1 1]';       % synchronization bits 47 HEX
pktLen = 1496;                       % UP length without synchronization bits
numPkts = wave(k).param.MinNumPackets*numFrames;
txRawPkts = randi([0 1],pktLen,numPkts);
txPkts = [repmat(syncBits,1,numPkts); txRawPkts]; % adding sync bits to every pktLen
data = txPkts(:); 


%% definition of waveforms with edition of specific parameters

