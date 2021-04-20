function V = ReferenceVectorAdaptation(PopObj,V)
% Weight vector adaption strategy


%     V = V.*repmat(max(PopObj,[],1)-min(PopObj,[],1),size(V,1),1);
    
    V = V.*repmat(max(PopObj,[],1)-min(PopObj,[],1),size(V,1),1)./sum(V.*repmat(max(PopObj,[],1)-min(PopObj,[],1),size(V,1),1),2);
    
end