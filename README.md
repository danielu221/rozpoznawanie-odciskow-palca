# rozpoznawanie-odciskow-palca
Projekt inteligentnego systemu do rozpoznawania odcisków palców oparty o Matlab.
Do poprawnego działania należy poprawnie zdefiniować ścieżkę do pliku z odciskami palców:

```
mystring=['.\odciski\',num2str(palec),'(',num2str(i),')','.bmp']; %ścieżka do folderu z odciskami palców
```

Dla każdego palca należy wykonać 10 odcisków palca, z których każdy odcisk należy zapisać w formacie: 

>numer_palca(numer_odcisku).bmp, gdzie numer_palca to liczba od 1 do 5, natomiast numer_odcisku to liczba od 1 do 10.

Wszystkie analizowane odciski muszą mieć ten sam rozmiar.


Działanie programu przedstawiono w pliku **dzialanie_systemu.pdf** . 
