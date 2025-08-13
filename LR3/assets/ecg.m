[sig, Fs, tm] = rdsamp('mit bih/100', 1);
plot(sig(1:3600, 1));
duration_sec = 10; % seconds
num_r_peaks = 13;
heart_rate_bpm = (num_r_peaks / duration_sec) * 60;
fprintf('Heart Rate (bpm): %.2f\n', heart_rate_bpm);
r_peak_indices = [78 371 664 948 1232];
rr_intervals = diff(r_peak_indices);
mean_rr_samples = mean(rr_intervals);
fprintf('Mean R-R Interval (samples): %.2f\n', mean_rr_samples);
mean_rr_seconds = mean_rr_samples / 360;
fprintf('Mean R-R Interval (seconds): %.4f\n', mean_rr_seconds);
p_peak_indices = [311 605 885 1164 1467];
pp_intervals = diff(p_peak_indices);
mean_pp_samples = mean(pp_intervals);
fprintf('Mean P-P Interval (samples): %.2f\n', mean_pp_samples);
mean_pp_seconds = mean_pp_samples / 360;
fprintf('Mean P-P Interval (seconds): %.4f\n', mean_pp_seconds);