%receiver with clear line of sight
function  [wave_los]=receiver_with_los(wave_awgn)

%% Decoding the frame, not finished. No changes on the signal
[mod,codeRate,cw_len]=satcom.internal.dvbs.getS2PHYParams(wave_awgn.param.MODCOD,wave_awgn.param.FECFrame);
data_len=cw_Len/log2(mod);
slot_len=90; % each slot contains 90 symbols defined by standard
pilot_freq=16; % pilots are placed between 16 slots

bilot_blks = floor(data_len/(slot_len*pilot_freq));
pilot_len=bilot_blks*16;

frame_len=data_len+pilot_len+slot_len;

wave_los=wave_awgn;

end