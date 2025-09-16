import mne
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import skew, kurtosis

# -------------------------
# 1️⃣ Load EEG data
# -------------------------
# You can replace this path with your EEG file (.edf, .fif, etc.)
# For demo, we'll use MNE's sample EEG data (Subject 1, run 1)
sample_file = mne.datasets.eegbci.load_data(1, runs=[1])[0]
raw = mne.io.read_raw_edf(sample_file, preload=True)

# Pick only EEG channels (ignore EOG, EMG, etc.)
raw.pick_types(eeg=True)

# Get basic info
sfreq = raw.info["sfreq"]  # sampling frequency
channel = raw.ch_names[0]  # just use first EEG channel for demo
signal = raw.get_data(picks=channel)[0]
time = np.arange(len(signal)) / sfreq

# -------------------------
# 2️⃣ Define EEG bands
# -------------------------
bands = {
    "Delta (0.5-4 Hz)": (0.5, 4),
    "Theta (4-8 Hz)": (4, 8),
    "Alpha (8-13 Hz)": (8, 13),
    "Beta (13-30 Hz)": (13, 30),
    "Gamma (30-45 Hz)": (30, 45),
}

# -------------------------
# 3️⃣ Filter and plot each band
# -------------------------
plt.figure(figsize=(12, 8))
plt.subplot(len(bands) + 1, 1, 1)
plt.plot(time, signal, color="black")
plt.title(f"Original EEG Signal ({channel})")
plt.ylabel("µV")

features = {}

for i, (band, (low, high)) in enumerate(bands.items(), start=2):
    filtered = raw.copy().filter(l_freq=low, h_freq=high, verbose=False)
    band_signal = filtered.get_data(picks=channel)[0]

    plt.subplot(len(bands) + 1, 1, i)
    plt.plot(time, band_signal)
    plt.title(f"{band} Band")
    plt.ylabel("µV")

    # Extract statistical features
    features[band] = {
        "Mean": np.mean(band_signal),
        "Std Dev": np.std(band_signal),
        "Variance": np.var(band_signal),
        "Skewness": skew(band_signal),
        "Kurtosis": kurtosis(band_signal),
        "RMS": np.sqrt(np.mean(band_signal**2)),
        "Band Power": np.mean(band_signal**2),
    }

plt.xlabel("Time (s)")
plt.tight_layout()
plt.show()

print("\nEEG Band Statistical Features:")
for band, feats in features.items():
    print(f"\n{band}:")
    for feat_name, value in feats.items():
        print(f"  {feat_name}: {value:.4f}")
