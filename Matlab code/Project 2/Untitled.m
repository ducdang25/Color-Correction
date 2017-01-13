clc;close all;clear all;
s = ((1950:10:2000)' - 1950)/50;
y = [150.6970 179.3230 203.2120 226.5050 249.6330 281.4220]';
X = [s.*s s ones(size(s))];
[A,b]= qrsteps(X,y);
beta = A(1:3,1:3)\b(1:3)