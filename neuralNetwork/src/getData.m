function data = getData(infile)
%得到数据
s = fscanf(infile,'%s');

count1 = 0;count2 = 0;
data = [];indata = [];

% 每1024个0/1为一个数字，每个数字占一行。
% 最后一个为该数字的值(预测的数据最后一个都是9)。
for i=s
    if count1~=32
        indata = [indata str2num(i)];
        count1 = count1+1;
    else
        count2 = count2+1;
        if count2 == 32
            indata = [indata str2num(i)];
            data = [data;indata];
            indata = [];
            count2 = 0;
            count1 = 0;
        else
            indata = [indata str2num(i)];
            count1 = 1;
        end
    end  
end

end