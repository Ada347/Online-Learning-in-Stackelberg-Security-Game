function [cvx_optval,z,a] = MILP(U_defender_c,U_defender_u,U_attacker_u,U_attacker_c)
%Transform SSG problem into MILP problem and compute the optimal strategy.

%   U_defender_c(1×n) is the utility matrix of defender(attacked target is covered by defender)
%   U_defender_u(1×n) is the utility matrix of defender(attacked target is not covered by defender)
%   U_attacker_u(n×k) is the utility matrix of attackers(attacked target is not covered by defender)
%   U_attacker_c(n×k) is the utility matrix of attackers(attacked target is covered by defender)
%   cvx_optval is the abs value of the optimal expected utility
%   z(n×n×k) is the variable z in DOBSS algorithm
%   a(k×1) is the array of attacker's optimal utility value

%Initialization
U_leader_c=U_defender_c;
U_leader_u=U_defender_u;
U_follower_u=U_attacker_u;
U_follower_c=U_attacker_c;
n=size(U_follower_c,1);
k=size(U_follower_u,2);
P_attacker=(1/k)*ones(k);

%transform utility matrix into R,C matrix in DOBSS algorithm.
[R,C] = PayoffMatrix(-U_leader_c, -U_leader_u,U_follower_c,U_follower_u);

%mixed integer linear programming by DOBSS algorithm
q=zeros(n,k);
cvx_begin
variable z(n,n,k);
variable zz(n,n,k);
variable q(n,k) binary;
variable a(k);
I=ones(n,n);
I1=ones(n,1);
minimize(DOBSS_optimal_objective(R,C,z,zz,q,P_attacker));
subject to
for i3=1:k
    sum(q(:,i3))==1;
    sum(sum(z(:,:,i3),1))==1;
    for i2=1:n
        0<=a(i3)-sum(sum((diag(C(:,i2,i3)))*z(:,:,i3),1));
        a(i3)-sum(sum((diag(C(:,i2,i3)))*z(:,:,i3),1))<=10000*(1-q(i2,i3));
        sum(z(:,i2,i3))<=1;
        sum(z(:,i2,i3))>=q(i2,i3);
        sum(z(i2,:,i3))<=1;
        sum(z(i2,:,i3))==sum(z(i2,:,1));
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  

zeros(n,n,k)<=z<=ones(n,n,k);                                                                             
cvx_end

end