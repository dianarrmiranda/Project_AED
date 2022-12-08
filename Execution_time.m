clear;clc;
DATA = load("SolucaoProf1hour.txt");
SoFor = load("SolProfOtimizadaFor.txt");
ForE1If= load("SolProfOtimizadaForE1If.txt");
ForE2If= load("SolProfOtimizadaForE2If.txt");
Sol2 = load("Solution2_107457.txt");
Sol3 = load("Solution3_107457.txt");
ForE2If_107403= load("Solution1_107403.txt");
Sol2_107403 = load("Solution2_107403.txt");
Sol3_107403 = load("Solution3_107403.txt");

n = DATA(:,1); % selecionar dos dados do .txt a primeira coluna com os valores de n
t = DATA(:,4); % selecionar dos dados do .txt a quarta coluna com os valores de n
%% Gráficos dos algoritmos originais
figure(1)
plot(n,t,"r") % gráfico super exponencial a partir do x=40
title("Tempo de execução da solução fornecida");
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
title("Tempo de execução da solução fornecida");
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
P2= plot(n, Ntotal*Coefs, "k");
legend(P2,"Reta de ajuste")
hold off

t800_log = [800 1]* Coefs;

% gráfico para as 800 posições
% temos de calcular os t's ate a essa posição e não só o t=800
n= 1:800;

for i=n
    t(i)= [i 1]*Coefs;
    t(i)= 10.^t(i) / 3600 / 24 /365;
end
t_log =log10(t);
%% construir o grafico para a modificação do FOR
n_for = SoFor(:,1);
t_for = SoFor(:,4);

figure(4)
plot(n_for,log10(t_for),"b")
t_log_for =log10(t_for);
N = [n_for(20:end) 1+0*n_for(20:end)];
Coefs = pinv(N)*t_log_for(20:end); % matriz de regressão

hold on
Ntotal = [n_for n_for*0+1];
% regra de ajuste aos dados
P2= plot(n_for, Ntotal*Coefs, "k");
title("Tempo de execução do algoritmo com a 1ª melhoria");
xlabel("n");
ylabel("log10 (t)")
legend(P2,"Reta de ajuste")
grid on
hold off
t800_log_for = [800 1]* Coefs;

n= 1:800;
for i=n
    t_for(i)= [i 1]*Coefs;
    t_for(i)= 10.^t_for(i) / 3600 / 24 /365;
end
t_log_for =log10(t_for);
%% construir o grafico para a 2º melhoria: FOR mais 1 IF
n_F1if = ForE1If(:,1);
t_F1if = ForE1If(:,4);

figure(5)
plot(n_F1if,log10(t_F1if),"g")
t_log_F1if =log10(t_F1if);
N = [n_F1if(20:end) 1+0*n_F1if(20:end)];
Coefs = pinv(N)*t_log_F1if(20:end); % matriz de regressão

hold on
Ntotal = [n_F1if n_F1if*0+1];
% regra de ajuste aos dados
P2= plot(n_F1if, Ntotal*Coefs, "k");
title("Tempo de execução do algoritmo com a 2ª melhoria");
xlabel("n");
ylabel("log10 (t)")
legend(P2,"Reta de ajuste")
grid on
hold off
t800_log_F1if = [800 1]* Coefs;

n= 1:800;
for i=n
    t_F1if(i)= [i 1]*Coefs;
    t_F1if(i)= 10.^t_F1if(i) / 3600 / 24 /365;
end
t_log_F1if =log10(t_F1if);

%% construir o grafico para a 2º melhoria: FOR mais 2 IF
n_F2if = ForE2If(:,1);
t_F2if = ForE2If(:,4);
n_F2if_107403 = ForE2If_107403(:,1);
t_F2if_107403 = ForE2If_107403(:,4);

figure(6)
plot(n_F2if,log10(t_F2if))
TempoRealPos800_log = log10(t_F2if(100,1)); % ir buscar o valor real do tempo demorado na posição 800 (mas em log)
hold on
t_log_F2if =log10(t_F2if);
N = [n_F2if(20:end) 1+0*n_F2if(20:end)];
Coefs = pinv(N)*t_log_F2if(20:end); % matriz de regressão

plot(n_F2if_107403,log10(t_F2if_107403))

Ntotal = [n_F2if n_F2if*0+1];
% regra de ajuste aos dados
plot(n_F2if, Ntotal*Coefs, "k");
title("Tempo de execução do algoritmo com a 3ª melhoria");
xlabel("n");
ylabel("log10 (t)")
legend("107457","107403","Reta de ajuste (107457)")
grid on
hold off
t800_log_F2if = [800 1]* Coefs;

n= 1:800;
for i=n
    t_F2if(i)= [i 1]*Coefs;
    t_F2if(i)= 10.^t_F2if(i) / 3600 / 24 /365;
end
t_log_F2if =log10(t_F2if);
%% Todos os gráficos dos diferentes algoritmos para 800 n's da solução 1 
figure(7)
hold on
plot(n,t_log, "k")
plot(n,t_log_for, "r")
plot(n,t_log_F1if, "b")
plot(n,t_log_F2if, "g")
xlabel("n");
ylabel("log (t)");
title("Reta de ajuste das diferentes melhorias até n=800")
legend("Reta de ajuste original","1ª melhoria","2ª melhoria","3º melhoria");
grid on
hold off
%% construir o grafico para a 2º solução
n_Sol2 = Sol2(:,1);
t_Sol2 = Sol2(:,4);

n_Sol2_107403 = Sol2_107403(:,1);
t_Sol2_107403 = Sol2_107403(:,4);
figure(8)
plot(n_Sol2,t_Sol2,"r") 
title("Tempo de execução do 2º algoritmo");
xlabel("n");
ylabel("t (s)")
grid on
hold on
plot(n_Sol2_107403,t_Sol2_107403,"b") 
N = [n_Sol2(20:end) 1+0*n_Sol2(20:end)];
Coefs = pinv(N)*t_Sol2(20:end); % matriz de regressão

hold on
Ntotal = [n_Sol2 n_Sol2*0+1];
% regra de ajuste aos dados
plot(n_Sol2, Ntotal*Coefs, "k");
legend("107457","107403","Reta de ajuste (107457)")
%% construir o grafico para a 3º solução
n_Sol3 = Sol3(:,1);
t_Sol3 = Sol3(:,4);

n_Sol3_107403 = Sol3_107403(:,1);
t_Sol3_107403 = Sol3_107403(:,4);
figure(9)
plot(n_Sol3,t_Sol3,"k")
hold on
plot(n_Sol3_107403,t_Sol3_107403)
title("Tempo de execução da 3º algoritmo");
xlabel("n");
ylabel("t (s)")
grid on
legend("107457","107403")