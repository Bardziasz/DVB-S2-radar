
%% default dvb-s2 parameters;
dvbs2Param=dvbs2WaveformGenerator;
dvbs2Param.StreamFormat = "TS";
dvbs2Param.FECFrame = "normal";
dvbs2Param.MODCOD = 18;                % modulation type , 16APSK 2/3
dvbs2Param.DFL=getDFL(dvbs2Param.MODCOD,dvbs2Param.FECFrame);
dvbs2Param.SamplesPerSymbol = 2;
dvbs2Param.RolloffFactor=0.35;
dvbs2Param.HasPilots = true;  
dvbs2Param.MinNumPackets; 

%% message bits parameters

numFrames = 1;                       % frame count
syncBits = [0 1 0 0 0 1 1 1]';       % synchronization bits 47 HEX
pktLen = 1496;                       % UP length without synchronization bits
numPkts = dvbs2Param.MinNumPackets*numFrames;
txRawPkts = randi([0 1],pktLen,numPkts);
txPkts = [repmat(syncBits,1,numPkts); txRawPkts]; % adding sync bits to every pktLen
data = txPkts(:); 


%% simulation parameters
simParam.numFrames = 2;                               % Number of frames to be processed
simParam.chanBW = 36e6;                               % Channel bandwidth in Hertz
simParam.cfo = 3e3;                                   % Carrier frequency offset in Hertz
simParam.sco = 2;                                     % Sampling clock offset in parts
                                                       % per million
simParam.phNoiseLevel = 'Low';                        % Phase noise level provided as
                                                       % "Low", "Medium", or "High"
simParam.EsNodB = 30;                                 % Energy per symbol to noise ratio in decibels
                      

%% object parameters, currently not used
target.positions = [[1200; 1600; 0],[3543.63; 0; 0],[1600; 0; 1200]];
target.velocities = [[60; 80; 0],[0;0;0],[0; 100; 0]];
target.crs = [1.3,1.7,2.1];


%% structure of arrays for waveform samples and simulation results

wave = repmat(struct(...
    'wave_tx', [], ...
    'wave_awgn', [], ...
    'wave_target_awgn', [], ...
    'param', [], ...
    'ber', [], ...
    'Rsymb',[], ...
    'Fsamp', []),1,50);

%% generation of multiple signals with default dvb-s2 parameters
for k = 1:50
    wave(k).param = dvbs2WaveformGenerator;
    wave(k).param.StreamFormat = "TS";
    wave(k).param.FECFrame = "normal";
    wave(k).param.MODCOD = 18;
    wave(k).param.DFL = getDFL(wave(k).param.MODCOD,wave(k).param.FECFrame);
    wave(k).param.SamplesPerSymbol = 2;
    wave(k).param.RolloffFactor = 0.35;
    wave(k).param.HasPilots = true;
    wave(k).param.MinNumPackets;
    wave(k).Rsymb = simParam.chanBW/(1 + wave(k).param.RolloffFactor);
    wave(k).Fsamp = wave(k).Rsymb*wave(k).param.SamplesPerSymbol;

end



%% definition of waveforms with edition of specific parameters

