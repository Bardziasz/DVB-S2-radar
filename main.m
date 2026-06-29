parameters;

%% signal generation

waveform = dvbs2Param(data); % generate the signal
waveform_noise=awgn_channel(waveform); % awgn channel
sps = dvbs2Param.SamplesPerSymbol;


%% Transmitted signal constellation plot

txConst = comm.ConstellationDiagram(Title = "Transmitted data_ref", ...
ShowReferenceConstellation = false, ...
SamplesPerSymbol = sps, ...
NumInputPorts=2, ...
ChannelNames = {"Receiver", "Transmitter"});
plHeaderLen=90*sps;
txConst(waveform(plHeaderLen+1:end),waveform_noise(plHeaderLen+1:end)) 
%txConst((1:rxParams_ref.plFrameSize*sps),txOut_ref(1:rxParams_ref.plFrameSize*sps)) 


%% Transmitted and received signal spectrum visualization
Rsymb = simParam.chanBW/(1 + dvbs2Param.RolloffFactor);
Fsamp = Rsymb*simParam.sps;
specAn = spectrumAnalyzer(SampleRate = Fsamp, ...
    ChannelNames = ["Transmitted waveform" "Received waveform"], ...
    ShowLegend = true);
specAn([waveform,waveform_noise]);








