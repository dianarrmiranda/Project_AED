clear;clc;
%% Calcular a complexidade computacional do algoritmo fornecido.
%Para a posição 50, tínhamos que o effort era
countOriginal =127966647148  
t50Original =6.121e+02 % Supostamente não interessa, porque o algoritmo visita todos os nós

% Temos antes de fazer para a otimizada
t800Sol1 =1.206e-05 
countSol1 = 538

%% tentativa da complexidade computacional para a solution_1_otimized_recursion
n = 800
n + log(n + n) % algo está errado porque para as 800 posições, teria de dar 538, ou seja,
% effort <1 em alguma parte do código, o que não pode acontecer