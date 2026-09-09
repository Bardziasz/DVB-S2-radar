


function [ RVM, r, v, r_int, v_int ] = caf_fast( xx, yy, fs, fc )

% xx - input/TX signal
% yy - output/RX signal

% Global variables
    %c  speed of light, carrier frequency, sampling frequency
    %Nb  number of samples in one block/batch
    %M number of calculated xcorr coefficients
    % Nsamples  number of signal samples

% Reconstruction of transmitted carrier states XX_used from received carrier states YY_used
% ONLY FOR USED CARRIERS

% CAF PARAMETERS - like in IEEE Signal Magazine TZ Paper

  % Nx = length(xx);
  % the lowest possible Doppler frequency 
  Kfinterp = 1;                  % interpolation order of RVM map in Doppler direction, e.g. 1, 2, 3, 4 
  c  = 300e+6; 
  Kblocks = 400;
  M = 400;
  Nb = 500;
  %Nsamples = Kblocks*Nb+M;
  f0 = fs / (Nb*Kblocks);  
  
% ####################
% FAST CAF COMPUTATION
% ####################

  xx = xx( 1 : Nb*Kblocks );

  ytail = yy( Nb*Kblocks + 1 : Nb*Kblocks + M );
  yy = yy( 1 : Nb*Kblocks );

  xx = xx - mean(xx);
  yy = yy - mean(yy);  % yy = circshift( yy, 5 );

   % Formatting reference REF samples (batches in columns) 
     xx = reshape( xx, Nb, Kblocks );
     xx = [ xx( 1:Nb, : ); zeros( M, Kblocks ) ];
     XX = fft( xx, [], 1 ) / sqrt(Nb);
     XX = fftshift( XX, 1 );
  %  size( XX ),

   % Formatting surveillance SURV samples (batches in columns)  
     yy = reshape( yy(1:Nb*Kblocks), Nb, Kblocks );
     yy = [ yy; [ yy(1:M, 2:Kblocks), ytail ] ];
   % yy = [ yy; [ yy(1:M, 2:Kblocks), zeros(M,1) ] ];
     YY = fft( yy, [], 1 ) / sqrt(Nb);
     YY = fftshift( YY, 1 );
  %  size( YY ), pause

% CFR (Channel FREQUENCY Response) estimation

  H = conj(XX) .* YY;  %  for 4QAM equivalent to YY ./ XX;
% H = conj(XX) .* YY ./ conj(XX) .* XX;

% CLUTTER CANCELLATION ALGORITHM - optionally

  if( 0 )  % 1 = optional clutter removal using ECA algorithm (when CLEAN is not used)
           % 0 = no clutter removal
      kDFTclutter = [ -2.0 : 0.5 : 2.0 ];  % e.g. [0], [ -0.25, 0, 0.25 ], [ -0.5 0 0.5 ], [ -0.5, -0.25, 0, 0.25, 0.5 ], [-1:1:1], [ -0.75, -0.5 -0.25, 0, 0.25, 0.5, 0.75 ], [ -1 -0.5 0 0.5 1 ], [ -2 : 0.5 : 2 ];
      [H] = eca_plus_using_H( H, kDFTclutter );
  end    

% CFR --> CIR = Channel IMPULSE respone

  H = ifftshift( H, 1 );
  h = ifft( H, [], 1 )*sqrt(Nb);
  h = h( 1 : M+1, : );

% Range-Velocity Map (RVM) calculation from CIR

  RVM = fft( h, Kfinterp*Kblocks, 2) / sqrt( Kblocks );
  RVM = fftshift( RVM, 2 );

  r_int = (0 : M);
  r = r_int * (c*1/fs) / 1000;
  v_int = (-Kfinterp*Kblocks/2 : Kfinterp*Kblocks/2-1)*(1/Kfinterp);
  v = v_int * f0/fc*c;
  
  r_ms = r_int * (1/fs) * 1000;
  v_Hz = v_int * f0;

