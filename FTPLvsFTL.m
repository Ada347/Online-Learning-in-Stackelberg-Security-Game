%Initialization
 U2_u=[1 0 ; 0 1];
 U2_c = [0.5 0;  0 0.5];
 U1_c=[0 0 ];
 U1_u=[-0.9 -1];
 U_attacker_c=U2_c;
 U_attacker_u=U2_u;
 U_defender_c=U1_c;
 U_defender_u=U1_u;

n=size(U_defender_c,2);
k=size(U_attacker_u,2);
t=100;
Strategy_Table=zeros(n,t,2);
Strategy_Table1=zeros(n,n,k,t,2);
%Design attacker sequence
AttackerSequence=randi(2,1,t);
for i=1:500
    AttackerSequence(i)=2-mod(mod(i,19),2);
    if mod(i,19)==0
        AttackerSequence(i)=1;
    end
end
%Determine target to be attacked in each round
Attackedlist=zeros(k,t);
for i=1:100
    if AttackerSequence(i)==1
        Attackedlist(1,i)=1;
    end

    if AttackerSequence(i)==2
        Attackedlist(2,i)=1;
    end
end
%Represent frequency of each attacker type
SequecneFrequency=zeros(k,t);
for i=1:t
    for j=1:n
        for l=1:i
            if AttackerSequence(l)==j
                SequecneFrequency(j,i)=SequecneFrequency(j,i)+1/i;
            end
        end
    end
end

%Initialize C0
C0_sequence=zeros(n,t);
for i=2:t
    C0_sequence(:,i)=rand(n,1)*(sqrt(2*i)/(i-1));
end
C0_sequence(:,1)=rand(n,1);
%%
%Compute solutions of FTL and store them.
for i=1:100
    [optimal,z11,target] = MILP_yalmip_gurobi(U1_c,U1_u,U2_u,U2_c,SequecneFrequency(:,i));
    Strategy_Table(:,i,1)=sum(z11(:,:,1),2);
    Strategy_Table1(:,:,:,i,1)=z11;
    
end
%%
%Compute solutions of FTPL and store them.
for i=1:100
    [optimal,z11,target] = MILP_yalmip_gurobi_C0(U1_c,U1_u,U2_u,U2_c,SequecneFrequency(:,i),C0_sequence(:,i));
    Strategy_Table(:,i,2)=sum(z11(:,:,1),2);
    Strategy_Table1(:,:,:,i,2)=z11;
    
end

%%
%Compute the utility of FTPL
[R,C] = PayoffMatrix(U1_c, U1_u,U2_c,U2_u);
Expected_Utility_table_FTPL=zeros(100,1);
Expected_Utility_table_FTL=zeros(100,1);
Optimal_Offline_Utility_Sum=zeros(100,1);
Expected_Utility_table_FTPL(1,1)=-randi(1);
for h=2:100
    for i=1:n
    for j=1:n
        for l=1:k
%zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l); The idea is from DOBSS_optimal_objective
Expected_Utility_table_FTPL(h)=Expected_Utility_table_FTPL(h)+Attackedlist(i,h)*(R(j,i))*Strategy_Table1(i,j,l,h-1,2);
%Compute the utility of offline best strategy
Optimal_Offline_Utility_Sum(h)=Optimal_Offline_Utility_Sum(h)+h*SequecneFrequency(l,h)*(R(i,j))*Strategy_Table1(i,j,l,h,1);
        end
    end
    end
Expected_Utility_table_FTPL(h)=Expected_Utility_table_FTPL(h-1)+Expected_Utility_table_FTPL(h);
end
%%
%Compute utility of FTL
Expected_Utility_table_FTL=zeros(100,1);
for h=2:100
    for i=1:n
    for j=1:n
        for l=1:k
%             zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l);
Expected_Utility_table_FTL(h)=Expected_Utility_table_FTL(h)+Attackedlist(i,h)*(R(j,i))*Strategy_Table1(i,j,l,h,1);
        end
    end
    end
Expected_Utility_table_FTL(h)=Expected_Utility_table_FTL(h-1)+Expected_Utility_table_FTL(h);
end
%%
%Compute regret of FTL
Regret_FTL=zeros(100,1);
for i=1:100
Regret_FTL(i)=Optimal_Offline_Utility_Sum(i)-Expected_Utility_table_FTL(i) 
end

%%
%Compute regret of FTPL
Regret=zeros(100,1);
Regret_FTPL=zeros(100,1);
for i=1:100
Regret_FTPL(i)=Optimal_Offline_Utility_Sum(i)-Expected_Utility_table_FTPL(i) 
end
%%
x=[1:100];
bound=2*sqrt(x);
 %%
 plot(x,Regret_FTPL,'b.-', x,Regret_FTL,'m-.');
title('Regret of FTPL and FTL')
 xlabel('Time Step')
 ylabel('Regret')
 legend('FTPL','FTL','interpreter','latex','Location','southeast')

