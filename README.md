# Bioconvection
This repository contains the baseline code for the simulations and necessary data to reproduce figures 3- 4. Files **1920.vtk are the final state files for T = 2400 s with pr = 25 (output frequency every pr steps).

# Contents of this repo:
```
.
├── FigureScripts/
│   ├── BE_figTools/
│   ├── Figure_AspectEnergy.m
│   ├── Figure_VortexAspect.m
│   ├── bestPolyOrder.m
│   └── loaddata.m
├── ExampleSimulation/
│   ├── bioconvection_Rect_L2H16.edp
│   └── SaveVTK2d.edp
└── data/
    ├── rectangle/
    │   ├── n40_dt5e2_L16H2
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L2H16
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L2rt2H8rt2
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L4H8
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L4rt2H4rt2
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L8H4
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   └── n40_dt5e2_L8rt2H2rt2
    │       ├── conc1920.vtk
    │       ├── energy.txt
    │       └── fluid1920.vtk
    ├── trapezoid
    │   ├── n40_dt5e2_L16H3
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L2H24
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L2rt2H12rt2
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L4H12
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L4rt2H6rt2
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   ├── n40_dt5e2_L8H6
    │   │   ├── conc1920.vtk
    │   │   ├── energy.txt
    │   │   └── fluid1920.vtk
    │   └── n40_dt5e2_L8rt2H3rt2
    │       ├── conc1920.vtk
    │       ├── energy.txt
    │       └── fluid1920.vtk
    └── triangle
        ├── n40_dt5e2_L16H4
        │   ├── conc1920.vtk
        │   ├── energy.txt
        │   └── fluid1920.vtk
        ├── n40_dt5e2_L2H32
        │   ├── conc1920.vtk
        │   ├── energy.txt
        │   └── fluid1920.vtk
        ├── n40_dt5e2_L2rt2H16rt2
        │   ├── conc1920.vtk
        │   ├── energy.txt
        │   └── fluid1920.vtk
        ├── n40_dt5e2_L4H16
        │   ├── conc1920.vtk
        │   ├── energy.txt
        │   └── fluid1920.vtk
        ├── n40_dt5e2_L4rt2H8rt2
        │   ├── conc1920.vtk
        │   ├── energy.txt
        │   └── fluid1920.vtk
        ├── n40_dt5e2_L8H8
        │   ├── conc1920.vtk
        │   ├── energy.txt
        │   └── fluid1920.vtk
        └── n40_dt5e2_L8rt2H4rt2
            ├── conc1920.vtk
            ├── energy.txt
            └── fluid1920.vtk
```

# Running a simulation
A 2D FreeFEM++ simulation of gravitational bioconvection (incompressible, viscous Navier–Stokes flow coupled to a micro-organism concentration transport equation) on an example rectangular domain (L=2, height H=16. Results saved as VTK files for ParaView via SaveVTK2d.edp as well as two .txt files with internal calculations (energy.txt - kinetic and potential energy over time, nondim.txt - non dimensional calculations, not included as this is not needed for plotting)

## To run example code: 
bioconvection_Rect_L2H16.edp	Main driver: builds mesh, defines the fluid (FluidBE) and transport (TransportBE) variational problems, runs the time loop, computes diagnostics (energy, Reynolds/Rayleigh/Nusselt numbers, etc.), and saves/reloads state for restarts.
SaveVTK2d.edp	Helper postproc2D function, included by the main script, that writes pressure + velocity fields on the mesh to a legacy ASCII .vtk file.

From a terminal, in the directory containing both .edp files:

FreeFem++ bioconvection_Rect_L2H16.edp

Note on some installs the binary is freefem++ lowercase, or FreeFem++-nw for a no-window/headless run — useful on a remote server with no displa

The script runs to completion on its own — no interactive input is required in its current form (the plot(Th, wait=1) line is commented out, if uncommented then mesh constructed will be displayed).

## Requirements
FreeFEM++ (.edp scripts, P1, P1b finite elements). Install from https://freefem.org/ or via package manager with brew install.

(Optional) ParaView to view the .vtk files produced during the run.

## Output (files written to the working directory, where = "./")
energy.txt — time, total mass, kinetic energy (KE), potential energy (PE).
nondim.txt — time and non-dimensional numbers (Urms, Re, Sc, PeFlow, PeSwim, Gr, Ra, Nu_eff, deltaC).
avg.txt — final time, average sub-iteration count, average timestep.
fluid<br>.vtk — velocity + pressure snapshots (open in ParaView).
conc<br>.vtk — concentration snapshots (open in ParaView).
meshTfin2400.msh, stateTfin2400.txt — mesh + state checkpoint for restart.


# Figure Reproduction
Code for figures 3 and 4 are produced using MATALB given in /FigureScripts. Data is provided with in the file or in /data.
### Figure 3:
Figure_VortexAspect.m, relies on bestPolyOrder.m and BE_figTools/
### Figure 4: 
Figure_AspectEnergy.m, relies on loaddata.m and BE_figTools/

