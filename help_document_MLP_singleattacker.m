%Initialize utility matrix
U_defender_c=[1 1]
U_defender_u=[-1 -1]
U_attacker_u=[1 ;1]
U_attacker_c=[0 ;0]
n=size(U_defender_u)

%region 1, where target 1 is attacked by attackers
cvx_begin
    variable x(n)

    maximize(-(1-x(1))+x(1))
    subject to
        x(1)-x(2)<=0
        norm(x, 1) <= 1
        0 <= x <= 1
cvx_end
%region 2, where target 2 is attacked by attackers
cvx_begin
    variable y(n)

    maximize(-(1-y(2))+y(2))
    subject to
        y(2)-y(1)<=0
        norm(y, 1) <= 1
        0 <= y <= 1
cvx_end