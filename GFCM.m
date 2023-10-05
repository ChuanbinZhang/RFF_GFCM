function [class, centroid, U, obj] =GFCM(super_label, data, num_p, A, options)
%% check  input variants
if min(size(data))<1
    error('Imput data of image, not an image ');
end

default_options = [
    0.2;	% fuzzy degree.
    0;  % n_cluster. number of clusters
    100;	% max. number of iteration
    1e-4;	% min. amount of improvement
    0;      % verbose
    ];
if nargin ==4
    options = default_options;
else
    % If "options" is not fully specified, pad it with default values.
    if length(options) < 5
        tmp = default_options;
        tmp(1:length(options)) = options;
        options = tmp;
    end
    % If some entries of "options" are nan's, replace them with defaults.
    nan_index = find(isnan(options)==1);
    options(nan_index) = default_options(nan_index);
end

alpha = options(1);
n_cluster=options(2);
max_iter = options(3);      % Max. iteration
min_impro = options(4);     % Min. improvement
verbose = options(5);
[n_data,dim] = size(data);

obj = zeros(max_iter, 1);
% Initialization
U = initfcm(n_cluster, n_data);			% Initial fuzzy partition
Sj=ones(n_cluster,1)*num_p';
W=A.*(ones(n_data,1)*num_p');
sumW=ones(n_cluster,1)*sum(W, 2)';
for i = 1:max_iter
    Sj_u = Sj.*U;
    centroid = Sj_u*data./((ones(dim, 1)*sum(Sj_u'))');
    
    % Calculate distance
    out = zeros(n_cluster, n_data);
    for k = 1:size(centroid, 1)
        centorid_k = ones(n_data, 1)*centroid(k, :);
        out(k, :) = sum(((data-centorid_k).^2)');
    end
    dist=out+eps;

    pi=(W*U')'./sumW;
    %% Objective function
    if verbose ~= 0
        obj(i) = trace(Sj_u * dist') + alpha * trace(Sj_u * log(U./pi)');
    end
    % Update U
    exp_d = pi.*exp(-dist./alpha);
    U=exp_d./(ones(n_cluster,1)*sum(exp_d,1));
    
    % Compute the objective function value and test termination criteria
    Uc{i}=U;
    if i> 1
        if abs(max(max(Uc{i} - Uc{i-1}))) < min_impro
            if verbose ~= 0
                val = trace(Sj_u * dist') + alpha * trace(Sj_u * log(U./pi)');
                for it=i+1:max_iter
                    obj(it) = val;
                end
            end
            break;
        end
    end
end
obj = obj';
class=get_class(U, super_label);
end

function class=get_class(U, super_label)
[~,max_idx]=max(U);
class=zeros(size(super_label,1),size(super_label,2));
for i=1:max(super_label(:))
    class=class+(super_label==i)*max_idx(i);
end
end
