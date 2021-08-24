from dataclasses import dataclass, field
import numpy as np
import math


@dataclass(frozen=True)
class tsparams:
    """"
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
class data_array:
    fs: int = 100
    data_array: np.ndarray = np.empty((1, 1, 1), dtype=np.float)
    dtype: str = np.float
    nchannels: int = data_array.shape[0]
    ntrials: int = data_array.shape[-1]
    simulate: bool = False

    def __post_init__(self):
        if self.simulate:
            self.simulate_recording(fs=self.fs, nsamples=self.fs)

    def __repr__(self) -> str:
        return f"data_array(shape={self.data_array.shape}, fs={self.fs}, dtype={self.data_array.dtype}, nchannels={self.nchannels}, ntrials={self.ntrials})"

    def generate_ts(self, nsamples=200, fs=100, **kwargs):
        """
        Generates an LFP-like timeseries sampled at fs obeying the power law.
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
        # n *= 100 # make the spectrum stronger

        # Add some LFP-like components

        mix = lambda x, mean, var: 5 * math.exp(-((x - mean) ** 2) / (2 * var ** 2))
        n = n - min(np.real(n))
        mean = np.random.randint(10, len(f))
        var = 3 * len(f) / mean
        n_new = n + [mix(i, mean, var) for i in range(len(n))]
        n_new[1:] = np.array(n_new[1:]) / np.arange(len(n))[1:]

        # generate the timeseries
        s = np.real(np.fft.ifft(n))
        return s

    def simulate_recording(self, **kwargs):
        """
        Simulates an LFP recording with bursts in power of certain bands.
        """

        if "nchans" in kwargs:
            nchans = int(kwargs["nchans"])
        else:
            nchans = 10

        if "nsamples" in kwargs:
            nsamples = int(kwargs["nsamples"])
        else:
            nsamples = 1000

        if "fs" in kwargs:
            fs = int(kwargs["fs"])
        else:
            fs = 100

        if "nepochs" in kwargs:
            nepochs = int(kwargs["nepochs"])
        else:
            nepochs = 10

        if "seed" in kwargs:
            seed = int(kwargs["seed"])
        else:
            seed = np.random.uniform(1, 100)

        # create empty array
        dat = np.empty((nchans, nsamples))

        # fill array with pink noise
        for i in range(dat.shape[0]):
            dat[i, :] = self.generate_ts(nsamples=nsamples, fs=fs, seed=seed)

        dat = np.repeat(dat[:, :, np.newaxis], nepochs, axis=-1)

        self.data_array = dat
        self.nchannels = dat.shape[0]
        self.ntrials = dat.shape[-1]


@dataclass
class dataset:
    data: data_array = field(default_factory=data_array)
    params: tsparams = field(default_factory=tsparams)


def main():
    params = tsparams(nperseg=64, noverlap=48)
    da = data_array(fs=1000, simulate=True)
    data = dataset(da, params)
    return data


if __name__ == "__main__":
    data = main()
    print(data)
