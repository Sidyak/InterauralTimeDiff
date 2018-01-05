clear
clc
close all
% https://www.pa.msu.edu/acoustics/woodworth.pdf

audioIn = 'test.wav';
[x, Fs] = audioread(audioIn);
% some init values
T = 1/Fs; % sample rate 
a = 0.08; % head radius
c = 340;  % speed of sound / m/s
% usage of sound direction:
% -90 <= left < 0 > right >= +90 
angle = -90; % azimut angle from where the sound source appears
if(angle < 0)
    angle = abs(angle);
    left = true;
else
    left = false;
end
teta = angle * pi/180;
if(0 <= teta && teta <= pi/2)
    ITD = a/c * (teta + sin(teta))
else % source in the back
    ITD = a/c * (pi - teta + sin(teta))
end

samplesDelay = ceil(ITD / T) % samples delay at given ITD
% do the delay in freq.-domain
N = length(x);
h = zeros(length(x),1);
%samplesDelay = 100;
h(samplesDelay) = 1;
X = fft(x, N);
H = fft(h, N);
xy = ifft(X .* H);
% plot the delay
figure
subplot(211),plot(x)
xlim([1.5e3 samplesDelay+2.5e3])% -0.5 0.5] )
subplot(212),plot(xy)
xlim([1.5e3 samplesDelay+2.5e3])% -0.5 0.5])

if(left)
    yL = x;
    yR = xy; % apply to right channel
else
    yL = xy; % apply to left channel
    yR = x;
end

y = [yL yR];
player = audioplayer(y,Fs);
stop(player);
play(player);
