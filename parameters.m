
%% dvb-s2 properties
dvbs2Param=dvbs2WaveformGenerator;
dvbs2Param.StreamFormat = "TS";
dvbs2Param.FECFrame = "normal";
dvbs2Param.MODCOD = 18;                % modulation type , 16APSK 2/3
dvbs2Param.DFL=getDFL(dvbs2Param.MODCOD,dvbs2Param.FECFrame);
dvbs2Param.SamplesPerSymbol = 2;
dvbs2Param.RolloffFactor=0.35;
dvbs2Param.HasPilots = true;  
dvbs2Param.MinNumPackets; 

%% bits parameters

numFrames = 5;                       % frame count
syncBits = [0 1 0 0 0 1 1 1]';       % synchronization bits 47 HEX
pktLen = 1496;                       % UP length without synchronization bits
numPkts = dvbs2Param.MinNumPackets*numFrames;
txRawPkts = randi([0 1],pktLen,numPkts);
txPkts = [repmat(syncBits,1,numPkts); txRawPkts]; % adding sync bits to every pktLen
data = txPkts(:); % changing into a column vector


%% simulation parameters
simParam.sps = dvbs2Param.SamplesPerSymbol;             % Samples per symbol
simParam.numFrames = 2;                               % Number of frames to be processed
simParam.chanBW = 36e6;                               % Channel bandwidth in Hertz
simParam.cfo = 3e3;                                   % Carrier frequency offset in Hertz
simParam.sco = 2;                                     % Sampling clock offset in parts
                                                       % per million
simParam.phNoiseLevel = 'Low';                        % Phase noise level provided as
                                                       % "Low", "Medium", or "High"
simParam.EsNodB = 30;                                 % Energy per symbol to noise ratio in decibels
                          

