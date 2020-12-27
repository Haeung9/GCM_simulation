function bin = I2B ( indi )
%I2B: indicator vector to binary vector
%    an indicator vector is converted to {0,1} binary vector
[LL,N]=size(indi);
L=log2(LL);
bin=zeros(L,N);
binmap=2.^[0:L-1]';
for j=1:N
r=find(indi(:,j))-1;
for i=1:L
    if r>=binmap(L-i+1)
        bin(L-i+1,j)=1;
        r=r-binmap(L-i+1);
    end
end
end

if ~(r==0)
    disp('Error: out of index')
end

end
