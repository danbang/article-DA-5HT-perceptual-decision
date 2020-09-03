function [ste,t,whom] = ste(dat)
% function [ste,t,whom] = ste(dat)
%
% tor wager 
%
% standard error of the mean
% and t-values, columnwise
%
% omits NaN values row-wise
%
% does NOT use n - 1
% matches matlab t-test function

warning off MATLAB:divideByZero

whom = find(any(isnan(dat),2));
if ~isempty(whom), dat(whom,:) = [];, end

m = mean(dat);
ste = std(dat) ./ sqrt(size(dat,1));

t = m ./ ste;

warning on MATLAB:divideByZero

return