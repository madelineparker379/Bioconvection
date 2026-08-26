function [bestOrder, p, diagnostics] = bestPolyOrder(x, y, maxOrder)
%BESTPOLYORDER Choose polynomial order that best balances fit vs overfitting.
%
%   [bestOrder, p, diagnostics] = bestPolyOrder(x, y, maxOrder)
%
%   Uses leave-one-out cross-validation (LOOCV) as the primary criterion,
%   which is appropriate for small datasets (e.g. 7 points per shape) where
%   a k-fold split would leave too little data to validate against.
%   AIC and BIC are also computed and returned for comparison/sanity-check,
%   but LOOCV RMSE drives the final choice since it directly measures
%   predictive (not just descriptive) error.
%
%   INPUTS
%       x, y     - data vectors (same length, n points)
%       maxOrder - highest polynomial order to consider (default: capped
%                  automatically so order <= n-2, since you need at least
%                  2 points beyond the number of fitted parameters to get
%                  a meaningful held-out test)
%
%   OUTPUTS
%       bestOrder   - polynomial order with lowest LOOCV RMSE
%       p           - polyfit coefficients at bestOrder, fit to ALL data
%       diagnostics - struct with per-order LOOCV RMSE, AIC, BIC, and SSE,
%                     useful for plotting a "model selection" diagnostic
%                     panel or just sanity-checking the choice by eye

    x = x(:); y = y(:);
    n = numel(x);

    if nargin < 3 || isempty(maxOrder)
        maxOrder = max(1, n - 3);   % leave reasonable margin; see note above
    end
    maxOrder = min(maxOrder, n - 2);  % can't sensibly fit order >= n-1 with LOOCV

    looRMSE = nan(maxOrder,1);
    aic     = nan(maxOrder,1);
    bic     = nan(maxOrder,1);
    sse     = nan(maxOrder,1);

    for order = 1:maxOrder
        % --- LOOCV ---
        sqErr = zeros(n,1);
        for i = 1:n
            trainIdx = true(n,1); trainIdx(i) = false;
            pi_ = polyfit(x(trainIdx), y(trainIdx), order);
            yhat = polyval(pi_, x(i));
            sqErr(i) = (yhat - y(i))^2;
        end
        looRMSE(order) = sqrt(mean(sqErr));

        % --- Full-data fit for AIC/BIC/SSE ---
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
