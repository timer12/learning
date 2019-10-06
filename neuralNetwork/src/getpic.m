function outputs = getpic(path)
% 处理图片，生成1x1024的矩阵

% 读入图片
pic = imread(path);
% 调整图片大小为32x32
afpic = imresize(pic,[32,32]);

% rgb三个值每个都小于130的像素点设为1，其余设为0
pic_shape = size(afpic);
outputs = [];
for i=1:pic_shape(1)
    for j=1:pic_shape(2)
        if afpic(i,j,1)<=130 && afpic(i,j,2)<=130 && afpic(i,j,3)<=130
            outputs = [outputs 1];
        else
            outputs = [outputs 0];
        end
    end
end
end