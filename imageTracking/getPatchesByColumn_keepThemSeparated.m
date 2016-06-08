function [dsi]=getPatchesByColumn(data,col)
% Function to grab data for column col, knit together and then cross
% correlate as if it was continuous.
%
% NJL Mar 2016

%%
% Start counter
count=1;

%%

% Possible patch positions for a 1 patch buffered setup with 5 total
% columns in the matrix
disp(col)
%600m @ 100m -- 2 patches away 
if col==1
    possible_positions=1:8:144;
elseif col==2
    possible_positions=2:8:144; 
elseif col==3
    possible_positions=3:8:144;
elseif col==4
    possible_positions=4:8:144;
elseif col==5
    possible_positions=5:8:144;
elseif col==6
    possible_positions=6:8:144;
elseif col==7
    possible_positions=7:8:144;
elseif col==8
    possible_positions=8:8:144;
end

%%
% Loop through gathers
for i=1:length(data)
    %Check if there are any patches in this gather,Loop through all patches   
    %For patches in positions matching the column input, store data
    %in the interim matrix as a layer
    if any(strcmp('P',fieldnames(data{i})))==1
       for p=1:length(data{i}.P)
          if sum(ismember(possible_positions,data{i}.P{p}{1}(6)))==1
            
            %setup which data to grab based on P info
            ymin=data{i}.P{p}{1}(1)-data{i}.P{p}{1}(3)/2;
            ymax=data{i}.P{p}{1}(1)+data{i}.P{p}{1}(3)/2;
            xmin=data{i}.P{p}{1}(2)-data{i}.P{p}{1}(4)/2;
            xmax=data{i}.P{p}{1}(2)+data{i}.P{p}{1}(4)/2;
            
            if ymin<1; ymin=1; ymax=ymax+1; end
            if ymax==data{i}.fh{7}; ymin=ymin-1; ymax=ymax-1; end
        
            %grab data from P bounds and store in new dsi for output
            dsi{count}.dat{1}=data{i}.dat{1}(ymin:ymax,xmin:xmax);
            dsi{count}.fh=data{1}.fh; 
            dsi{count}.fh{1}=51; 
            dsi{count}.fh{7}=626; 
            dsi{count}.fh{10}=5; 
            dsi{count}.fh{13}=51;
            dsi{count}.th=data{1}.th;
            dsi{count}.th{1}(:,52:601)=[];
        
            % increment counter
            count=count+1;
            
          end
          
       end
        
    end
end
end

