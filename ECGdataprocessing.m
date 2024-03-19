%% ECG Data Processing

%% Raw Data
load('ECG30.mat');
t = [0:5:31245]';                        % time vector in ms
v = ECG30(:,1);                          % voltage vector from arduino

figure(9);                               % Raw data plot
plot(t,v,'r');
title('Raw data imported from Arduino');
xlabel('Time [ms]');
ylabel('Sample value [-]');

%% Correct time to seconds
t = t./1000;                             % ms --> s

%% Heart Beat plot
figure(1)                                % Heart beat plot
plot(t,v,'r');
title('Heart Beat');
xlabel('Time [s]');
ylabel('Voltage [V]');

%% Find Heart Rate
[TF,P] = islocalmax(v);                  % TF = vector saying value is a local max

figure(8)                                % test plot
plot(t,v,'-r',t,P,'-b');
title('Test for Prominence');
xlabel('Time [s]');
ylabel('Voltage [V] or Prominence');

n = 1;

for i = 1:length(TF)
    if P(i) >= 3.3                         % if the prominence (P) is more than 3.3:
        P(n) = P(i);                       % save it, TF, and t in new vectors
        TF(n) = TF(i);
        t(n) = t(i);
        n = n + 1;                         % move on to next index
    end
end

heart_rate = zeros([1,length(t)-1]);       % allocating space for heart rate

for m = 1:length(t)-1
    heart_rate(m) = 60./(t(m+1)-t(m));     % finding rate between each local max time
    if heart_rate(m) == 12000
        break
    else
        m = m + 1;                         % move on to next index
    end
end

%% Intensity of Heart Beat
amplitude = max(v) - min(v);             % Calculate amplitude of heart rate signal

%% Display results
disp(['Heart Rate: ', num2str(heart_rate), ' bpm']);
disp(['Intensity of Heart Rate Signal: ', num2str(amplitude),' V']);

