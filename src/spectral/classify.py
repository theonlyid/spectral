"""
Contains code for classifying timeseries data based on their spectral signatures.
"""

import sklearn
import numpy as np
import scipy

def generate_features(data, labels, **kwargs):
    """
    Generate a feature vector for training a classifier
    
    Parameters
    ----------
    data: array
        array with structure
    labels: array
        vector with class labels
        
    Returns
    -------
    X: array
        an array with the features in the 1st axis and trials on the 0-th axis
    y: array
        a vector with the same number of rows as X containing class labels
    """
    data_array = np.array([])
 
    for trial in range(data.shape[-1]):
        for tbin in range(data.shape[-2]):    # Each timebin
            data_array = np.append(
                data_array, [
                    np.mean(data[:,   :2, tbin, trial], 1).ravel(),
                    np.mean(data[:,  2:9, tbin, trial], 1).ravel(),
                    np.mean(data[:, 9:20, tbin, trial], 1).ravel(),
                    np.mean(data[:, 20:30, tbin, trial], 1).ravel(),
                    np.mean(data[:, 30:,   tbin, trial], 1).ravel()])

    if 'log_transform' in kwargs.items():
        data_array = np.log(np.reshape(data_array, (-1, 30)))
    else:
        data_array = np.reshape(data_array, (-1, 30))

    X = data_array
    y = np.ones(data_array.shape[0])*labels

    return X, y

def classifySVM(self, X, y):
    """
    Trains an SVM-classifier on the data.
    
    Parameters
    ----------
    X: array
        Training data with shape: nobs x features
    y: array
        vector with training labels
        
    Returns
    -------
    scores: array
        a vector of scores with length equal to number of CV-folds
    clf: python object
        the trained classifier as a python object
    """

    ds = np.append(X, y, axis=1)
    np.random.seed(42)
    np.random.shuffle(ds)

    clf = sklearn.svm.SVC(C=1.0, cache_size=200, class_weight='balanced', coef0=0.0,
        decision_function_shape='ovr', degree=3, gamma='scale',
        kernel='rbf', max_iter=-1, probability=True, random_state=42,
        shrinking=True, tol=0.001, verbose=0)
    
    cv = sklearn.model_selection.StratifiedKFold(n_splits=5, random_state=42, shuffle=True)
    print("Performing 5x5 cross-validation on dataset")
    scores = sklearn.model_selection.cross_val_score(clf, X, y, cv=cv, scoring='balanced_accuracy')
    print("cross-validation accuracy: %0.2f (+/- %0.2f CI)" % (scores.mean(), scores.std()*2))

    return scores, clf