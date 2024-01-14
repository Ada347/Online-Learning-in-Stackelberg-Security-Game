%Initialize utility matrix
U2_u=[0.5 1;1 0.5];
U2_c = [0 0; 0 0];
U1_c=[0 0];
U1_u=[-0.5 -1];
%Apply MLP alogrithm
[optimal,z1,target] = MLP(U1_c,U1_u,U2_c,U2_u)