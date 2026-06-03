function [data] = raw_data_generator(MinNumPackets)


numFrames = 1;                       % frame count
syncBits = [0 1 0 0 0 1 1 1]';       % synchronization bits 47 HEX
pktLen = 1496;                       % UP length without synchronization bits
numPkts = MinNumPackets*numFrames;
txRawPkts = randi([0 1],pktLen,numPkts);
txPkts = [repmat(syncBits,1,numPkts); txRawPkts];
data = txPkts(:);

end