% Figures

  THR = -60;

  h = abs(h);
  h = h / max(max( h ));
  h = 20*log10( h );
  h( h < THR ) = THR;
  
  if(1)
     Hx = conj(XX) .* XX;
   % figure; subplot(121); mesh( 20*log10(abs(Hx)) ); title('H_{xx}(c,s) - Before ECA');
   % [Hx] = eca_plus_using_H( Hx, kDFTclutter );
   % subplot(122); mesh( 20*log10(abs(Hx)) ); title('H_{xx}(c,s) - After ECA'); pause
     Hx = ifftshift( Hx, 1 );
     hx = ifft( Hx, [], 1 )*sqrt(Nb);
     hx = hx( 1 : M+1, : );
     RVMx = fft( hx, Kfinterp*Kblocks, 2) / sqrt( Kblocks );
     RVMx = fftshift( RVMx, 2 );

  end

  RVM = abs( RVM );
  RVM = RVM / max(max(RVM));
  RVM = 20*log10( RVM );
  RVM( RVM < THR ) = THR;

  RVMx = abs( RVMx );
  RVMx = RVMx / max(max(RVMx));
  RVMx = 20*log10( RVMx );
  RVMx( RVMx < THR ) = THR;

  RVM_max = max( max( RVM) );
  RVMx_max = max( max( RVMx) );
% RVM = RVM - (RVM_max/RVMx_max) * RVMx;
% RVM = RVM - RVMx;
% [ RVM ] = eca_plus_using_H( RVM.', kDFTclutter ); RVM = abs(RVM.');


% RVM = svd_inspector( abs(RVM), v_int, r_int );

  if( 1 )
     figure;
     subplot(121); mesh( v_int, r_int, RVMx );
     plot_max_val = max(max(RVMx));
  %   caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Bistatic velocity [kDFT]');
     ylabel('Bistatic range [CIR tap number]');
     title('RVMxx - CAF based');
   % colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
  
     subplot(122); mesh( v_int, r_int, RVM );
     plot_max_val = max(max(RVM));
   %  caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Bistatic velocity [kDFT]');
     ylabel('Bistatic range [CIR tap number]');
     title('RVMxy - CAF based');
   % colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
   
     pause
  end   

  if( 0 )
     figure;
     subplot(121); imagesc( v_int, r_int, RVMx );
     plot_max_val = max(max(RVMx));
     caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Bistatic velocity [kDFT]');
     ylabel('Bistatic range [CIR tap number]');
     title('RVMxx - CAF based');
     colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
  
     subplot(122); imagesc( v_int, r_int, RVM );
     plot_max_val = max(max(RVM));
     caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Bistatic velocity [kDFT]');
     ylabel('Bistatic range [CIR tap number]');
     title('RVMxy - CAF based');
     colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
   
     pause
  end   

  if( 0 )
      figure;
      kDFT = (-Kfinterp*Kblocks/2 : Kfinterp*Kblocks/2-1)*(1/Kfinterp); d = 0:M; t = 0:Kblocks-1;
      subplot(121); mesh( t, d, h ); title('abs(h) [dB] - CAF based'); xlabel('time'); ylabel('delay');
      subplot(122); mesh( kDFT, d, RVM ); title('abs(RVM) [dB] - CAF based'); xlabel('Doppler'); ylabel('delay');
      pause
  end

  if( 0 )
     figure;
     imagesc( v_int, r_int, RVM );
     plot_max_val = max(max(RVM));
     caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Bistatic velocity [kDFT]');
     ylabel('Bistatic range [CIR tap number]');
     title('RVM - CAF based');
     colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
     pause
  end   

  if( 1 )
     figure;
     imagesc( v_Hz, r_int, RVM );
     plot_max_val = max(max(RVM));
     caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Dopper frequency shift [Hz]');
     ylabel('Delay [ms]');
     title('RVM - CAF based');
     colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
     pause
  end   

  if( 0 )
     figure;
     imagesc( v, r, RVM );
     plot_max_val = max(max(RVM));
     caxis( [ plot_max_val+THR, plot_max_val] );
     xlabel('Bistatic velocity [m/s]');
     ylabel('Bistatic range [km]');
     title('RVM - CAF based');
     colormap( fliplr(hot) );
     cb=colorbar('location','EastOutside'); set( get(cb,'Ylabel'),'String','V (dB)');
     pause
  end   

end