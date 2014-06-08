#==================================================================
#defines
#==================================================================
x_min 	=    0;
x_max	=    9;
N	=   20;
M	=    3;

p_error =    0.15;

lambda_min = 0;
lambda_max = 6;
num_lambda  = 19;
num_plot_lambda = 3;

color_validation = [0 0 0];
color_original   = [0 1 0];
color_regression = ['r' 'm' 'c'];
#==================================================================
#functions
#==================================================================
function e = err ( var , p_error) 
	e = stdnormal_pdf((100 - randi(p_error * 100.0)) / 33.0) * var;
endfunction

function h = g (x, w)  
	h = w(3)*x.^2 + w(2)*x + w(1); 
endfunction

function y = f (x)
	y = x.^2 + 2*x + 2;
endfunction

function d = calc_designmatrix(x, n)
	d = [];
	for i=1: +1: n
		d = [d; 1 x(i) x(i).^2];
	end
endfunction

function w = calc_regressioncoeffs(d, l, r, weighted_average)
	w = (inv( d.' * d + l * eye(3))* d.' * ( r.' - weighted_average )).';
endfunction

function d = get_validationset(s, n, N, M)
	d = [];
	for i=n: +M: N*M
		d = [d s(i)];
	end
endfunction

function d = get_trainingset(s, n, N, M)
	d = [];
	for i=1: +1: N*M
		if(mod(i,M) != 0)
			d = [d s(i)];
		end
	end
endfunction

function s = get_random_signum() 
	i = randi(2);
	if mod(i,2) == 0
		s =  1;
	else
		s = -1;
	end
endfunction

function m_idx = get_minimum_idx(a, n) 
	m = a(1);
	m_idx = 1;
	
	for i=2: +1: n
		if a(i) < m
			m = a(i);
			m_idx = i;
		end
	end
endfunction


#==================================================================
#calculations
#==================================================================
#generating x values
x = linspace( x_min, x_max, N*M);

#generating lambda_values
lambda = logspace( lambda_min, lambda_max, num_lambda );

#generating dataset of size N*M
y = [];
for i=1: +1: N*M
	y = [y f(x(i))];
end


#add variance
variance = var(y);
for i=1: +1: N*M
	y(i) = y(i) + (err(variance, p_error) * get_random_signum()) ;
end


#init empty error
lambda_error = [];
for(i=1: +1: num_lambda)
	lambda_error = [lambda_error 0];
end

#calculate median error per lambda through cross validation
for i=1: +1: M
	t_y = get_trainingset  (y, i, N, M);
	t_x = get_trainingset  (x, i, N, M);
	v_y = get_validationset(y, i, N, M);
	v_x = get_validationset(x, i, N, M);

	d = calc_designmatrix(t_x, N*(M-1));
	for j=1: +1: num_lambda
		w = calc_regressioncoeffs(d, lambda(j), t_y, mean( t_y ));
		lambda_error(j) = lambda_error(j) + (abs(mean(g(v_x,w)) - mean(v_y)));
	end
end

#==================================================================
#output - textual
#==================================================================
printf("\n==================================================\n");
printf("Regularization Optimization\n");
printf("==================================================\n");
idx_best = get_minimum_idx(lambda_error, num_lambda);
for i=1: +1: num_lambda
	printf("lambda value:\t%3d summed error:\t %3.2f", lambda(i), lambda_error(i))
	if i == idx_best
		printf(" <-- best regularization parameter\n");
	else
		printf("\n");
	end
end
printf("\n");

#==================================================================
#output - plotting
#==================================================================
t_y = get_trainingset  (y, 1, N, M);
t_x = get_trainingset  (x, 1, N, M);
v_y = get_validationset(y, 1, N, M);
v_x = get_validationset(x, 1, N, M);

figure(1)
title("Ridge Regression");
plot(v_x, v_y, 'x', 'color', color_validation)
hold on;
plot(t_x, f(t_x), 'color', color_original)
hold on;

d = calc_designmatrix(t_x, N*(M-1));

plot_lambda = [ lambda(mod(idx_best - idivide(num_lambda,2), num_lambda) + 1);
		lambda(idx_best);
		lambda(num_lambda - mod(idx_best + idivide(num_lambda,2), num_lambda) + 1) ];
		


for i=1: +1: num_plot_lambda
	w = calc_regressioncoeffs(d, plot_lambda(i), t_y, 0);
	plot(t_x, g(t_x, w), 'color', color_regression(i))
	hold on;
end
legend( 'validation', 'original', int2str(plot_lambda(1)), int2str(plot_lambda(2)), int2str(plot_lambda(3)) );

print("small_f_plot.jpg")

hold off
figure(2);
semilogx( lambda, lambda_error )

print("log_small_f.jpg")

pause();
