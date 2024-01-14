function [object] = DOBSS_optimal_objective(R,C,z,zz,q,P_follower)
%Represent the objective function of MILP

n=size(z,1);
k=size(z,3);

for i=1:n
    for j=1:n
        for l=1:k
zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l);
        end
    end
end
object=-10*n*n*k;
for i=1:k
    for j=1:n
object=norm(zz(:,j,i),1)+object;
    end
end
end