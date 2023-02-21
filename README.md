# Bounded confidence spreading process: Simulation code
Heather Z. Brooks

This is MATLAB code to reproduce simulations and figures for *Analysis of Bounded-Confidence Spreading Processes on Networks*, Heather Z. Brooks and Mason A. Porter. arXiv preprint link to be posted.

## Files
**driver.m**: This script creates figures and saves data for expected values for total number of shares, dissemination tree width, dissemination tree longest path, and structural virality when varying parameters (message state, receptivity, number of nodes, and expected degree). Code should be run from this file. 

**fixed_message.m**: Function that runs spreading process simulation on a model network with given parameters.

**config_model.m**: Funcion that creates a realization of network using a configuration model with a given number of nodes and specified degree distribution (Poisson, exponential, geometric, k-regular).

**structural_virality.m**: Function that calculates structural virality of resulting dissemination tree.
