function [R,C] = PayoffMatrix(U_leader_c, U_leader_u,U_follower_c,U_follower_u)
%This function is used to transform utility matrix of attackers and
%defneder into utility we will use in DOBSS algorithm

n=size(U_leader_c,2);
k=size(U_follower_u,2);
R=zeros(n,n);
for i=1:n
    for j=1:n
        R(i,j)=U_leader_u(j);
    end
end
for i=1:n
    R(i,i)=U_leader_c(i);
end

C=zeros(n,n,k);
for l=1:k
    for i=1:n
        for j=1:n
            C(i,j,l)=U_follower_u(j,l);
        end
    end
end
for l=1:k
    for i=1:n
        C(i,i,l)=U_follower_c(i,l);
    end
end
end