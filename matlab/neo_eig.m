function neo_eig = neo_eig(A)%%%%%%%%% Done :)
[vector,lambda] = eig(A);
m = size(A);
l = [];
for n = 1:m(1)
    l = vertcat(l,lambda(n,n));
end
for i = 1:m(1)
    for j = 1:m(1)-i
        if l(j) > l(j+1)
            a = l(j);
            l(j) = l(j+1);
            l(j+1) = a;
            b = vector(:,j);
            vector(:,j) = vector(:,j+1);
            vector(:,j+1) = b;
        end
    end
end 
neo_eig = vector;
end