function [Z] = create_stack(Y,U,m)
    samples = size(Y,1);
    valid = samples-m;
    Z = zeros(valid,2*m+1);
    for i = m+1:samples
        Z(i-m,:) = [fliplr(Y(i-m:i).'),fliplr(U(i-m:i-1).')];
    end
end