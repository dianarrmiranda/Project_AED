clear;clc;
DATA = load("SolucaoProf1hour.txt");
ForE2If= load("SolProfOtimizadaForE2If.txt");

n = DATA(:,1); % selecionar dos dados do .txt a primeira coluna com os valores de n
count = DATA(:,3); % selecionar dos dados do .txt a terceira coluna com os valores de n

figure(1)
stem(n,count);


%% construir o grafico para a 2ª melhoria: FOR mais 2 IF
n_F2if = ForE2If(:,1);
count_F2if = ForE2If(:,3);

figure(2)
bar(n_F2if,count_F2if);