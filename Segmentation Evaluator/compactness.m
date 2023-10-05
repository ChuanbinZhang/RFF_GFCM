function [sumCO] = compactness(seg)
nLabels = max(max(seg));
N = size(seg, 1)*size(seg,2);
for m = 1: nLabels
    segLabelM = (seg == m);
    prop = bwconncomp(segLabelM, 4);
    
    for k = 1: prop.NumObjects
        if k > 1
            nLabels = nLabels + 1;
            for i = 1: size(prop.PixelIdxList{k}, 1)
                seg(prop.PixelIdxList{k}(i)) = nLabels;
            end
        end
    end
end

for m = 1: nLabels
    segLabelM = (seg == m);
    prop = bwconncomp(segLabelM, 4);
    
    if prop.NumObjects > 1
        error('Non-connected superpixel detected!');
    end
end

sumCO = 0;
for m = 1: nLabels
    % segLabelM is zero everywhere except where it was labeled m.
    segLabelM = (seg == m);
    
    if sum(sum(segLabelM)) > 0
        properties = regionprops(segLabelM, 'Area', 'Perimeter');
        %imshow(segLabelM);
        
        if properties.Perimeter > 0
            sumCO = sumCO + properties.Area*((4*pi*properties.Area)/(properties.Perimeter*properties.Perimeter));
        end
    end
end
sumCO = sumCO / N;
end

