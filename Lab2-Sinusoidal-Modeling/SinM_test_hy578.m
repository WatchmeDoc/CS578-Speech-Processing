function [ Y, SNR_by_frame ] = SinM_test(X, Fs, N, S, L, W)
%	SinM_test(X, Fs, N, S, L, W)
%
%	Sinusoidal Model test
%
%	Input Arguments:
%	X:	[(length)x1] input speech signal
%	Fs:	[1x1] sampling rate (Hz)
%	N:	[1x1] frame length (ms, default = 30)
%	S:	[1x1] analysis step (ms, default = 15)
%   L:  [1x1] number of frequencies to keep (default = 80)
%	W:	[(2N+1)x1]	the window that will be applied to the data (default = hanning(N turned to samples))
% 
% Miltos Vasilakis, 2005
% Multimedia Informatics Lab.
% Computer Science Dept.
% University of Crete
% mvasilak@csd.uoc.gr
%
if nargin < 2, error('usage SinMtest(X, Fs, N, S, L, W)'); end
if nargin < 3, N = 0.030; end % 30 ms frame size
if nargin < 4, S = 0.015; end % 15 ms frame step
if nargin < 5, L = 80; end % 80 frequencies

N = floor(N*Fs);
N = floor(N/2)*2 + 1;
S = floor(S*Fs);

if nargin < 6 || length(W) ~= N, W = hanning(N); end % hanning window

SinM = SinM_analysis(X, Fs, N, S, L, W);
[ Y, SNR_by_frame ] = SinM_synthesis_PI(SinM, N, S, Fs, X);
return

function [ SinM ] = SinM_analysis(X, Fs, N, S, L, W)
%	SinM = SinM_analysis(X, Fs, N, S, L, W)
%
%	Sinusoidal Model analysis
%
%	Input Arguments:
%	X:	[(length)x1] input speech signal
%	Fs:	[1x1] sampling rate (Hz)
%	N:	[1x1] frame length in samples (odd number)
%	S:	[1x1] analysis step (samples)
%   L:  [1x1] number of frequencies to keep (default = 80)
%	W:	[(2N+1)x1]	the window that will be applied to the data (default = hanning(N))
%
%	Output Arguments:
%	SinM:	[structure] contains the SinM parameters (one for each frame)
%			SinM.Tc:	[1x1] time index of the frame center
%			SinM.AMP:   [Lx1] amplitudes
%			SinM.PH:	[Lx1] phases
%			SinM.F:     [Lx1] frequencies
%           SinM.SNR:   [1x1] SNR of original to (original-analyzed)
if nargin < 5, L = 80; end
if nargin < 6, W = hanning(N); end
LN = length(X);
Nfr = floor((LN - N)/S) + 1; % number of frames
% analyze each frame
frame = [1 N];
SinM = struct('Tc',0,'AMP',0,'PH',0,'F',0,'SNR',0);
for fr = 1:Nfr
    Tc = mean(frame);
    SinM(fr).Tc = Tc;
    Xf = X(frame(1):frame(2));
    [ AMP, PH, F ] = SinM_analysis_frame(Xf, Fs, floor((N-1)/2), L, W);
    SinM(fr).AMP = AMP; % amplitudes
    SinM(fr).PH = PH; % phases
    SinM(fr).F = F; % corresponding frequencies
    SinM(fr).SNR = 0;
    frame  = frame + S;
end
return

function [ AMP, PH, F ] = SinM_analysis_frame(Xf, Fs, N, L, W)
%	[ AMP, PH, F ] = SinM_analysis_frame(Xf, N, Fs, L, W)
%
%	Computes the SinM parameters of a single frame
%
%	Input Arguments:
%	Xf:	[(2N+1)x1]  the speech samples from a single frame
%	Fs:	[1x1]		sampling rate
%	N:	[1x1]		the length of the frame is (2N+1) samples (centered)
%   L:  [1x1]       number of frequencies to keep (default = 80)
%	W:	[(2N+1)x1]	the window that will be applied to the data (default = hanning(2N+1))
%
%	Output Arguments:
%	AMP:[Lx1]  the sampled amplitudes
%	PH:	[Lx1]  the sampled phases
%	F:	[Lx1]  the sampled frequencies
if nargin < 4, L = 80; end
if nargin < 5, W = hanning(2*N+1); end
Wn = W ./ sum(W); % normalize window to 1
NFFT = 2048; % 2^(ceil(log2(2*N+1)));
Wf = Xf .* Wn;
Sw = zeros(NFFT, 1);
Sw(1:N+1) = Wf(N+1:2*N+1);
Sw(NFFT-N+1:NFFT) = Wf(1:N);
S_all = fft(Sw, NFFT);
S = S_all(1:NFFT/2+1);
[ FBins, AMP, PH ] = SinM_peakPicking(S, L);
F = (FBins-1)*Fs/NFFT;
return

