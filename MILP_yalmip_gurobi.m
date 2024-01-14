function [optobj,optz,optq] = MILP_yalmip_gurobi(U_defender_c,U_defender_u,U_attacker_u,U_attacker_c,OfflineFrequency)
%Transform SSG problem into MILP problem and compute the optimal strategy.
%applied YALIMP and gurobi solver

%   U_defender_c(1×n) is the utility matrix of defender(attacked target is covered by defender)
%   U_defender_u(1×n) is the utility matrix of defender(attacked target is not covered by defender)
%   U_attacker_u(n×k) is the utility matrix of attackers(attacked target is not covered by defender)
%   U_attacker_c(n×k) is the utility matrix of attackers(attacked target is covered by defender)
%   OfflineFrequency is the frequency of attackers of different attacker types.
%   optobj is the abs value of the optimal expected utility.
%   optz(n×n×k) is the optimal variable z in DOBSS algorithm.
%   optq(n×k) is optimal q in DOBSS algorithm.


%Initialization
U_leader_c=U_defender_c;
U_leader_u=U_defender_u;
U_follower_u=U_attacker_u;
U_follower_c=U_attacker_c;
n=size(U_follower_c,1);
k=size(U_follower_u,2);
P_attacker=OfflineFrequency;


%transform utility matrix into R,C matrix in DOBSS algorithm.
[R,C] = PayoffMatrix(-U_leader_c, -U_leader_u,U_follower_c,U_follower_u);


%mixed integer linear programming by YALMIP and Gurobi solver
z=sdpvar(n,n,k,'full');
zz=sdpvar(n,n,k,'full');
q = intvar(n,k,'full');
a=sdpvar(k,1,'full');
obj = DOBSS_optimal_objective(R,C,z,zz,q,P_attacker); % 4th order objective
ops = sdpsettings('solver','gurobi');
Constraint = sum(q(:,1))<=1;
for i3=1:k
%     Constraint=[Constraint,1<=sum(q(:,i3))<=1];
%     Constraint=[Constraint,1<=sum(sum(z(:,:,i3),1))<=1];
        Constraint=[Constraint,sum(q(:,i3))==1];
    Constraint=[Constraint,sum(sum(z(:,:,i3),1))==1];
    for i2=1:n
         Constraint=[Constraint,0<=a(i3)-sum(sum((diag(C(:,i2,i3)))*z(:,:,i3),1))];
         Constraint=[Constraint,a(i3)-sum(sum((diag(C(:,i2,i3)))*z(:,:,i3),1))<=2*(1-q(i2,i3))];
         Constraint=[Constraint,sum(z(:,i2,i3))<=1];
         Constraint=[Constraint,sum(z(:,i2,i3))>=q(i2,i3)];
         Constraint=[Constraint,sum(z(i2,:,i3))<=1];

         Constraint=[Constraint,sum(z(i2,:,i3))==sum(z(i2,:,1))];
    end
end


Constraint=[Constraint,zeros(n,n,k)<=z<=ones(n,n,k)];   
Constraint=[Constraint,zeros(n,n,k)<=zz<=ones(n,n,k)];  
sol=optimize(Constraint,obj,ops);
optobj = value(obj);
optq = value(q);
optz=value(z);
opta=value(a);
sol.info
end