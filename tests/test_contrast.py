from spectral import contrast, data_handling
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
    params = data_handling.TsParams(nperseg=64, noverlap=48)
    da = data_handling.DataArray(fs=1000, nchannels=10, ntrials=10, simulate=True)
    ds = data_handling.Dataset(da, params)

    ds.data_array.data = contrast.decimate(ds.data_array.data, 10)
    ds.data_array.fs = ds.data_array.fs // 10

    y = np.array([0, 0, 0, 0, 0, 1, 1, 1, 1, 1])

    snr1, _ = contrast.contrast(ds, y, fs=100, npserg=64, noverlap=48)
    snr2, _ = contrast.contrast(ds, y[::-1], fs=100, nperseg=64, noverlap=48)

    assert np.unique(snr1.ravel() == snr2.ravel())


test_import()
test_decimate()
test_contrast()
