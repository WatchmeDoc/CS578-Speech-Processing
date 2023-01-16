function [CB] = construct_vq_codebook(data, B)
% A function that computes the quantization codebook.
% INPUT:
%   data: Codebook construction data:
%          array sized (#Speechfiles * Nfr) x OrderLpc
%   B: The number of bits, so 2^B will be the codebook size. 
% OUTPUT:
%   CB: A Codebook cell that contains 2^B vectors, each sized 1xOrderLPC
CB = data;

end