###################################################################
# R-CODE FÜR "HIER DEN TITEL DES R-SKRIPTES EINFÜGEN"
# "DATUM EINFÜGEN"
# "AUTOR ODER URSPRUNGS_URL EINFÜGEN"
###################################################################
rm(list=ls()) # hier wird alles aus dem Environment gelöscht
# wichtig, da alte Dateien die folgenden Berechnungen stören könnten

# # -----------------------------------------------------------------------


# Working Directory setzen
setwd("PFAD_EINFÜGEN")

# Packages laden
library(ggplot2)


# Mein erstes Skript ------------------------------------------------------


# Soil-Daten einlesen
soil <- read.table("PFAD_EINFÜGEN", header=T, sep=";", dec=".")


# Meine ersten Berechnungen -----------------------------------------------

from
https://rlab.blogs.uni-hamburg.de/dig-skripte/Tipps_und_Tricks/index.html?s=Das%20perfekte%20R-Skript
