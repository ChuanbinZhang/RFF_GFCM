function w=w_neighbors(super_label,data,neighbor_p,eta)
w = zeros(size(data,1));
for i=1:max(max(super_label))
    for j=find(neighbor_p(i,:))
        w(i,j)=exp(-sum((data(i,:)-data(j,:)).^2)/eta);
    end
end