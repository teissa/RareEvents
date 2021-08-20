function ps_ = logist_val(fits, data)
% function ps_ = logist_val_tahra(fits, data)
%
% Uses the logistic model to compute p (probability of
% making a particular decision) for the given data (m rows
% of trials x n columns of data categories) and parameters
% (nx1). Assumes logit(p) (that is, ln(p/(1-p)) is a linear
% function of the data.
% fits(end) is upper AND lower asymptote (lapse rate) described
% by Abbott's law (see Strasburger 2001, or Finney 1974)

% mxn times nx1 gives mx1
ps_ = fits(end) + (1 - 2*fits(end))./(1+exp(-(data.*fits(1)-fits(1)*fits(2))));
