function fits_ = logist_fit(data)

% NEW USING GLOBALSEARCH   
% Define the error function
errFcn = @(fits) logist_err_tahra(logist_val_tahra(fits', data(:,1:end-1)), data(:,end));

% Set up the optimization problem
problem = createOptimProblem('fmincon',    ...
   'objective',   errFcn,        ... % Use the objective function
   'x0',          [  1   0 0.001],   ... % Initial conditions
   'lb',          [-10 -10 0.0001],   ... % Parameter lower bounds
   'ub',          [ 10  10 0.01],   ... % Parameter upper bounds
   'options',     optimoptions(@fmincon,    ... % "function minimization with constraints"
   'Algorithm',   'active-set',  ...
   'MaxIter',     3000,          ...
   'MaxFunEvals', 3000));

% Create a GlobalSearch object
gs = GlobalSearch;
   
% Run it, returning the best-fitting parameter values and the negative-
% log-likelihood returned by the objective function
fits_ = run(gs,problem);