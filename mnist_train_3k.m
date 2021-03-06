function [ model_3k ] = mnist_train_3k( imgs, labels )
% This function returns the model trained on the 3k images
% The hyperparameters are obtained from cross validation (see
% cross_validation.m) for details

rand('state',0); 
X = reshape(imgs,400,3000);
image_size = 20;
num_of_classes = 10;
train_size = 3000;
label_matrix = zeros(train_size, num_of_classes);
for i = 1:train_size
    label_matrix(i, labels(i)+1)=1;
end

% Set parameters according to the cross validation results
W=5; % filter size
Q=8; % pooling size
pooling_step = 2; % number of pixels between pooling points
num_for_each = 13;
M=3300;  %number of hidden units

% Get filters
Filters = get_filters(W, image_size, num_of_classes, num_for_each, X, labels);

% Get features
Features = get_conv_features(W, Q, pooling_step, image_size, train_size, X, Filters);clear X

% scaling training features
max_feature = max(max(Features));
Features = sqrt(Features/max_feature);

% train the output layer
[Y_predicted_train,W_in,W_output] = shallowcnn_train(size(Features,1),Features,label_matrix,train_size,labels,M);

% get output layer response and then classify it
[maxvalue,classification_id_train] = max(Y_predicted_train); 

% calculate the error rate on the training set
error_rate_train = 100*(length(find(classification_id_train-1-labels'~=0))/train_size) 

% save the model
model_3k.W = W;
model_3k.Q = Q;
model_3k.pooling_step = pooling_step;
model_3k.Filters = Filters;
model_3k.max_feature = max_feature;
model_3k.W_in = W_in;
model_3k.W_output = W_output;
end

