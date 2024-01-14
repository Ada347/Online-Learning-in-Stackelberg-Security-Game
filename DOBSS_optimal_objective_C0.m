function [object] = DOBSS_optimal_objective_C0(R,C,z,zz,q,P_follower,C0)
% function [object] = DOBSS_optimal_objective(x,y,zz)
% DOBSS_optimal_objective(R,C,z,q,P_follower)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
n=size(z,1);
k=size(z,3);

for i=1:n
    for j=1:n
        for l=1:k
%             zz(i,j,l)=10+P_follower(l)*R(i,j)*z(i,j,l);
zz(i,j,l)=10+P_follower(l)*(R(i,j)+C0(i))*z(i,j,l);
        end
    end
end
% n=2;
% k=2;
% for i =1:2
%     zz(i)=100-10*x(i);
% end
% object=-10*n*n*k;
object=-10*n*n*k;
for i=1:k
    for j=1:n
object=norm(zz(:,j,i),1)+object;
    end
end

end