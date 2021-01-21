from . import contrast
import numpy as np

def test_contrast():
    data = contrast.simulate_recording(
        nchans=10,
        nsamples=100,
        nepochs=10,
        fs=100,
        nperseg=640,
        noverlap=480,
        seed=42)

    y = [0,0,0,0,0, 1,1,1,1,1]

    snr1, _ = contrast.contrast(data, y,
                               fs=100, npserg=64, noverlap=48)
    
    snr2, _ = contrast.contrast(data, y[::-1], 
                               fs=100, nperseg=64, noverlap=48)
    
    assert np.unique(snr1.ravel() == snr2.ravel())
