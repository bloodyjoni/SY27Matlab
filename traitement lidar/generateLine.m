function [ lineMatrix ] = generateLine( Xdef,Ydef,Init,End )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    lineMatrix=[];
    index=1;
    if(Xdef~=0)
       for i=Init :End
            lineMatrix(1,index)=Xdef;
            lineMatrix(2,index)=i;
            index = index+1;
       end
    end
    if(Ydef~=0)
        for i=Init :End
            lineMatrix(1,index)=i;
            lineMatrix(2,index)=Ydef;
            index=index+1;
        end
    end
end