function [ F, AMP, PH ] = SinM_peakPicking(S, L)
%   [ F AMP PH ] = SinM_peakPicking(S, L)
%
%   Returns the L highest amplitude peaks of the spectrum S, along with
%   frequency and unwraped phase
%
%	%	Input Arguments:
%	S:      [(length)x1]    input fft
%	L:      [1x1]           maximum number of highest amplitude peaks to return
%
%	Output Arguments:
%	F:	[Lx1] the sampled frequencies in bins
%	AMP:[Lx1] the sampled amplitudes
%   PH: [Lx1] the unwrapped sampled phases
F = [];
AMP = [];
PH = [];

% Insert code here:
[AMP, F] = findpeaks(S);
[AMP, locs] = maxk(AMP, L);
F = F(locs);
PH = angle(S);

return

function [ Y, SNR_by_frame ] = SinM_synthesis_PI(SinM, N, S, Fs, X)
%	[ Y SNR_by_frame ] = SinM_synthesis_PI(SinM, N, S, Fs, X)
%
%	SinM synthesis Parameter Interpolation
%
%	Input Arguments:
%	SinM:	[structure] contains the SinM parameters (one for each frame)
%			SinM.Tc:	[1x1] time index of the frame center
%			SinM.AMP:   [Lx1] amplitudes
%			SinM.PH:	[Lx1] phases
%			SinM.F:     [Lx1] frequencies
%           SinM.SNR:   [1x1] SNR of original to (original-analyzed)
%	N:	[1x1]           frame length in samples (odd number)
%	S:	[1x1]           analysis step (samples)
%	Fs:	[1x1]           sampling rate (Hz)
%	X:	[(length)x1]    the original signal, used for SNR calculation
%
%	Output Arguments:
%	Y:	[(length)x1] output speech signal
%   SNR_by_frame:   [Nfrx1] SNR by frame of original to (original-synthesized)
Nfr = length(SinM);
LN = (Nfr-1)*S+N;
Y = zeros(LN, 1);
% start -> SinM(1)
L_start = length(SinM(1).F);
S_start = floor((N-1)/2);
if L_start > 0
    Yf = SinM_synthesis_sin_PI(S_start, Fs, zeros(L_start,1), SinM(1).AMP, SinM(1).PH - (2*pi*SinM(1).F/Fs)*S_start, SinM(1).PH, SinM(1).F, SinM(1).F);
    Y(1:S_start) = Yf;
end
%
step = [S_start+1 S_start+S];
for fr = 2:Nfr
    [SinM_prev_new, SinM_curr_new] = SinM_FrameToFramePeakMatching(SinM(fr-1), SinM(fr), S, Fs);
    Yf = SinM_synthesis_sin_PI(S, Fs, SinM_prev_new.AMP, SinM_curr_new.AMP, SinM_prev_new.PH, SinM_curr_new.PH, SinM_prev_new.F, SinM_curr_new.F);
    Y(step(1):step(2)) = Yf;
    xf = X(step(1)-S:step(2));
    yf = Y(step(1)-S:step(2));
    SinM(fr-1).SNR = 20*log10(std(xf)/std(xf-yf));
    step = step + S;
end
% SinM(Nfr) -> end
L_end = length(SinM(Nfr).F);
if L_end>0
    S_end = LN - step(1) + 1;
    Yf = SinM_synthesis_sin_PI(S_end, Fs, SinM(Nfr).AMP, zeros(L_end,1), SinM(Nfr).PH, SinM(Nfr).PH + (2*pi*SinM(Nfr).F/Fs)*S_end, SinM(Nfr).F, SinM(Nfr).F);
    Y(step(1):LN) = Yf;
end
xf = X(step(1)-S:LN);
yf = Y(step(1)-S:LN);
SinM(Nfr).SNR = 20*log10(std(xf)/std(xf-yf));

SNR_by_frame = [SinM.SNR];
return

