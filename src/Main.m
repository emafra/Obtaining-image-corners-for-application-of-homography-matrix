clear;clc; close all;

I = iread('capa.jpg');
Im = rgb2gray(I); % Transforma a imagem para a escala Gray.
s = double(ones(5,5)); 
Im = iopen(Im, s); % elimina ruídos
edges = icanny(Im); % Filtro de detecção de bordas
Im = bwconvhull(edges); % realiza precimento da imagem 
edges = icanny(double(Im)); % filtro de detecção de bordas
figure; idisp(edges); 
I2 = edges;
h = Hough(edges,'suppress',10); 
linhas = h.lines(); % linhas de perpsctiva 
hold on;
linhas.plot; 
linhas2 = linhas.seglength(I2); % linhas de perpsctiva (com informação adicional).
k = find(linhas2.length>80); % medida de precaução, nao é necessária neste caso
figure();idisp(I);
linhas2(k).plot('g');
[m,n]  = size(linhas2);
k = 0;
a = 0;
for i = 1:n
    for j = i+1:n
        k=k+1;
        u1(k) = ((linhas2(i).rho/cos(linhas2(i).theta)) - ...
        (linhas2(j).rho/cos(linhas2(j).theta)))/...
            (tan(linhas2(i).theta)-tan(linhas2(j).theta));
        v1(k) = -u1(k)*tan(linhas2(j).theta) + ...
        (linhas2(j).rho/cos(linhas2(j).theta));       
        if u1(k)>0 && v1(k)>0
            a=a+1;
            u(a)=u1(k); % Pontos de interseção 
            v(a)=v1(k);
        end
    end
end
x1=transpose(u);
y1=transpose(v);
x2=[min(u);min(u);max(u);max(u)];
y2=[min(v);max(v);min(v);max(v)];
T = maketform('projective',[x1 y1],[x2 y2]);
% Realiza a homografia da imagem.
T.tdata.T
% Realiza a homografia da imagem.
[Im2,xdata,ydata]=imtransform(I,T);
idisp(Im2);

