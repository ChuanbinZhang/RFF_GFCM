function g=normalized(a)
if length(size(a))<3
    g=g_normalized(a);
else
   g=g_normalized(a(:,:,1));
   for i=2:size(a,3)
       g=cat(3,g,g_normalized(a(:,:,i)));
   end
end

function g=g_normalized(a)
a=double(a);
a_min=min(min(a));
g=a-a_min;
g_max=max(max(g));
if g_max==0
    if size(a,2)>1
        g(:,:)=1;
    else
        g(:)=1;
    end
else
    g=g/g_max;
end
    