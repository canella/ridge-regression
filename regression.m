x_min =    0;
x_max =    9;
x_cnt =   10;

lambda = [ 5, 10,20];
num_lambda = 3;
var = 50;

#functions
#====================================================
function e = err ( var ) 
	e = stdnormal_pdf(randi(4)-1)*var;
endfunction

function h = g (x, w0, w1, w2)  
	h = w2*x.^2 + w1*x + w0; 
endfunction

function y = f (x)
	y = x.^2 + 2*x + 2;
endfunction


#generating x values 
x = linspace( x_min, x_max, x_cnt);

#generating y values
y = [];
for i=1: +1: x_cnt
	y = [y; f(x(i)) + err(var)]; #does randi need initializiation??
end

#centering y values
mean_y = mean(y);
#y = y - mean_y;


#calulcate design matrix
D = [];
for i=1: +1: x_cnt
	D = [D; 1 x(i) x(i).^2];
end


#calulcate coefficients and draw regression function
setenv("GNUTERM","")
plot( x, y + mean_y, 'x' );
hold on;	
for i=1: +1: num_lambda
	w = inv( D.' * D + lambda(i) * eye(3))* D.' * y;

	#plot( x, g(x, w(1) + mean_y, w(2), w(3)) );
	plot( x, g(x, w(1) + mean_y, w(2), w(3)) );
	hold on;
end

pause();
