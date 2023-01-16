function [q] = vector_quantization(data, codebook)
% A function that uses the precomputed codebook to compute the quantized
% value of the input data.
% INPUT:
%   data: 1xOrderLPC vector to quantize
%   codebook: A cell containing 2^B codevectors sized 1xOrderLPC
% OUTPUT:
%   q: data vector quantized
q = data;

end