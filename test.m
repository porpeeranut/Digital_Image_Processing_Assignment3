flowerPath = 'Flower_Snack.pgm';
cyclePath = 'cycle_kernel.png';
img = imread(flowerPath);
im2 = img;
[w,h] = size(img);
count_w = 0;
count_circle = 0;
 
% Gaussian Lowpass Filter
FFT = fftshift(fft2(img)); %shift to center
x = (w-1)/2; 
y = (h-1)/2; 
cutoff = 50;
[u,v] = meshgrid(-y:y,-x:x);
D = sqrt(u.^2+v.^2);
HG = double(exp((-(D).^2)./(2.*((cutoff).^2))));
% multiple wit fourier transform
GHG = HG.*FFT; 
% inverse fourier transform
GLPF = round(real(ifft2(ifftshift(GHG))));
circle = GLPF;
img = GLPF;
 
% binary image to find circle
TH_circle = 55;
for i = 1:w      
    for j = 1:h  
        if (circle(i,j) >= TH_circle )
        circle(i,j) = 255;
        count_circle = count_circle+1;
        else
        circle(i,j) = 0;
        end        
    end
end
% binary image to find obj
TH = 230;
for i = 1:w      
    for j = 1:h  
        if (img(i,j) >= TH )
        img(i,j) = 255;
        count_w = count_w + 1;
        else
        img(i,j) = 0;
        end        
    end
end
 
 
Area = 2.60;
Area_w = (Area*count_w)/count_circle
figure;
imshow(img);
figure;
imshow(circle);
figure;
imshow(real(GLPF),[]);
figure;
imhist(im2);
