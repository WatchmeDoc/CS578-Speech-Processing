function [q] = vector_quantization(data, codebook)
% A function that uses the precomputed codebook to compute the quantized
% value of the input data.
% INPUT:
%   data: 1xOrderLPC vector to quantize
%   codebook: A 2^B x OrderLPC matrix containing codevectors
% OUTPUT:
%   q: data vector quantized
%
% George Manos, Alexandros Angelakis
% CSD - CS578

    q = codebook(1, :);
    min_distance = sqrt(sum((q - data.') .^ 2));
    for l=2:size(codebook, 1)
        new_distance = sqrt(sum((codebook(l, :) - data.') .^ 2));
        if (new_distance < min_distance)
            min_distance = new_distance;
            q = codebook(l, :);
        end
    end
end