#==================================================================
#defines
#==================================================================
x_min 	=    0;
x_max	=    9;
N	=   10;
M	=    3;
p_error =    0.15;
lambda  = [ 5, 10,20];
num_lambda = 3;


#==================================================================
#functions
#==================================================================
function e = err ( var , p_error) 
   	var
	p_error = p_error * 100.0
	r = randi(p_error) 
	e = stdnormal_pdf((100 - r) / 33.0) * var
endfunction

function h = g (x, w)  
	h = w(3)*x.^2 + w(2)*x + w(1); 
endfunction

function y = f (x)
	y = x.^2 + 2*x + 2;
endfunction

function d = get_dataset(s, n, N, M)
	d = [];
	for i=n: +M: N*M
		d = [d s(i)];
	end
endfunction

function s = get_random_signum() 
	i = randi(2);
	if i / 2 == 1	
		s = 1
	else
		s = -1
	end
endfunction


#==================================================================
#main
#==================================================================
#generating x values
x = linspace( x_min, x_max, N*M);


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


#calulcate design matrix
D = [];
for i=1: +1: N*M
	D = [D; 1 x(i) x(i).^2];
end


#calculate and plot regression function
w = [];
for i=1: +1: num_lambda
	w = [w; (inv( D.' * D + lambda(i) * eye(3))* D.' * y.').'];
end


#plot x/y points
plot(x, y, 'x', 'color', [1 0 0]);
hold on;

for i=1: +1: num_lambda
	plot( x, g(x, w(i, :)) );
	hold on;
end

plot(x, f(x), 'color', [0 1 0]);


pause();
