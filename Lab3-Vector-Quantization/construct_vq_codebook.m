function [CB] = construct_vq_codebook(data, B)
% A function that computes the quantization codebook.
% INPUT:
%   data: Codebook construction data: speech_files * Nfr_i x OrderLPC
%   B: The number of bits, so 2^B will be the codebook size. 
% OUTPUT:
%   CB: A 2^B x OrderLPC matrix containing codevectors
%
% George Manos, Alexandros Angelakis
% CSD - CS578

    M = 2^B;
    e = 0.05;
    CB = (mean(data));
    dims = length(CB);
    k = 1;
    while k < M
        CB_new = zeros(2*k, dims);
        for i=1:k
            CB_low = CB(i, :) - e;
            CB_high = CB(i, :) + e;
            CB_new(2 * (i-1) + 1, :) = CB_low;
            CB_new(2 * (i-1) + 2, :) = CB_high;
        end
        k = 2 * k;
        % apply kmeans
        [~, C] = kmeans(data, k, 'Start', CB_new);
        CB = C;
    end
end