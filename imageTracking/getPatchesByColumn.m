function [dataOut_col]=getPatchesByColumn(data,col)
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

%600m @ 100m -- 2 patches away 
if col==1
    possible_positions=1:6:78;
elseif col==2
    possible_positions=2:6:78; 
elseif col==3
    possible_positions=3:6:78;
elseif col==4
    possible_positions=4:6:78;
elseif col==5
    possible_positions=5:6:78;
elseif col==6
    possible_positions=6:6:78;
end

%%
% Loop through gathers
for i=1:length(data)

    %Check if there are any patches in this gather,Loop through all patches   
    %For patches in positions matching the column input, store data
    %in the interim matrix as a layer
    if any(strcmp('P',fieldnames(data{i})))==1
       for p=1:length(data{i}.P)
          if ismember(possible_positions,data{i}.P{p}{1}(6))==1
            
            %setup which data to grab based on P info
            ymin=data{i}.P{p}{1}(1)-data{i}.P{p}{1}(3)/2;
            ymax=data{i}.P{p}{1}(1)+data{i}.P{p}{1}(3)/2;
            xmin=data{i}.P{p}{1}(2)-data{i}.P{p}{1}(4)/2;
            xmax=data{i}.P{p}{1}(2)+data{i}.P{p}{1}(4)/2;
            
            if ymin<1; ymin=1; ymax=ymax+1; end
            if ymax==data{i}.fh{7}; ymin=ymin-1; ymax=ymax-1; end
        
            %grab data from P bounds and store in next layer of interim
            %matrix
            d(:,:,count)=data{i}.dat{1}(ymin:ymax,xmin:xmax);
        
            % increment counter
            count=count+1;
            
          end
          
       end
        
    end
    
end


%%
% concatenate interim data layers into a single matrix
dataOut_col=zeros(size(d,1)*count,size(d,2));

%start ybounds
dmin=1;
dmax=size(d,1);

%loop over data layers for each patch
for j=1:count-1 
  dataOut_col(dmin:dmax,:)=d(:,:,j);

  %increment ybounds
  dmin=dmax;
  dmax=dmax+data{3}.P{1}{1}(3);
end

end

