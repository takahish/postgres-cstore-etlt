# postgres-cstore-notebook

A docker image and container of notebook with the columnar store ([postgres-cstore](https://github.com/takahish/postgres-cstore)). 

## Table of content

- [Bulding steps](#Building-steps)
    - [Build image from docker-compose](#Build-image-from-docker-compose)
    - [Run container](#Run-container)

## Building steps

### Build image from docker-compose

You don't need to build the image if you use the image from the docker hub. But you can build the image manually. Here are the build steps.

```shell
# Clone this repository.
$ git clone https://github.com/takahish/postgres-cstore-notebook.git

# Update submodules.
$ git submodule update --init --recursive

# Build postgres-cstore image.
$ docker-compose -f docker-compose-for-build.yml build
```

### Run container

```shell
# Detach posgres-cstore.
# Here is the commands if you build image manually.
$ docker-compose -f docker-compose-for-build.yml up -d

# ... or you can run the container directly from the image from the docker hub.
# After this step, I will describe the topics using the image from the docker hub.
$ docker-compose up -d
```

## Usage notebook with postgres-cstore

You can access http://localhost:8888/login?token=nbuser and open Jupyter-labs. Installed libraries are below,

- PostgreSQL with columnar store.
    - https://github.com/takahish/postgres-cstore
    - You can connect data warehouse with python client.
- Originally scipy-notebook has the basic python libraries such as,
    - Everything in jupyter/minimal-notebook and its ancestor images
    - altair, beautifulsoup4, bokeh, bottleneck, cloudpickle, conda-forge::blas=*=openblas, cython, dask, dill, h5py, matplotlib-base, numba, numexpr, pandas, patsy, protobuf, pytables, scikit-image, scikit-learn, scipy, seaborn, sqlalchemy, statsmodel, sympy, widgetsnbextension, xlrd packages
    - ipympl and ipywidgets for interactive visualizations and plots in Python notebooks
    - Facets for visualizing machine learning datasets
- In addition to the scipy-notebook's libraries, some deep learing libraries such as,
    - pymc3, xgboost, lightgbm, shap
    - tensorflow, tensorboard, tensorflow-probability for CPU setting
    - torch, torchvision, torchaudio, torchtext for CPU setting

Especially, GPU settings for TensorFlow and PyTorch will be set in the future.
