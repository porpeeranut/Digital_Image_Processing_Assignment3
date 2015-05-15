crabPath = 'Crab.pgm';
im = imread(crabPath);
bgTH = 65;
flowTH = 210;
[h, w] = size(im)
bg = im;

% Gaussian Lowpass Filter
FFT = fftshift(fft2(im)); % shift to center
y = (w-1)/2; 
x = (h-1)/2; 
cutoff = 36;
[u,v] = meshgrid(-y:y,-x:x);
D = sqrt(u.^2+v.^2);
HG = double(exp((-(D).^2)./(2.*((cutoff).^2))));
% multiple wit fourier transform
GHG = HG.*FFT; 
% inverse fourier transform
imObj = round(real(ifft2(ifftshift(GHG))));
figure('name','Gaussian Lowpass Filter');
imshow(real(imObj),[]);

% binary image to find obj
objPixel = 0;
TH = 215;
for i = 1:h      
    for j = 1:w
        if (imObj(i,j) >= TH )
        imObj(i,j) = 255;
        objPixel = objPixel + 1;
        else
        imObj(i,j) = 0;
        end        
    end
end
figure('name','obj');
imshow(imObj);

% black white bg
for r = 1:h
    for c = 1:w
        if (bg(r,c) > bgTH) && c < w-100
            bg(r,c) = 255;
        else
            bg(r,c) = 140;
        end
    end
end

% find cycle
max = 0;
ansX = 0;
ansY = 0;
ansR = 0;
cycleIm = bg;
for x = 1236:1252
    for y = 847:855
        for r = 820:828
            sum = 0;
            for degree = 1:360
                if (cycleIm(y+round(r*sind(degree)), x+round(r*cosd(degree))) > 10)
                    sum = sum+1;
                end
            end 
            if (max < sum) && (ansR < r)
                max = sum;
                ansX = x;
                ansY = y;
                ansR = r;
            end
        end 
    end        
end
max
ansX
ansY
ansR
max = 360;
ansX = 1236;
ansY = 847;
ansR = 820;

% set to black
for r = 1:h
    for c = 1:w
        cycleIm(r,c) = 0;
    end
end

%   show cycle border
for degree = 0:0.01:360
    im(ansY+round(ansR*sind(degree)), ansX+round(ansR*cosd(degree))) = 0;
    im(ansY+round((ansR-1)*sind(degree)), ansX+round((ansR-1)*cosd(degree))) = 0;
    im(ansY+round((ansR-2)*sind(degree)), ansX+round((ansR-2)*cosd(degree))) = 0;
    im(ansY+round((ansR-3)*sind(degree)), ansX+round((ansR-3)*cosd(degree))) = 0;
    im(ansY+round((ansR-4)*sind(degree)), ansX+round((ansR-4)*cosd(degree))) = 0;
    
    cycleIm(ansY+round(ansR*sind(degree)), ansX+round(ansR*cosd(degree))) = 255;
    cycleIm(ansY+round((ansR-1)*sind(degree)), ansX+round((ansR-1)*cosd(degree))) = 255;
    cycleIm(ansY+round((ansR-2)*sind(degree)), ansX+round((ansR-2)*cosd(degree))) = 255;
    cycleIm(ansY+round((ansR-3)*sind(degree)), ansX+round((ansR-3)*cosd(degree))) = 255;
    cycleIm(ansY+round((ansR-4)*sind(degree)), ansX+round((ansR-4)*cosd(degree))) = 255;
end 
figure('name','ori with border');
imshow(im);

% fill cycle obj
cyclePixel = 0;
for r = 32:h-66
    start = 0;
    filled = 0;
    for c = 1:w
        %   found 1st border
        if (start == 0) && (filled == 0) && (cycleIm(r,c) == 255)
            start = 1;
            cyclePixel = cyclePixel + 1;
            continue
        end
            
        %   fill
        if (start == 1) && (filled == 0) && (cycleIm(r,c) == 0)
            filled = 1;
            cycleIm(r,c) = 255;
            cyclePixel = cyclePixel + 1;
            continue
        end
        if (filled == 1) && (cycleIm(r,c) == 0)
            cycleIm(r,c) = 255;
            cyclePixel = cyclePixel + 1;
            continue
        end
        
        %   found 2nd border
        if (filled == 1) && (cycleIm(r,c) == 255)
            cyclePixel = cyclePixel + 1;
            break
        end
    end
end
figure('name','cycle');
imshow(cycleIm);

objPixel
cyclePixel
area = 2.766;
area = (area*objPixel)/cyclePixel


