function RMS = RMSError_measure(output, target, norm_mod)
% function RMSError_measure(output, target, targetVar)
NULL_MODEL     =0;
STANDARD_RMS   =1;
ROOT_NULL_MODEL=2;

if norm_mod==NULL_MODEL
    %% 1-R^2: sum of square errors/total sum of squares
    % http://scott.fortmann-roe.com/docs/MeasuringError.html
    % sum of square errors = sum(output_i,target_i).^2
    % total sum of squares = sum(target_mean-target_i).^2
    RMS=RMSError(output, target);
elseif norm_mod==STANDARD_RMS
    % standard RMS
    RMS=sqrt(RMSError(output, target,length(target)));
elseif norm_mod==ROOT_NULL_MODEL
    % like NULL_MODEL but with square root
    RMS=sqrt(RMSError(output, target));
end