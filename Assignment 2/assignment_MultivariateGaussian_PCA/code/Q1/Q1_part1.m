x_range = 1;
y_range = 2;
size = 10^7;
x = zeros(1, size);
y = zeros(1, size);
count=1;
while count<size
        x_random = rand()*x_range-x_range/2;
        y_random = rand()*y_range-y_range/2;
        if((x_random^2/x_range^2+y_random^2/y_range^2) < 1/4)
            x(count) = x_random;
            y(count) = y_random;
            count = count+1;
        end
end

plot = histogram2(x, y, DisplayStyle = "tile");
saveas(plot, "Ellipse.png"); 
%histogram2(x, y);
