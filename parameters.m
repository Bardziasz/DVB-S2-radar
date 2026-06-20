
%dvb-s2 properties
cfgDVBS2.MODCOD = 18;                % modulation type 
cfgDVBS2.DFL=39690;
cfgDVBS2.SamplesPerSymbol = 2;
cfgDVBS2.RolloffFactor=0.35;
cfgDVBS2.HasPilots = true;  

%simulation parameters
simParams.sps = cfgDVBS2.SamplesPerSymbol;             % Samples per symbol
simParams.numFrames = 2;                               % Number of frames to be processed
simParams.chanBW = 36e6;                               % Channel bandwidth in Hertz
simParams.cfo = 3e3;                                   % Carrier frequency offset in Hertz
simParams.sco = 2;                                     % Sampling clock offset in parts
                                                       % per million
simParams.phNoiseLevel = 'Low';                        % Phase noise level provided as
                                                       % "Low", "Medium", or "High"
simParams.EsNodB = 30;                                 % Energy per symbol to noise ratio in decibels
                          