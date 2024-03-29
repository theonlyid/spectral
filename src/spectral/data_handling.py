"""
Module that handles the various data structures used by the package.
"""

from dataclasses import dataclass, field
import numpy as np
import math


@dataclass(frozen=True)
class TsParams:
    """
    Object that stores the various timeseries parameters:
    
    Fields:
    -------
    nperseg: int
        number of samples used per fft when stft is performed
    noverlap: int
        number of samples of oveerlap in stft    
    """

    nperseg: int
    noverlap: int


@dataclass
class DataArray:
    """
    Object that stores the timeseries data and relevant parameters:
    
    Fields:
    -------
    data: numpy.ndarray
        numpy array with timeseries data shaped (nchannels x timepoints x ntrials)
    dtype: np.dtype
        the data type in the data array (usually np.float64)
    fs: int
        the sampling frequency of the timeseries data
    ntrials: int
        number of trials in data (computed from 'data' unless simulate=True)
    nchannels: int
        number of channels in the data (computed from 'data' unless simulate=True)
    simulate: bool (default=False)
        Flag that causes the class to generate synthetic data if True.
    """

    data: np.ndarray = np.empty((1, 1, 1), dtype=np.float)
    dtype: np.dtype = np.float64
    fs: int = 100
    nchannels: int = data.shape[0]
    ntrials: int = data.shape[-1]
    simulate: bool = False

    def __post_init__(self):
        if self.simulate:
            self.data = self.simulate_recording(
                fs=self.fs,
                nsamples=self.fs,
                ntrials=self.ntrials,
                nchannels=self.nchannels,
            )

    def __repr__(self) -> str:
        return f"DataArray(shape={self.data.shape}, fs={self.fs}, dtype={self.data.dtype}, nchannels={self.nchannels}, ntrials={self.ntrials})"

    @classmethod
    def generate_ts(cls, fs: int = 100, nsamples: int = 1000, **kwargs) -> np.ndarray:
        """
        Generates a single LFP-like timeseries sampled at fs obeying the power law.
        """
        # For unit test
        if "seed" in kwargs:
            seed = int(kwargs["seed"])
        else:
            seed = np.random.uniform(1, 100)

        # Generate some pink noise
        t = np.arange(nsamples)  # timesteps
        f = 2 * np.pi * t / fs  # frequency (in radians)

        # generate random complex series
        n = np.zeros((nsamples,), dtype=complex)
        np.random.seed = seed
        n = np.exp(1j * (2 * np.pi * np.random.rand(nsamples,)))
        n[0] = 0
        n *= 100  # make the spectrum stronger

        # Add some LFP-like components (:TODO:)
        # mix = lambda x, mean, var: 5 * math.exp(-((x - mean) ** 2) / (2 * var ** 2))
        # n = n - min(np.real(n))
        # mean = np.random.randint(10, len(f))
        # var = 3 * len(f) / mean
        # n_new = n + [mix(i, mean, var) for i in range(len(n))]
        # n_new[1:] = np.array(n_new[1:]) / np.arange(len(n))[1:]

        # Take a random part of the signal and amplify it
        peak = np.random.random()
        idx_enhanced = int(len(f) * peak)
        n[idx_enhanced] *= 100

        # generate the timeseries
        s = np.real(np.fft.ifft(n))
        return s

    @classmethod
    def simulate_recording(
        cls, nchannels=10, nsamples=1000, fs=100, ntrials=10, **kwargs
    ) -> np.ndarray:
        """
        Simulates a multi-channel LFP recording with bursts in power of certain bands.
        """

        if "seed" in kwargs:
            seed = int(kwargs["seed"])
        else:
            seed = np.random.uniform(1, 100)

        # create empty array
        dat = np.empty((nchannels, nsamples))

        # fill array with pink noise
        for i in range(dat.shape[0]):
            dat[i, :] = cls.generate_ts(fs=fs, nsamples=nsamples, seed=seed)

        dat = np.repeat(dat[:, :, np.newaxis], ntrials, axis=-1)

        return dat


@dataclass
class Dataset:
    data_array: DataArray = field(default_factory=DataArray)
    params: TsParams = field(default_factory=TsParams)


def main() -> None:
    """
    Method that demonstrates how to generate the Dataset object.
    """
    params = TsParams(nperseg=64, noverlap=48)
    da = DataArray(fs=100, nchannels=12, ntrials=20, simulate=True)
    ds = Dataset(da, params)
    print(ds)


if __name__ == "__main__":
    main()
