function [bestOrder, p, diagnostics] = bestPolyOrder(x, y, maxOrder)
% Choose polynomial order that best balances fit vs overfitting.
%
% input: 
%   x, y - data vectors (need to be same length, n points)
%   maxOrder - highest polynomial order to consider, 
%              note that by default this is automatically so order <= n-2
%
% output:
%  bestOrder - polynomial order with lowest rmse
%  p - polyfit coeffs at bestOrder, fit to all data
%  diagnostics - struct with per-order LOOCV RMSE, AIC, BIC, and SSE,
%                
    x = x(:); y = y(:);
    n = numel(x);

    if nargin < 3 || isempty(maxOrder)
        maxOrder = max(1, n - 3);  
    end
    maxOrder = min(maxOrder, n - 2);  
    looRMSE = nan(maxOrder,1);
    aic     = nan(maxOrder,1);
    bic     = nan(maxOrder,1);
    sse     = nan(maxOrder,1);

    for order = 1:maxOrder

        sqErr = zeros(n,1);
        for i = 1:n
            trainIdx = true(n,1); trainIdx(i) = false;
            pi_ = polyfit(x(trainIdx), y(trainIdx), order);
            yhat = polyval(pi_, x(i));
            sqErr(i) = (yhat - y(i))^2;
        end
        looRMSE(order) = sqrt(mean(sqErr));

        % Full-data fit for AIC/BIC/SSE 
        pAll = polyfit(x, y, order);
        yfitAll = polyval(pAll, x);
        resid = y - yfitAll;
        sse(order) = sum(resid.^2);
        k = order + 1;  % number of fitted coefficients
        % Guard against sse == 0 (perfect fit / overfit) -> log(0) issue
        sseGuard = max(sse(order), eps);
        aic(order) = n*log(sseGuard/n) + 2*k;
        bic(order) = n*log(sseGuard/n) + k*log(n);
    end

    [~, bestOrder] = min(looRMSE);
    p = polyfit(x, y, bestOrder);

    diagnostics = struct( ...
        'orders',   (1:maxOrder)', ...
        'looRMSE',  looRMSE, ...
        'aic',      aic, ...
        'bic',      bic, ...
        'sse',      sse, ...
        'bestOrder',bestOrder);
end
