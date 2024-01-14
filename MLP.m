function [optimal,z1,target] = MLP(U1_c,U1_u,U2_c,U2_u)
%UNTITLED7 此处提供此函数的摘要
%Processing input data
 U_attacker_c=U2_c;
 U_attacker_u=U2_u;
 U_defender_c=U1_c;
 U_defender_u=U1_u;
n=size(U_defender_c,2);
k=size(U_attacker_u,2);
target=zeros(n);
n=size(U_defender_c,2);
k=size(U_attacker_u,2);
%Generate A,b for H-representation
 A=zeros(n,n);
C=zeros(n,1);
A1=A;
C1=C;
for i=1:n
for j=1:k
for x=1:n-1

        if x<=i-1
            A(x,x)=U_attacker_c(x,j)-U_attacker_u(x,j);
            A(x,i)=-U_attacker_c(i,j)+U_attacker_u(i,j);
            C(x)=U_attacker_u(i,j)-U_attacker_u(x,j);
        end
        if x>=i
            A(x,x+1)=U_attacker_c(x+1,j)-U_attacker_u(x+1,j);
            A(x,i)=-U_attacker_c(i,j)+U_attacker_u(i,j);
            C(x)=U_attacker_u(i,j)-U_attacker_u(x+1,j);
        end
       
end
for y=1:n
    A(n,y)=1;
    %A(n+1,y)=-1;
    C(n)=1;
    %C(n)=-1;
end
A1(:,:,j,i)=A;
C1(:,:,j,i)=C;
 A=zeros(n,n);
C=zeros(n,1);
end
end
U_leader_c=U_defender_c;
U_leader_u=U_defender_u;
U_follower_u=U_attacker_u;
U_follower_c=U_attacker_c;
n=size(U_follower_c,1);
n = size(A1(:,:,2,1),2);
l=zeros(n,1);
u=ones(n,1);
%Generate expected utility function for each polytopes
AttackerTarget=zeros(k,1);
z1=zeros(n,1);
optimal=-1;
A2=zeros(n*k-k+1,n);
C2=zeros(n*k-k+1,1);
P=(1/k)*ones(1,k);
Expected_Utility_Array1=zeros(1,k);
Expected_Utility_Array2=zeros(1,k);
Transform_Matrix=zeros(k,n);
Ones=ones(n,1);
t1=tic;
for a=1:n^k
    d=a-1;
    for b=1:k
        
        AttackerTarget(b)=floor(d/n^(k-b))+1;
        d=d-n^(k-b)*(AttackerTarget(b)-1);
        for c=1:n-1
            A2((b-1)*(n-1)+c,:)=A1(c,:,b,AttackerTarget(b));
            C2((b-1)*(n-1)+c)=C1(c,:,b,AttackerTarget(b));
        end
        Expected_Utility_Array1(b)=P(b)*U1_c(AttackerTarget(b));
        Expected_Utility_Array2(b)=P(b)*U1_u(AttackerTarget(b));
        Transform_Matrix(b,AttackerTarget(b))=1;
    end
    A2(n*k-k+1,:)=A1(n,:,1,1);
    C2(n*k-k+1)=1;
    A11=A2;
    C11=C2;
%Compute optimal strategy for each polytope
    cvx_begin
        variable x(n);
        dual variable y;
        maximize(-norm( Expected_Utility_Array1*(Transform_Matrix*x)+Expected_Utility_Array2*(Transform_Matrix*(Ones-x))));
        subject to
        y : A2 * x <= C2;
        sum(x)==1;
        l <= x <= u;
        cvx_end
        if cvx_optval>optimal
            optimal=cvx_optval;
            z1=x;
            target=AttackerTarget;
        end
        Transform_Matrix=zeros(k,n);

end
end