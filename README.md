# RareEvents
Code and de-identified behavioral dataset associated with Eissa et al. "Suboptimal human inference inverts the bias-variance trade-off for decisions with asymmetric evidence" (2021) doi: https://doi.org/10.1101/2020.12.06.413591. Human task was preregistred on Open Science Framework (10.17605/OSF.IO/J9XET). 

Functions ending in "Model" create responses using the specified model type. Functions ending in "Fit" perform model fitting for a particular model. Bayesian models require an informed prior based on pilot studies (provided as informedPrior). 

Observations and responses from each model can be built using the "SyntheticDataGenerator". Model fitting procedures can be found in "syntheticDataFits" and uses data produced from "SyntheticDataGenerator".

An example of the epirical mutual information computation is listed under "MIempiricalExample" and runs for both MI using observations of a given trial as well as including the previous trial. Bounds can be computed using "MIbound".

Examples for the psychometric curves and bias, variance, noise metrics is given in "PsychometricExample".

Anonymized subject responses and task information are contained in "AnonymizedTaskData". For each of the 201 subjects, all recorded prompts and key presses were divided by relevant information: 1) "Blocks" identified the task block each key stroke is associated with. 0=Control, 1=Hard Asymmetric, 2= Hard Symmetric, 3=Easy Asymmetric, 4= Easy Symmetric. Prompts and directions are labeld as "nan"; 2) "Balls" identifies the particular sample of ball draws that were observed for a given trial, with -1=blue balls and 1=red balls. The common/ rare ball color was randomly selected for each subject. Subjects with rare red balls are listed in "RedRare" while subjects with rare blue balls are listed in "BlueRare"; 3) "Jar" lists the true jar for each trial; 4)"Responses" list the subject's response on each trial. All human data was analyzed using the same model fitting, mutual information, and psychometric function procedures as with synthetic data above. 

Data and codes for each (non-schematized) figure panel are provided. Data is saved as "DataFig#Panel" and corresponds with Fig#Panel.m codes.  
