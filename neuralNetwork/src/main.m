% 使用神经网络来识别手写数字
% 数据为0/1，白色部分为0，黑色部分为1.
% digit-training.txt为训练数据
% digit-testing.txt为测试数据
% digit-predict.txt为进行识别的数据
clear;clc;

% 判断是否已经存在训练好的神经网络
y_n = 1;
if exist('network.mat','file')
    y_n = input('训练好的神经网络已存在，是(1)否(0)重新训练、测试:');
end

if y_n == 1
    % 设置训练参数
    input_nodes = 1024; % 输入数据大小
    hidden_nodes = 100; % 隐藏层数量
    output_nodes = 10; % 输出个数
    learning_rate = 0.4; % 学习率

    n = neuralNetwork(input_nodes,hidden_nodes,output_nodes,learning_rate);

    % 训练神经网络
    disp('Beginning of geting training data');

    % 得到训练数据
    trainfile = fopen('../data/digit-training.txt','r');
    train_data = getData(trainfile);
    fclose(trainfile);

    % 设置标签
    trainmenu = [0 0 0 0 0 0 0 0 0 0];
    data_shape = size(train_data);

    disp('Beginning of Training');
    % 对每个数据都进行训练来获得最佳加权
    for i = 1:data_shape(1)
        all_values = train_data(i,:);
        trainmenu(all_values(1025)+1) = trainmenu(all_values(1025)+1)+1;% 对每个数字进行计数
        % 将为0的值改为0.01，1的值改为1
        inputs = (all_values(1:1024)*0.99)+0.01;
        % 设置目标值
        targets = zeros(1,output_nodes)+0.01;
        targets(all_values(end)+1)= 0.99;
        n.train(inputs,targets)
    end

    % 将训练完的神经网络储存下来
    save network.mat n;

    % 测试神经网络
    disp('Beginning of geting testing data');

    % 得到测试数据
    testfile = fopen('../data/digit-testing.txt','r');
    % testfile = fopen('./test.txt','r');
    test_data = getData(testfile);
    fclose(testfile);

    % 设置标签
    testmenu = [[0 0];[0 0];[0 0];[0 0];[0 0];[0 0];[0 0];[0 0];[0 0];[0 0]];
    data_shape = size(test_data);

    disp('Beginning of testing');
    % 对每个数据进行测试，看结果与真实值是否一致
    for i = 1:data_shape(1)
        all_values = test_data(i,:);
        real_digit = all_values(end);
        % 将为0的值改为0.01，1的值改为1
        inputs = (all_values(1:1024)*0.99)+0.01;
        % 进行识别
        outputs = n.query(inputs);
        [value,predict_digit] = max(outputs(:));
        % 对结果进行判断，并存入数组中。
        if (predict_digit-1) == real_digit
            testmenu(real_digit+1,1) = testmenu(real_digit+1,1)+1;
        else
            testmenu(real_digit+1,2) = testmenu(real_digit+1,2)+1;
        end 
    end

    % 输出训练数据
    disp('----------------------------');
    disp('        Training Info       ');
    disp('----------------------------');
    for i = 1:10
        disp(['           ',num2str(i-1),' : ',num2str(trainmenu(i))]);
    end

    % 输出测试结果
    disp('----------------------------');
    disp('        Testing Info        ');
    disp('----------------------------');
    right = 0;
    wrong = 0;
    for i = 1:10
        disp(['        ',num2str(i-1),' : ',...
            num2str(100*testmenu(i,1)/(testmenu(i,1)+testmenu(i,2))),'%'])
        right = right + testmenu(i,1);
        wrong = wrong + testmenu(i,2);
    end
    disp('----------------------------');
    disp(['right/wrong=',num2str(right),'/',num2str(wrong),' '...
        ,num2str(100*right/(right+wrong)),'%']);
    disp('----------------------------');
else
    load('network.mat');
end

% 判断是读入图片还是使用数据
readpic = input('是(1)否(0)使用图片(白底黑数字):');

if ~readpic
    % 对数据进行识别
    predictfile = fopen('../data/digit-predict.txt','r');
    predict_data = getData(predictfile);
    fclose(predictfile);

    % 输出要识别的数字的总数
    data_shape = size(predict_data);
    disp(['要识别数字的总数:',num2str(data_shape(1))]);

    while 1
        % 输入要识别的序号
        index = input('请输入序号[退出请输入0]:');

        % 判断是否退出
        if index == 0
            break;
        end

        % 判断序号
        while (index<1) || (index>12)
            index = input('输入不在1~12之间，请重新输入:');
        end

        % 进行识别,并输出
        all_values = predict_data(index,:);
        inputs = (all_values(1:1024)*0.99)+0.01;
        outputs = n.query(inputs);
        [value,predict_digit] = max(outputs(:));
        disp(['识别结果:',num2str(predict_digit-1)]);
        plotDigit(all_values(1:1024));
    end
else
    while 1
        path = input('请输入图片的绝对路径(路径加引号)[退出请输入0]：');
        
        % 判断是否退出
        if path == 0
            break;
        end
        
        % 判断图片是否存在
        while ~exist(path,'file')
            path = input('图片不存在：');
        end
        
        % 进行识别,并输出
        all_values = getpic(path);
        inputs = (all_values(1:1024)*0.99)+0.01;
        outputs = n.query(inputs);
        [value,predict_digit] = max(outputs(:));
        disp(['识别结果:',num2str(predict_digit-1)]);
        plotDigit(all_values(1:1024));
    end
end