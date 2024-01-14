%Initialize utility matrix, attacker sequence and C0_sequence
n=6;
k=5;
U1u_Array=zeros(1,n);
U1c_Array=zeros(1,n);
U2u_Array=zeros(n,k);
U2c_Array=zeros(n,k);
U2_u=round(rand(n,k),2);
U2_c = zeros(n,k);
U1_u=round(unifrnd(-1,0,[1,n]),2);
U1_c=zeros(1,n);
for inx=1:n
    for iny=1:k
    U2_c(inx,iny)=unifrnd(-U2_u(inx,iny),U2_u(inx,iny));
    end
    U1_c(inx)=unifrnd(0,-U1_u(inx));
end
U1_c=round(U1_c,2);
U2_c=round(U2_c,2);

t=1000;
Strategy_Table=zeros(n,t,2);
Strategy_Table1=zeros(n,n,k,t,2);
AttackerSequence=randi(k,1,t);
SequecneFrequency=zeros(k,t);

for i=1:t
    for j=1:k
        for m=1:i
            if AttackerSequence(m)==j
                SequecneFrequency(j,i)=SequecneFrequency(j,i)+1/i;
            end
        end
    end
end

C0_sequence=zeros(n,t);
for i=2:t
    C0_sequence(:,i)=rand(n,1)*(sqrt(2*i)/(i-1));
end
C0_sequence(:,1)=rand(n,1);
%%
%Compute online solutions of repeated SSG problems by FTL.
for i=1:100
    [optimal,z11,target] = MILP_yalmip_gurobi(U1_c,U1_u,U2_u,U2_c,SequecneFrequency(:,i));
    
    
    Strategy_Table(:,i,1)=sum(z11(:,:,1),2);
    Strategy_Table1(:,:,:,i,1)=z11;
    
end

%%
%Compute online solutions of repeated SSG problems by FTPL.
for i=1:100
    [optimal,z11,target] = MILP_yalmip_gurobi_C0(U1_c,U1_u,U2_u,U2_c,SequecneFrequency(:,i),C0_sequence(:,i));
    
    Strategy_Table(:,i,2)=sum(z11(:,:,1),2);
    Strategy_Table1(:,:,:,i,2)=z11;
    
end

%%
%Compute expected utility of FTPL in each round and sum them up. Store in Regret_table(:,2)
%Compute optimal offline expected utility. Store in Regret_table(:,1)
[R,C] = PayoffMatrix(-U1_c, -U1_u,U2_c,U2_u);
Regret_table=zeros(t,2);
Regret_table(1,2)=1;

for h=1:1
    for i=1:n
    for j=1:n
        for l=1:k
%             zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l);
Regret_table(h,1)=Regret_table(h,1)+h*SequecneFrequency(l,h)*(R(i,j))*Strategy_Table1(i,j,l,h,1);

        end
    end
end

end
for h=2:t
    for i=1:n
    for j=1:n
        for l=1:k
%             zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l);
Regret_table(h,1)=Regret_table(h,1)+h*SequecneFrequency(l,h)*(R(i,j))*Strategy_Table1(i,j,l,h,1);
Regret_table(h,2)=Regret_table(h,2)+SequecneFrequency(l,h)*(R(i,j))*Strategy_Table1(i,j,l,h-1,2);
        end
    end
end
Regret_table(h,2)=Regret_table(h-1,2)+Regret_table(h,2);
end
%%
%Compute the regret of FTPL
Regret=zeros(100,1);
for i=1:100
    Regret(i)=Regret_table(i,2)-Regret_table(i,1)
end
%%
%Compute the expected utility of FTL in each round
Regret_table3=zeros(100,2);
Regret_table3(1,1)=1;
for h=2:100
    for i=1:n
    for j=1:n
        for l=1:k
%             zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l);

Regret_table3(h,1)=Regret_table3(h,1)+SequecneFrequency(l,h)*(R(i,j))*Strategy_Table1(i,j,l,h-1,1);
        end
    end
end
Regret_table3(h,1)=Regret_table3(h-1,1)+Regret_table3(h,1);
end
%%
%Compute regret of FTL
for i=1:100
Regret_table3(i,2)=Regret_table3(i,1)-Regret_table(i,1);
end
%%
%Regret upper bound function
x=[1:100];
bound=2*sqrt(x);
%%
%FTPL vs Upper bound
plot(x,Regret,'b.-', x,bound,'m-.');
title('Regret Bound Verification')
 xlabel('Time Step')
 ylabel('Regret')
 legend('FTPL','$2\sqrt{2T}$','interpreter','latex','Location','southeast')
%%
%FTL vs Upper bound
plot(x,Regret_table3(:,2),'b.-', x,bound,'m-.');
title('Regret Bound Verification')
xlabel('Time Step')
ylabel('Regret')
legend('FTL','$2\sqrt{2T}$','interpreter','latex','Location','southeast')
%%
%FTPL vs FTL
plot(x,Regret,'b.-', x,Regret_table3(:,2),'m-.');
title('Regret of FTPL and FTL')
xlabel('Time Step')
ylabel('Regret')
legend('FTPL','FTL','interpreter','latex','Location','southeast')
