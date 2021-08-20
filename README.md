# RareEvents
codes associated with Eissa et al. "Suboptimal human inference inverts the bias-variance trade-off for decisions with asymmetric evidence" (2021) doi: https://doi.org/10.1101/2020.12.06.413591. Corresponding behavioral dataset will be made available on the Open Science Framework under preregistration site 10.17605/OSF.IO/J9XET at time of manuscripte acceptance. 

Functions ending in "Model" create responses using the specified model type. Functions ending in "Fit" perform model fitting for a particular model. Bayesian models require an informed prior based on pilot studies (provided as informedPrior). 

Observations and responses from each model can be built using the "SyntheticDataGenerator". Model fitting procedures can be found in "syntheticDataFits" and uses data produced from "SyntheticDataGenerator".

An example of the epirical mutual information computation is listed under "MIempiricalExample" and runs for both MI using observations of a given trial as well as including the previous trial. Bounds can be computed using "MIbound".

Examples for the psychometric curves and bias, variance, noise metrics is given in "PsychometricExample"

