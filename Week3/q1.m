% Jens Raaby 
% SIP Exercises 3 
% September 2012
clear all;
clc;



%% Gaussian


mu = 0;
sigma = 0.5;
gaussian = noiseGen1D(100,'gaussian',mu,sigma);

% Plot the histogram and ideal pdf
    h_gaussian = figure;
    [vals,x] = hist(gaussian,50);
    bar(x,vals/trapz(x,vals)); % gets the height to match the histogram
    hold on
    plot(x,normpdf(x,mu,sigma),'r');
    hold off
    legend('Histogram','PDF');
    print(h_gaussian,'-dpdf','report/q1-gaussian.pdf')
    close(h_gaussian);
    
    
% reverse engineer noise parameters
mu_est = mean(gaussian)
sig_est = (std(gaussian))



%% Gamma

a = 1;
b = 1;

gamma = noiseGen1D(100,'gamma',a,b);
% Plot the histogram and ideal pdf
    h_gamma = figure;
    [vals,x] = hist(gamma,50);
    bar(x,vals/trapz(x,vals)); % gets the height to match the histogram
    hold on
    plot(x,pdf('gam',x,a,b),'r');
    hold off
    legend('Histogram','PDF');
    print(h_gamma,'-dpdf','report/q1-gamma.pdf')
    close(h_gamma);
    
    
%test different values for parameter estimation
% for a=1:0.5:10
%     for b=1:10
%         gamma = noiseGen1D(100,'gamma',a,b);
%         distparmgamma = fitdist(gamma,'gamma');
%         a_est = distparmgamma.a;
%         b_est = distparmgamma.b;
%         
%         mean_est = mean(gamma);
%         var_est  = var(gamma);
% 
%         b1 = (mean_est^2/var_est);
%         a1 =  mean_est / var_est;
%         
%         
%         error_fd = ([a_est b_est] - [a b]).^2
%         error_me = ([a1 b1] - [a b]).^2
%     end
% end

% Matlab's own function is far more accurate
distparmgamma = fitdist(gamma,'gamma');
a_est_m = distparmgamma.a;
b_est_m = distparmgamma.b;

mean_est = mean(gamma);
var_est  = var(gamma);
a_est = mean_est/var_est
b_est = (mean_est^2/var_est)



%% Uniform 
a=0;
b=2;
uniform = noiseGen1D(100,'uniform',a,b);

% Plot the histogram and ideal pdf
    h_uniform = figure;
    [vals,x] = hist(uniform,50);
    bar(x,vals/trapz(x,vals)); % gets the height to match the histogram
    hold on
    plot(x,pdf('unif',x,a,b),'r');
    hold off
    legend('Histogram','PDF');
    print(h_uniform,'-dpdf','report/q1-uniform.pdf')
    close(h_uniform);
    
[ahat,bhat] = unifit(uniform);
b = mean(uniform) + (0.5 *(sqrt(12*var(uniform))))
a = (2*mean(uniform)) - b


%% Salt and pepper

type = 'salt&pepper';
size = 100;
Pa = 1/3;
a = 0;
Pb = 2/3;
b = 2;
sandp = noiseGen1D(100,'salt&pepper',a,b,Pa,Pb);

% Plot the histogram
    h_sandp = figure;
    [vals,x] = hist(sandp,100);
    bar(x,vals/trapz(x,vals)); % gets the height to match the histogram
    legend('Histogram');
    print(h_sandp,'-dpdf','report/q1-sandp.pdf')
    close(h_sandp);
    
% estimate from histogram
peaks  = sort(vals,'descend');
a_est  = x(find(vals==peaks(2)))
b_est  = x(find(vals==peaks(1)))
pa_est = peaks(2)/length(vals)
pb_est = peaks(1)/length(vals)
