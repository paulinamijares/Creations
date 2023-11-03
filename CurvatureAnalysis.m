clear
clc 
clf

%Definir cordenadas
x1 = 10;    y1 = 170; %puntos iniciales
x2 = 280;   y2 = 120; %puntos finales
x3 = 30;    y3 = 200;
x4 = 160;   y4 = 100;

%Planteamiento de matriz para obtener coeficientes
pY = [y1;y2;y3;y4];
matX=[x1.^3,  x1.^2, x1, 1;
      x2.^3,  x2.^2, x2, 1;
      x3.^3,  x3.^2, x3, 1;
      x4.^3,  x4.^2, x4, 1];

%coeficientes de la funcion cubica
coef=matX\pY;

x0=0;
xf=300;

y0=147;
yf=186;

x = [x0 x1 x3 196 x4 x2 xf]; 
y = [y0 y1 y3 58 y4 y2 yf];

vx=linspace(1,300,300);


%declaración de la función (curva de la pista)
fx = @(x) coef(1)*x.^3 + coef(2)*x.^2 + coef(3)*x + coef(4);

hold on 
axis equal
fplot(fx,[0 300])

plot(x1,pY(1),'o')
plot(x2,pY(2),'o')
plot(x3,pY(3),'o')
plot(x4,pY(4),'o')

%derivada de la funcion
derivFx = @(x) 3*coef(1)*x.^2 + 2*coef(2)*x + coef(3);

%función a integrar (encontrar la longitud de la curva): √1+f'(x)
longAInt = @(x) (1+(3*coef(1)*x.^2 + 2*coef(2)*x + coef(3)).^2).^(1/2);

%longitud de la curva
longCurva=integral(longAInt,10,280);
strLong="Longitud de Curva: "+num2str(longCurva);
text(45,250,strLong,"FontSize",15,"FontName","times") %mostrar longitud en grafica

%radio de curvatura
deriv2Fx=@(x) 6*coef(1)*x + 2*coef(2) ; %f''(x)

[minValY,minValX]=min(fx(0:300)); %regresa cordenadas minimas (y,x)
[maxValY,maxValX]=max(fx(0:300)); %regresa cordenadas maximas (y,x)

radioCurva=@(x)(1+derivFx(x).^2).^(3/2)./abs(deriv2Fx(x)); %funcion para radio de la curva

plot(longCurva);

radio1=radioCurva(maxValY); %radio punto max
radio2=radioCurva(minValY); %radio punto min


%Graficar círculos
shape1=nsidedpoly(100,'Center',[maxValX (maxValY-radio1)],'Radius',radio1);
plot(shape1) %plot circulo en punto max
strRad1 = "Radio: " +num2str(radio1);
text(25,120,strRad1)

shape2=nsidedpoly(100,'Center',[minValX (minValY+radio2)],'Radius',radio2);
plot(shape2) %plot circulo en punto min
strRad2 = "Radio: " +num2str(radio2);
text(180,150,strRad2)

%%Zona de derrape
valX_derrapeinf=[]; %valor en x de zona de derrapes inferior/mínimo
valX_derrapesup=[]; %valor en x de zona de derrapes superior/máxima

%buscar y filtrar valores en x para las categorias previas
for i=0:300
    radio=radioCurva(i);
    if radio<50
        if i<150 %separación de punto x del mínimo
            valX_derrapeinf=[valX_derrapeinf i];
        else %separación de punto x del máximo
            valX_derrapesup=[valX_derrapesup i];
        end
    end
end

%grafica zonas derrape
plot(valX_derrapeinf,fx(valX_derrapeinf),"Color",[1 0 0],'LineWidth',6)
plot(valX_derrapesup,fx(valX_derrapesup),"Color",[1 0 0],'LineWidth',6)

%Rectas
vxTang=@(x) x:x+50; 
vxPend=@(x) x-50:x;
rectaTang=@(x) fx(x)+derivFx(x)*(vxTang(x)-x); %fórmula para recta tangencial
rectaPend=@(x) fx(x)+(-1./derivFx(x))*(vxPend(x)-x); %fórmula para recta pendiente

%Graficar rectas
plot(vxTang(min(valX_derrapeinf)),rectaTang(min(valX_derrapeinf)),'Color',[0.3010 0.7450 0.9330],'LineWidth',3)
plot(vxPend(min(valX_derrapeinf)),rectaPend(min(valX_derrapeinf)),"Color",[0 0.4470 0.7410],'LineWidth',3)

plot(vxTang(min(valX_derrapesup)),rectaTang(min(valX_derrapesup)),'Color',[0.3010 0.7450 0.9330],'LineWidth',3)
plot(vxPend(min(valX_derrapesup)),rectaPend(min(valX_derrapesup)),"Color",[0 0.4470 0.7410],'LineWidth',3)

%Graficar gradas
grada1=polyshape([195,195+80,195+80,195],[30,30,30-10,30-10]);
plot(rotate(grada1,-25,[195,30]))

grada2=polyshape([20,20+80,20+80,20],[220,220,220+10,220+10]);
plot(rotate(grada2,39,[20,220]))

p=polyfit(x,y,3);
x2=(0:10:300);
y2=polyval(p,x2);
comet(x2, fx(x2));


%% Puntos críticos
%criticos
        cx1=zeros(1,4);
        cy1=zeros(1,4);
        cx2=zeros(1,4);
        cy2=zeros(1,4);
        agregar = 1;
        agregar2 = 1;
        for i = 1:length(radio1)
           radio1(i) = radio1(i)*1000;
           if radio1(i) <= 50
               fprintf("El radio de %0.4f  es un zona critica ubicada en el punto %d \n",radio(i),i);
               if i<15
                    cx1(agregar) = x2(i);
                    cy1(agregar) = y2(i);
                    agregar = agregar+1;
               else
                    cx2(agregar2) = x2(i);
                    cy2(agregar2) = y2(i);
                    agregar2 = agregar2+1;
               end
            end
        end

%% Carros
%velocidad máxima

%m = 750;
%g = 9.81;
%r= radio de la curva
%cs = 1.7;
%cd = 1.7;
%vmax = (g*cs*r)^(1/2);

%Energía perdida en calor
%epc = (1/2)*m*(vmax)^2;

%distancia recorrida desde que inicio a derrapar hasta que se detiene
%d = ((vmax)^2)/(2*cd*g);