function Yf = SinM_synthesis_sin_PI(N, Fs, AMP_1, AMP_2, PH_1, PH_2, F_1, F_2)
%	Yf = SinM_synthesis_sin_PI(N, Fs, AMP_1, AMP_2, PH_1, PH_2, F_1, F_2, type)
%
%   SinM synthesis by sinusoidal Parameter Interploation.
%	Synthesizes N samples of the speech signal from the SinM parameters.
%
%	Input Arguments:
%	N:      [1x1]	the length of the (output) speech frame in samples, 
%           		usually the size of the analysis step
%	Fs:     [1x1]	sampling rate
%	AMP_1:  [Lx1]   amplitudes of the frame start (L=number of components)
%	AMP_2:  [Lx1]   amplitudes of the frame end (L=number of components)
%	PH_1:   [Lx1]   phases of the frame start (L=number of components)
%	PH_2:   [Lx1]   phases of the frame end (L=number of components)
%	F_1:	[Lx1]   frequencies of the frame start
%	F_2:	[Lx1]   frequencies of the frame end
%
%	Output Arguments:
%	Yf:	[Nx1]  the speech samples from a single frame
Yf = zeros(N,1);

%%%%%%%%%%%%%%%%%%%%%%%%%
%   INSERT CODE HERE    %
%%%%%%%%%%%%%%%%%%%%%%%%%

return

function [SinM_prev_new, SinM_curr_new] = SinM_FrameToFramePeakMatching(SinM_prev, SinM_curr, S, Fs, Delta)
%	[SinM_prev_new, SinM_curr_new] = SinM_FrameToFramePeakMatching(SinM_prev, SinM_curr, S, Fs)
%
%	Returns the frame to frame matched peaks, according to the algorithm in
%   "Speech Analysis/Synthesis Based on a Sinusoidal Representation"
%
%	Input Arguments:
%   SinM_prev:	[structure] contains the SinM parameters for the previous frame
%   SinM_curr:	[structure] contains the SinM parameters for the current frame
%   S:          [1x1] analysis step (samples)
%	Fs:         [1x1] sampling rate (Hz)
%	Delta:      [1x1] maximum allowed difference of matching peaks in Hz
%                     (default = 10);
%
%   SinM structure contains:
%			SinM.Tc:	[1x1] time index of the frame center
%			SinM.AMP:   [Lx1] amplitudes
%			SinM.PH:	[Lx1] phases
%			SinM.F:     [Lx1] frequencies
%           SinM.SNR:   [1x1] SNR of original to (original-analyzed)
%
%	Output Arguments:
%   SinM_prev_new:	[structure] contains the matched SinM parameters for the previous frame
%   SinM_curr_new:	[structure] contains the matched SinM parameters for the current frame
%
%   Note: Zeros are inserted in birth and death matchings.
if nargin<5, Delta = 10; end

L_1 = length(SinM_prev.F);
L_2 = length(SinM_curr.F);
AMP_1 = SinM_prev.AMP;
AMP_2 = SinM_curr.AMP;
PH_1 = SinM_prev.PH;
PH_2 = SinM_curr.PH;
F_1 = SinM_prev.F;
F_2 = SinM_curr.F;
I_1 = zeros(L_1, 1);
I_2 = zeros(L_2, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%
%   INSERT CODE HERE    %
%%%%%%%%%%%%%%%%%%%%%%%%%

AMP_1_new = zeros(L_new,1);
AMP_2_new = zeros(L_new,1);
PH_1_new = zeros(L_new,1);
PH_2_new = zeros(L_new,1);
F_1_new = zeros(L_new,1);
F_2_new = zeros(L_new,1);

%%%%%%%%%%%%%%%%%%%%%%%%%
%   INSERT CODE HERE    %
%%%%%%%%%%%%%%%%%%%%%%%%%

SinM_1_new = struct('Tc',0,'AMP',zeros(L_new,1),'PH',zeros(L_new,1),'F',zeros(L_new,1),'SNR',0);
SinM_1_new.Tc = SinM_prev.Tc;
SinM_1_new.AMP = AMP_1_new;
SinM_1_new.PH = PH_1_new;
SinM_1_new.F = F_1_new;
SinM_2_new = struct('Tc',0,'AMP',zeros(L_new,1),'PH',zeros(L_new,1),'F',zeros(L_new,1),'SNR',0);
SinM_2_new.Tc = SinM_curr.Tc;
SinM_2_new.AMP = AMP_2_new;
SinM_2_new.PH = PH_2_new;
SinM_2_new.F = F_2_new;

SinM_prev_new = SinM_1_new;
SinM_curr_new = SinM_2_new;
return 
