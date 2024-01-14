## Research Paper
In our research paper, we have included the following parts:

Introduction of the DOBSS algorithm, which transforms the solution of Stackelberg Security Games (SSG) from Multiple Linear Programming to Mixed Integer Linear Programming.
Implementation of the online learning algorithm "Follow the Perturbed Leader."
Verification of the theoretical properties of the FTPL algorithm.
A series of numerical experiments to validate the characteristics of the FTPL algorithm: its convergence and robustness.
## Help Document
The Help Document is designed to assist those interested in effectively using our Code Package for replicating some of the numerical experiments mentioned in our paper. The Help Document includes descriptions of the algorithms and specific examples, and offers advice for potential issues encountered when using solvers (like Gurobi) or modeling tools (like YALMIP). The main contents of the Help Document include:

Using Multiple Linear Programming to solve SSG.
Using Mixed Integer Linear Programming to solve SSG.
Principles and pseudocode of FTL and FTPL algorithms.
Random generation of Repeated SSGs, implementation of the FTPL algorithm, and verification of the sublinearity of Regret.
Design of extreme cases to implement FTL and FTPL algorithms separately, comparing the Regret of the two algorithms in extreme cases to verify the robustness of FTPL.
## Code Package
The Code Package includes all the functions required for experiments. There are separate code documents for each different algorithm and experimental verification of theoretical properties. Once the environment is properly set up, it can be run directly to replicate the experiments.
