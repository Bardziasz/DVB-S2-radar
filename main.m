parameters;

%% signal generation

waveform_tx = dvbs2Param(data); % generate the signal
waveform_awgn=awgn_channel(waveform_tx); % awgn channel
waveform_rx=receiver(waveform_awgn);
sps = dvbs2Param.SamplesPerSymbol;


%% Transmitted and received signal constellation plot

txConst = comm.ConstellationDiagram(Title = "constellation", ...
ShowReferenceConstellation = false, ...
SamplesPerSymbol = sps, ...
NumInputPorts=3, ...
ChannelNames = {"Receiver", "Transmitter"});
plHeaderLen=90*sps;
txConst(waveform_tx(plHeaderLen+1:end),waveform_awgn(plHeaderLen+1:end),waveform_rx(plHeaderLen+1:end)) 
%txConst((1:rxParams_ref.plFrameSize*sps),txOut_ref(1:rxParams_ref.plFrameSize*sps)) 


%% Transmitted and received signal spectrum visualization
Rsymb = simParam.chanBW/(1 + dvbs2Param.RolloffFactor);
Fsamp = Rsymb*simParam.sps;
specAn = spectrumAnalyzer(SampleRate = Fsamp, ...
    ChannelNames = ["Transmitted waveform" "Received waveform"], ...
    ShowLegend = true);
specAn([waveform_tx,waveform_awgn,waveform_rx]);








