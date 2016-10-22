clc;
clear all;
close all;

 x_minucje(1,1:50) = 1;
 y_minucje(1,1:50) = 1;
 ile_minucji=30;
for palec=1:1:5
     if palec == 1
        wspt_t = 0.8; %wspolczynnik rowny threshold
        krawedz_y =150; %odl. odciecia do usuwania minucji
        krawedz_x =130;
        wsp_medfilt=10
    end
    if palec == 1
        wspt_t = 0.9; 
        krawedz_y =180; 
        krawedz_x = 130;
        wsp_medfilt=3
    elseif palec == 2
        wspt_t = 0.8;
        krawedz_y = 180;
        krawedz_x = 200;
        wsp_medfilt=3
    elseif palec == 3
        wspt_t = 0.85;
        krawedz_y = 230;    
        krawedz_x = 170;
        wsp_medfilt=3
    elseif palec == 4
        wspt_t = 0.85;
        krawedz_y = 215;    
        krawedz_x = 175;
        wsp_medfilt=4
    elseif palec == 5
        wspt_t = 0.8;
        krawedz_y = 240;    
        krawedz_x = 165;
        wsp_medfilt=4
    end


    for i=1:1:10
        mystring=['.\odciski\',num2str(palec),'(',num2str(i),')','.bmp']; %œcie¿ka do folderu z odciskami palców
         [obraz] = imread(mystring);

         idx=i+10*(palec-1)
        
         %binaryzacja
        binarny = im2bw(obraz, wspt_t);
        
        %odwrocenie kolorow
        odwrocony = imcomplement(binarny);

        se = strel('disk',1); % element strukturalny
        
        %otwarcie
        otwarcie1 = imopen(odwrocony, se);
        
        %zamkniêcie
        zamkniecie1 = imclose(otwarcie1, se);

        %filtr medianowy
        m = medfilt2(zamkniecie1, [wsp_medfilt wsp_medfilt]);

        %szkieletyzacja
        szkielet = bwmorph(m, 'skel', inf);

        %obciecie galazek
        galazki = bwmorph(szkielet, 'spur', 4);

        pojedyncze = bwmorph(galazki, 'clean', 4);

        imshow(pojedyncze);
        hold on;
        %znajdowanie minucji:
        minucje = bwmorph(pojedyncze,'branchpoints');
         nr=1;

             for k=krawedz_y:1:length(minucje(:,1))-krawedz_y
                 for s=krawedz_x:1:length(minucje(1,:))-krawedz_x
                     if ( (minucje(k,s) == 1)  )
                         x_minucje(nr,idx)=s;
                         y_minucje(nr,idx)=k;
                         nr=nr+1;
                     else
                     end
                 end
             end



        plot(x_minucje(:,idx),y_minucje(:,idx), 'ro','MarkerFaceColor','w','MarkerSize',4);
        
        %obliczenie odleg³oœci od pierwszej wykrytej minucji
        for z=1:ile_minucji
            odleglosci(z,idx)=sqrt(  (((x_minucje(1,idx))  -   (x_minucje(z,idx))).^2 ) +  (((y_minucje(z,idx))  -   (y_minucje(1,idx))).^2 ) ) ;
        end
        % iloœæ znalezionych minucji na obrazie
        ilosc_minucji = length(y_minucje(:,idx));
        % œrednia wartoœæ wspó³rzêdniej Y z wszystkich minucji
        y_mean_minucji = mean(y_minucje(:,idx));
        % œrednia wartoœæ wspó³rzêdniej X z wszystkich minucji
        x_mean_minucji = mean(x_minucje(:,idx)); 
        % wariancja wspó³rzêdnej X Minucji
        x_minucji_var = var(x_minucje(:,idx));
        % odchylenie standardowe wspó³rzêdnej X minucji
        x_minucji_std = std(x_minucje(:,idx)); 
        % wariancja wspó³rzêdnej Y Minucji
        y_minucji_var = var(y_minucje(:,idx));
        % odchylenie standardowe wspó³rzêdnej Y minucji
        y_minucji_std = std(y_minucje(:,idx));
        % œrednia odleg³oœæ od pierwszej minucji 
        sr_odl_od_1_M = mean(odleglosci(:,idx)); 
        % wariancja zbioru odleg³oœci od pierwszej minucji
        var_odl_od_1_M = var(odleglosci(:,idx)); 
        % odchylenie standardowe zbioru odleg³oœci od pierwszej minucji
        odch_odl_od_1_M = std(odleglosci(:,idx)); 
        
        %tworzenie macierzy ucz¹cej
        dane(:,idx) = [ilosc_minucji; y_mean_minucji; x_mean_minucji; x_minucji_var;y_minucji_var;y_minucji_std;x_minucje(1:ile_minucji,idx);y_minucje(1:ile_minucji,idx);sr_odl_od_1_M; var_odl_od_1_M;odch_odl_od_1_M];
        Mucz=dane;

    end
end

%NORMALIZACJA MACIERZY UCZ¥CEJ:
 for ile_param = 1: length(Mucz(:,1)) 
             maximum(ile_param) = max(Mucz(ile_param, :));
             minimum(ile_param) = min(Mucz(ile_param, :));
                  if maximum(ile_param) >= abs(minimum(ile_param))
                     dzielnik(ile_param) = maximum(ile_param); 
                  else
                     dzielnik(ile_param) = abs(minimum(ile_param));
                  end
 end
 
     for r=1:1:length(Mucz(:, 1))
         for j=1:1:length(Mucz(1, :))
         Mucz(r, j) = Mucz(r, j) / dzielnik(r);
         end
     end
 
 probki_uczace= [1:7 11:17 21:27 31:37 41:47 ];
 probki_testowe= [8:10 18:20 28:30 38:40 48:50];
 M_ucz=Mucz(:,probki_uczace);
 M_test=Mucz(:,probki_testowe);
     
liczba_probek_uczacych=7; %okreœla liczbe probek w kazdej serii
  
%DEFINIOWANIE MACIERZY CELU:
  M_cel = zeros(4, length(M_ucz(1, :)));
  kolejnosc= 1;
 for j=1:1:length(M_ucz(1, :))
           M_cel(kolejnosc,j)=1;
           if mod(j,liczba_probek_uczacych)==0
               kolejnosc=kolejnosc+1;
           end
 end
  
   %UCZENIE
   tic
   B=[0 1];
   PR=repmat(B,69,1); % 69 parametrów wejœciowych
   mnet=newff(PR,[120 5],{'tansig' 'logsig'},'traingdx'); % 120 neuronów w warstwie ukrytej i 5 w warstwie wyjêciowej
   mnet=init(mnet);
   mnet.trainParam.show=10000;
   mnet.trainParam.epochs=6000;
   mnet.trainParam.goal=0;
   mnet=train(mnet,M_ucz,M_cel);
   toc
   Pegz=M_test;
   YY=sim(mnet,Pegz);
   yyt = YY';


