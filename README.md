# Bachelorarbeit
Untersuchung zum Einfluss des Elektrodenmaterials auf die Signalqualität und Lebensdauer von intrakortikalen Mikroelektroden; Uni Bremen; 04.10.2019

Zum Auslesen der Daten wird der Software MatLab (Mathworks Inc, MA) benötigt.

Alle hochgeladenen Dateien müssen sich im aktuellen Pfad vom Matlab befinden.

Als erstes der Code "PlotAllChannels" ausführen um die Einstellung der Sonde zu laden
und die Daten auszulesen. Zum Berechnen der Korrelation soll zusätzlich der Code
"Korrelation" ausgeführt werden. Zur Überprüfung der Korrelation wird der Code
"Check_korrelation" benötigt.

Für die Auswertung der gemessenen Daten muss als erstes der Code "setup" ausgeführt
werden. Nachfolgend soll der Code "find_peaks" laufen, welcher unterschiedliche Funktionen
abruft, die neuronale Ereignisse überprüfen und Aktionspotentiale finden. Schließlich
soll der Code "doclustersutting" ausgeführt werden, welcher die Berechnungen für die
SNR Auswertung automatisch durchführt.
