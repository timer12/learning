classdef neuralNetwork < handle
    %NEURALNETWORK 神经网络
    %   对数据进行处理，来识别数字
    
    properties
        inodes
        hnodes
        onodes
        wih
        who
        lr
    end
    
    methods
        function obj = neuralNetwork(inputnodes,hiddennodes,outputnodes,learninggrate)
            %NEURALNETWORK 赋值
            
            obj.inodes = inputnodes; % 输入矩阵的大小
            obj.hnodes = hiddennodes; % 隐藏层的数量
            obj.onodes = outputnodes; % 输出个数

            obj.wih = normrnd(0.0,obj.hnodes^(-0.5),[obj.hnodes,obj.inodes]); % 隐藏层
            obj.who = normrnd(0.0,obj.onodes^(-0.5),[obj.onodes,obj.hnodes]); % 输出层

            obj.lr = learninggrate; % 学习率
        end
        
        function train(obj,inputs_list,targets_list)
            %METHOD1 对数据进行训练
            
            % 对数据的结果进行转置
            inputs = inputs_list';
            targets = targets_list';

            hidden_inputs = obj.wih*inputs; % 输入与隐藏层进行点乘
            hidden_outputs = activation_function(hidden_inputs); % 将输出限制在0~1

            final_inputs = obj.who*hidden_outputs; % 隐藏层与输出层点乘
            final_outputs = activation_function(final_inputs); % 将结果限制在0~1
            output_errors = targets - final_outputs; % 结果与实际的差值
            hidden_errors = obj.who'*output_errors; % 隐藏层结果与输出层的差值
            
            % 更新隐藏层和输出层，以获得最佳加权
            obj.who = obj.who+obj.lr*((output_errors.*final_outputs.*(1.0 - final_outputs))*hidden_outputs');
            obj.wih = obj.wih+obj.lr*((hidden_errors.*hidden_outputs.*(1.0 - hidden_outputs))*inputs');
        end
        
        function final_outputs = query(obj,inputs_list)
            % 对未知数据进行预测
            % 代码的意义与训练几乎一样
            
            inputs = inputs_list';
        
            hidden_inputs = obj.wih*inputs;
            hidden_outputs = activation_function(hidden_inputs);

            final_inputs = obj.who*hidden_outputs;
            final_outputs = activation_function(final_inputs);
        end
    end
end

