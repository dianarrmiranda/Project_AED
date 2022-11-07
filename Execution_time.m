clear;clc;
DATA = load("SolucaoProf1hour.txt");
IF_1 = load("SolucaoProfOtimizada1hour_1IF.txt");
IF_2 = load("SolucaoProfOtimizada_So_Seg_IF.txt");

n = DATA(:,1); % selecionar dos dados do .txt a primeira coluna com os valores de n
t = DATA(:,4); % selecionar dos dados do .txt a quarta coluna com os valores de n
%% Gráficos dos algoritmos originais
figure(1)
plot(n,t,"r") % gráfico super exponencial a partir do x=40
title("Tempo de execução do algoritmo");
xlabel("n");
ylabel("t (s)")
grid on

figure(2)
semilogy(n,t,"g")
title("Tempo de execução do algoritmo");
xlabel("n");
ylabel("semilogy")
grid on

figure(3)
plot(n,log10(t),"b") % quase o mesmo que o plot do semilogy, mudando os valores do eixo y
title("Tempo de execução do algoritmo original");
xlabel("n");
ylabel("log10 (t)")
grid on

t_log =log10(t);
N = [n(20:end) 1+0*n(20:end)]; % começa no 20, porque é a partir desse n que a reta fica mais estável,
% para a reta de ajuste apanhar a maior parte dos dados
Coefs = pinv(N)*t_log(20:end); % matriz de regressão

hold on
Ntotal = [n n*0+1];
% regra de ajuste aos dados
plot(n, Ntotal*Coefs, "k")
hold off

t800_log = [800 1]* Coefs;
t800 = 10^t800_log / 3600 / 24 /365;
fprintf("O programa original iria demorar %0.3d a executar se corresse até à posição 800.\n",t800)


% gráfico para as 800 posições
% temos de calcular os t's ate a essa posição e não só o t=800
n= 1:800;

for i=n
    t(i)= [i 1]*Coefs;
    t(i)= 10.^t(i) / 3600 / 24 /365;
end
t_log =log10(t);

%% construir o grafico para 1 IF
n_1if = IF_1(:,1);
t_1if = IF_1(:,4);

figure(4)
plot(n_1if,log10(t_1if),"b")
t_log_1if =log10(t_1if);
N = [n_1if(20:end) 1+0*n_1if(20:end)];
Coefs = pinv(N)*t_log_1if(20:end); % matriz de regressão

hold on
Ntotal = [n_1if n_1if*0+1];
% regra de ajuste aos dados
plot(n_1if, Ntotal*Coefs, "k")
title("Tempo de execução do algoritmo com 1 if");
xlabel("n");
ylabel("log10 (t)")
grid on
hold off
t800_log_1if = [800 1]* Coefs;
t800_1if = 10^t800_log_1if / 3600 / 24 /365;
fprintf("O programa com 1 if iria demorar %d a executar se corresse até à posição 800.\n",t800_1if);

n= 1:800;
for i=n
    t_1if(i)= [i 1]*Coefs;
    t_1if(i)= 10.^t_1if(i) / 3600 / 24 /365;
end
t_log_1if =log10(t_1if);

%% construir o grafico para só segundo if
n_2if = IF_2(:,1);
t_2if = IF_2(:,4);

figure(5)
plot(n_2if,log10(t_2if),"g")
t_log_2if =log10(t_2if);
N = [n_2if(20:end) 1+0*n_2if(20:end)];
Coefs = pinv(N)*t_log_2if(20:end); % matriz de regressão

hold on
Ntotal = [n_2if n_2if*0+1];
% regra de ajuste aos dados
plot(n_2if, Ntotal*Coefs, "k")
title("Tempo de execução do algoritmo com 2 if");
xlabel("n");
ylabel("log10 (t)")
grid on
hold off
t800_log_2if = [800 1]* Coefs;
t800_2if = 10^t800_log_2if / 3600 / 24 /365;
fprintf("O programa só com o segundo IF iria demorar %d a executar se corresse até à posição 800.\n",t800_2if);

n= 1:800;
for i=n
    t_2if(i)= [i 1]*Coefs;
    t_2if(i)= 10.^t_2if(i) / 3600 / 24 /365;
end
t_log_2if =log10(t_2if);
%% Todos os gráficos dos diferentes algoritmos para 800 n's 
figure(6)
hold on
plot(n,t_log, "k")
plot(n,t_log_1if, "r")
plot(n,t_log_2if, "b")
xlabel("n");
ylabel("log (t)");
title("Reta de ajuste dos diferentes algoritmos para n=800")
legend("Original","IF do n saltos","IF das velocidades")
grid on