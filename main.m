parameters;

%% signal generation, every wave(i) is a signal with set of its own parameters

for k=1:50
    wave(k).wave_tx = wave(k).param(data); % generate the signal
    wave(k).wave_awgn=awgn_channel(wave(k).wave_tx); % awgn channel
    wave(k).wave_awgn_target=receiver_with_object(wave(k).wave_awgn);
    
end
sps = wave(1).param.SamplesPerSymbol; %sps is the same for every wave(k)


%% Transmitted and received signal constellation plot

txConst = comm.ConstellationDiagram(Title = "constellation", ...
ShowReferenceConstellation = false, ...
SamplesPerSymbol = sps, ...
NumInputPorts=4, ...
ChannelNames = {"wave_tx rollof 0.35", "wave_awgn_target  rollof 0.35","wave_tx rollof 0.20", "wave_awgn_target  rollof 0.20"});
plHeaderLen=90*sps;
txConst(wave(1).wave_tx(plHeaderLen+1:end),wave(1).wave_awgn_target(plHeaderLen+1:end),wave(2).wave_tx(plHeaderLen+1:end),wave(2).wave_awgn_target(plHeaderLen+1:end));



%% Transmitted and received signal spectrum visualization
Rsymb = simParam.chanBW/(1 + dvbs2Param.RolloffFactor);
Fsamp = Rsymb*simParam.sps;
specAn = spectrumAnalyzer(SampleRate = Fsamp, ...
    ChannelNames = ["wave_tx rollof 0.35" "wave_awgn_target  rollof 0.35" "wave_tx rollof 0.20"  "wave_awgn_target  rollof 0.20"], ...
    ShowLegend = true);
specAn([wave(1).wave_tx,wave(1).wave_awgn_target,wave(2).wave_tx,wave(2).wave_awgn_target]);








