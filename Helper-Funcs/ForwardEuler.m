function X = ForwardEuler(P, eval_f, x_start, p, eval_u, t_start, t_stop, timestep)
% uses Forward Euler to simulate states model dx/dt=f(x,p,u)
% from state x_start at time t_start
% until time t_stop, with time intervals timestep
% eval_f is a string including the name of the function that evaluates f(x,p,u)
% eval_u is a string including the name of the funciton that evaluates u(t)
%
% X = ForwardEuler(eval_f, x_start, p, eval_u, t_start, t_stop, timestep)

% copyright Luca Daniel, MIT 2018

XTemp = cell(P, ceil((t_stop - t_start) / timestep) + 1);
X = cell(P, ceil((t_stop - t_start) / timestep) + 1);
t = zeros(1,ceil((t_stop - t_start) / timestep) + 1);
X(:,1) = x_start;
t(1) = t_start;
plotNum = 0;
for n=1:ceil((t_stop - t_start) / timestep)
    if mod(n,10) == 0
        plotNum = plotNum + 1;
        [gr markerSizes] = VisualizeNetwork(X(:,n),p);
        % Generate plot handles
        %         figure(1);
        %         pTot = plot(gr,'MarkerSize',markerSizes(1,:),'NodeColor','k','EdgeColor','k');
        %         title(sprintf('Iteration %d',n));
        figure(2); hold on;
        pSus = plot(gr,'MarkerSize',2*markerSizes(2,:),'NodeColor','g','EdgeColor','k');
        title(sprintf('Iteration %d',n));
        %         figure(3); hold on;
        %         pExp = plot(gr,'MarkerSize',markerSizes(3,:),'NodeColor','y','EdgeColor','k');
        %         figure(4); hold on;
        %         pInf = plot(gr,'MarkerSize',markerSizes(4,:),'NodeColor','r','EdgeColor','k');
        %         figure(5); hold on;
        %         pRem = plot(gr,'MarkerSize',markerSizes(5,:),'NodeColor','b','EdgeColor','k');
    end
    dt = min(timestep, (t_stop - t(n)));
    t(n+1)= t(n) + dt;
    u = feval(eval_u, P, t(n));
    f = feval(eval_f, X(:,n), p, u);
    dt_time_f = cellfun(@(a) a*dt, f, 'UniformOutput', false);
    X(:,n+1)= cellfun(@(b, c) b + c, X(:,n), dt_time_f, 'UniformOutput', false);
    
    % XClamp = max([XTemp{:,n}], 0); % Clamp to 0
    % X(:,n+1) = num2cell(XClamp,1)';
end
