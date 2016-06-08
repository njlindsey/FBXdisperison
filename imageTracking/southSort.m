function [dataOut]=southSort(dataIn)

% reduce data to only the South moving cars. Do this by selecting only the
% gathers with more than 4 patches. And require that Ax of each patch
% follows: Ax(1)<=Ax(0). 
%
k=1;        
for i=1:length(dataIn)
    disp(i)
    %Check if there more than 4 patches
    if any(strcmp('P',fieldnames(dataIn{i})))==1
        
        %start counter
        q=0;

        %loop over patches, if more than 4 in gather
        if length(dataIn{i}.P)>=4
            
            %check that center of patch is either not changing or
            %decreasing for South
            for p=2:length(dataIn{i}.P)

                if dataIn{i}.P{p}{1}(1)<=dataIn{i}.P{p-1}{1}(1)
                    q=q+1;
                else
                    break
                end

            end
            
            %if you make it through that for loop, all patches passed,
            %save the gather to a new dsi and increment the counter
            if q==p-1
                dataOut{k}=dataIn{i};
                k=k+1;
            end
            
        end
            
    end
    
end