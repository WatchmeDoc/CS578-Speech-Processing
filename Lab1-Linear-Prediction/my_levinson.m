function a = my_levinson(r, p)
%
% INPUT:
%   corr_sig: autocorrelation of the frame
%   p: the order of LPC
% OUTPUT:
%   a: LPC coefficients in form [1, -a]
    % Initial step:
    I = zeros(p+1, p);
    E = zeros(p, 1);
    
    % Allocate k space:
    k = zeros(p, 1);
    
    k(1) = r(2)/r(1); % 1st order
    I(1,1) = k(1); % 1st order: 
    E(1) = (1 - (abs(k(1)))^2)*r(1); % 1st order
    for i=2:p
        % Step 1: Compute the partial correlation coefficients
        res = 0;
        for j=1:i-1
            res = res + I(i-1, j) * r(i-j + 1);
        end
        k(i) = (r(i + 1) - res) / E(i - 1);
        % Step 2: Update prediction coefficients, I
        I(i, i) = k(i);
        for j=1:i-1
            I(i, j) = I(i-1, j) - k(i) * I(i-1, i-j);
        end
        % Step 3: Update the minimum squared prediction error
        E(i) = (1 - k(i)^2) * E(i - 1);
    end
    % Final Step, compute the optimal predictor coefficients, I(*, j)
    a = I(p, 1:end);
    a = [1, -a];
    
    % Bale grammi 40 bkpt kai des, ta truth vars einai idia me ths
    % synarthshs levinson tis matlab, kai to plot tou excitation
    % moiazei para poli me to derivative tou excitation ton fonitikon
    % xordon. ypotheto sosto einai ayto, alla bgazei to out os complex kai
    % den mporoume na to akousoume.
    [a_truth, E_truth, k_truth] = levinson(r,p); 
    plot(E);
 end