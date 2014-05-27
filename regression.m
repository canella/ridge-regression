#! octave-interpreter-name -qf
# a sample Octave program
load values;
lambda = 5;
x = linspace(0,9,10);
variance = 500
plot( x, y, 'o' )
hold on;

y = y+stdnormal_pdf(randi(4)-1)*variance;
expected_value = mean(y);
y = y - expected_value;

w = inv( D.' * D + lambda * eye(3))* D.' * y;

w0 = w(1);
w1 = w(2);
w2 = w(3);


function g (x, w0, w1, w2)  w2*x.^2 + w1*x + w0 endfunction

function e ( x, v ) stdnormal_pdf(x)*v endfunction

plot( x, w2*x.^2 + w1*x +w0 + expected_value )
hold on;
plot( x, y + expected_value, 'x' )

pause();
