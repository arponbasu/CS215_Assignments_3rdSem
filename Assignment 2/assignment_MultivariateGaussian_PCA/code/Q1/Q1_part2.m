
size = 10^7;
x = zeros(1, size);
y = zeros(1, size);
count=1;
while count<size
        x_random = rand()*pi;
        y_random = rand()*exp(1);
        if(((x_random<pi/3)&&(y_random/x_random<3*exp(1)/pi)) || ((x_random>pi/3)&&(y_random/(pi-x_random)<1.5*exp(1)/pi)))
            x(count) = x_random;
            y(count) = y_random;
            count = count+1;
        end
end

plot = histogram2(x, y, DisplayStyle = "tile");
saveas(plot, "Triangle.png"); 
% histogram2(x, y);
