function err_ = logist_err(ps, choices)
% function err_ = logist_err_tahra(ps, choices)
% 
%  GS - for GlobalSearch
%	Computes the negative of the log likelihood of obtaining Data 
%    in the global arrays given a logistic model with
%    parameters in vector Xs.
%	The data is sent in as a global variable (Data) and is in columns 
%    such that Data(:,1) is ones (which must be
%    specified; they represent a bias); Data(:,[2:end-1]) are the values 
%    (linear coefficients) for the other observed variables; Data(:,m) 
%	  is a 1 (correct) or a 0 (incorrect).
%
%  Input: predicted ps, actual choices
%
%	Returns: err_, which is -log likelihood

% Avoid log 0
TINY = 0.0001;
ps(ps==0) = TINY;
ps(ps==1) = 1 - TINY;

% Now calculate the joint probability of obtaining the data set conceived as
%   a list of Bernoulli trials.  This is just ps for trials = 1 (correct) and
%   1-ps for trials of 0 (error).
% Note that fmincon searches for minimum, which
%   is why we send the negatve of logL
err_ = -sum(log([ps(choices==1); 1-ps(choices==0)]));
