function ans = sDivide(m1,m2)
%performs matrix by scalar division

if m2 == 0
    ans = zeros(size(m1));
else
    ans = m1./m2;
end

