# Libset (Linux) for Climate Sciences
A collection of scripts used to set up various Linux libraries needed for used in various climate sciences software and models.

1. **libset17sep2024_gnu.sh**; a script to compile all libraries frequently used in our research, e.g., HDF, netCDF, grib, CDO, NCO, GrADS, Python3, etc. Required root access. Place and run the script together with the various source codes downloaded (for Ubuntu 22.04)
2. **libset20Oct2024_gnu.sh**; a script to compile all libraries frequently used in our research, e.g., HDF, netCDF, grib, CDO, NCO, GrADS, Python3, etc. Required root access. Place and run the script together with the various source codes downloaded (for Ubuntu 24.04)
3. **libsetwrf.sh**; a script to compile common libraries needed by WRF, WPS and HRLDAS. Does not required root access (except if needing to install some dependancies needed). Place and run the script at the location you want the libraries to be compiled to.
4. **libset20Oct2024_gnu_acroporaC.sh**; a script to compile the bare minimum libraries frequently used, e.g., netCDF & CDO, in our research for machine with old/outdated compilers without having root access.

