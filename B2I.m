function indi = B2I( bin )
%B2I: binary vector to indicator vector
%   {0,1} binary vector is converted to an indicator vector correspond to 
%   the decimal number. If bin is L-by-N matrix, it returns 2^L-by-N matrix
%   consist of {0,1}^(2^L) binary vectors.
[L,N]=size(bin);
binmap=2.^[0:L-1]';
indi=zeros(2^L,N);
for i=1:N
    index=sum(binmap.*bin(:,i)); % binary message vector to decimal number   
    indi(index+1,i)=1;      % indicator vector for block gaussian
end
end

