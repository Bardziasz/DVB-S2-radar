parameters;

%% signal generation

for i=1:2
    wave(i).wave_tx = wave(i).param(data); % generate the signal
    wave(i).wave_awgn=awgn_channel(wave(i).wave_tx); % awgn channel
    
end
sps = wave(1).param.SamplesPerSymbol;


%% Transmitted and received signal constellation plot

txConst = comm.ConstellationDiagram(Title = "constellation", ...
ShowReferenceConstellation = false, ...
SamplesPerSymbol = sps, ...
NumInputPorts=2, ...
ChannelNames = {"Receiver", "Transmitter"});
plHeaderLen=90*sps;
txConst(wave(1).wave_tx(plHeaderLen+1:end),wave(2).wave_tx(plHeaderLen+1:end)) 



%% Transmitted and received signal spectrum visualization
Rsymb = simParam.chanBW/(1 + dvbs2Param.RolloffFactor);
Fsamp = Rsymb*simParam.sps;
specAn = spectrumAnalyzer(SampleRate = Fsamp, ...
    ChannelNames = ["Transmitted waveform" "Received waveform"], ...
    ShowLegend = true);
specAn([wave(1).wave_tx,wave(2).wave_tx]);








