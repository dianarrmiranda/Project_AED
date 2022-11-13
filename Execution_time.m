clear;clc;
DATA = load("SolucaoProf1hour.txt");
SoFor = load("SolProfOtimizadaFor.txt");
ForE1If= load("SolProfOtimizadaForE1If.txt");
ForE2If= load("SolProfOtimizadaForE2If.txt");

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
t800_for = 10^t800_log_for / 3600 / 24 /365;
fprintf("O programa com 1 if iria demorar %d a executar se corresse até à posição 800.\n",t800_for);

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
t800_F1if = 10^t800_log_F1if / 3600 / 24 /365;
fprintf("O programa só com o segundo IF iria demorar %d a executar se corresse até à posição 800.\n",t800_F1if);

n= 1:800;
for i=n
    t_F1if(i)= [i 1]*Coefs;
    t_F1if(i)= 10.^t_F1if(i) / 3600 / 24 /365;
end
t_log_F1if =log10(t_F1if);

%% construir o grafico para a 2º melhoria: FOR mais 2 IF
n_F2if = ForE2If(:,1);
t_F2if = ForE2If(:,4);

figure(6)
plot(n_F2if,log10(t_F2if),"m")
t_log_F2if =log10(t_F2if);
N = [n_F2if(20:end) 1+0*n_F2if(20:end)];
Coefs = pinv(N)*t_log_F2if(20:end); % matriz de regressão

hold on
Ntotal = [n_F2if n_F2if*0+1];
% regra de ajuste aos dados
P2= plot(n_F2if, Ntotal*Coefs, "k");
title("Tempo de execução do algoritmo com a 3ª melhoria");
xlabel("n");
ylabel("log10 (t)")
legend(P2,"Reta de ajuste")
grid on
hold off
t800_log_F2if = [800 1]* Coefs;
t800_F2if = 10^t800_log_F2if / 3600 / 24 /365;
fprintf("O programa só com o segundo IF iria demorar %d a executar se corresse até à posição 800.\n",t800_F2if);

n= 1:800;
for i=n
    t_F2if(i)= [i 1]*Coefs;
    t_F2if(i)= 10.^t_F2if(i) / 3600 / 24 /365;
end
t_log_F2if =log10(t_F2if);
%% Todos os gráficos dos diferentes algoritmos para 800 n's 
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