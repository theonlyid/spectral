from spectral import contrast
import numpy as np


def test_import():
    module_name = "contrast"
    # print(sys.modules)
    assert module_name in globals()


def test_decimate():
    d = np.zeros((5, 100, 10))
    d_d = contrast.decimate(d, 10)

    assert d.shape[1] // d_d.shape[1] == 10


def test_contrast():
    data = contrast.simulate_recording(
        nchans=10, nsamples=100, nepochs=10, fs=100, nperseg=64, noverlap=40, seed=42
    )

    y = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1]

    snr1, _ = contrast.contrast(data, y, fs=100, npserg=64, noverlap=48)

    snr2, _ = contrast.contrast(data, y[::-1], fs=100, nperseg=64, noverlap=48)

    assert np.unique(snr1.ravel() == snr2.ravel())


test_import()
test_decimate()
test_contrast()
