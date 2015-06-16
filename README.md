# Voltage-Stability-Toolbox

1. INTRODUCTION

Voltage instability and collapse have become an increasing concern in planning, operation, and control of electric power systems. In order to understand the phenomena and mechanics of voltage instability,a powerful and user-friendly analysis tool is very helpful. Voltage Stability Toolbox (VST) developed at the Center for Electric Power Engineering, Drexel University combines proven computational and analytical capabilities of bifurcation theory and symbolic mplementation and graphical representation capabilities of MATLAB and its Toolboxes. It can be used to analyze voltage stability problem and provide intuitive information for power system planning, operation, and control. 

 


2. DISCLAIMER 

Permission to use, copy, modify, and distribute this software and its documentation for NON-COMMERCIAL or COMMERCIAL purposes and without fee is hereby granted, provided that any use properly credits the authors, i.e. "Voltage Stability Toolbox courtesy of Center for Electric Power Engineering, Drexel University". The authors make no representations or warranties about the suitability of the software, either express or implied, including but not limited  to the implied warranties of merchantability, fitness for a particular purpose, or non-infringement. The authors shall not be liable for any damages suffered by license as a result of using, modifying or distributing this software or its derivatives. 


3. GETTING STARTED 

3.1 SOFTWARE AND SYSTEM REQUIREMENTS

To use VST you need :

Matlab (2010a or above recommended)
Matlab Symbolic Toolbox (available from the MathWorks)
Voltage Stability Toolbox Files.
Windows or *NIX

3.2 INSTALLATION

Download vst.zip to a directory where you want to install VST. 
Unzip vst.zip. It will expand into all the M-files needed to run VST. 
Two subdirectories will also be created. One is Model directory, which stores pre-compiled executable files for IEEE3,5,14 and 30 Bus systems. 
Another is Data directory which stores IEEE common format load flow data files. 
Copy all the M-files in the VST to a location in your Matlab path
Run MATLAB (suppose Symbolic Toolbox has been installed too). 
In the MATLAB command window, typing vst_main will bring up the VST main window 

4. ANALYSIS WITH VOLTAGE STABILITY TOOLBOX 

The following analysis can be made with VST:

Load Flow Analysis
Static Bifurcation Analysis
Dynamic Bifurcation Analyis
Time Domain Simulation
Eigenvalue Analysis

4.1 HOW TO RUN LOAD FLOW

Select Model/Load to load the IEEE#_VST.dat 
Select one of the IEEE#_VST.dat file from the data folder to load the data 
Select Analysis/Load Flow/Standard NR 
Select the corresponding IEEE#.mexw32 file from the models folder 
This will bring the Load Flow Analysis window 
Reset the states values (flat start) 
Start the program to obtain load flow results 
Parameter values are the net injections at each bus 
State values are the voltage magnitudes and angles at each bus 

4.2 HOW TO RUN STATIC BIFURCATION ANALYSIS

Select Model/Load 
Select one of the IEEE#_VST.dat file in the data folder to load the data 
Select Analyis/Static Bifurcation 
Select the corresponding IEEE#.mexw32 file in the models folder 
This will bring static bifurcation  simulation interface 
Reset the sate values (flat start) 
Set search direction to (-1) for load buses to increase the power demand 
Set search direction to 1 for generator buses to increase the generation 
Start the program
The output of this simulation is the bifurcation surface(nose curve) 
Select any state variable from the slider to plot 

4.3 HOW TO RUN DYNAMIC BIFURCATION ANALYSIS

Select Model/Load 
Select one of the IEEE#_VST.dat file in the data folder to load the data 
Select Analyis/Dynamic Bifurcation 
Select the corresponding IEEE#.mexw32 file in the models folder 
This will bring dynamic bifurcation simulation interface 
Reset the sate values (flat start) 
Set search direction to (-1) for load buses to increase the power demand 
Set search direction to 1 for generator buses to increase the generation 
Start the program 
The output of this simulation is the bifurcation surface(nose curve) showing  also the 
unstable part of the nose curve 

4.4 HOW TO RUNTIME DOMAIN DYNAMIC SIMULATION ANALYSIS

Select Model/Load 
Select one of the IEEE#_VST.dat file in the data folder to load the data 
Run the dynamic bifurcation anlysis first to load the initial data for simulation 
Select Analysis/Simulation 
Select the corresponding IEEE#.mexw32 file in the IEEE.c folder 
This will bring time domain simulation window 
Select the duration of the simulation 
Choose the initial operating point for the simulation 
Run the program by pushing the Start button 
Select the generator variable to plot 

4.5 HOW TO RUN EIGENVALUE ANALYSIS

Run the dynamic bifurcation analysis
Obtain the eigenvalue location
