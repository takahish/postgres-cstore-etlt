# scipy-notebook version is 3.10.5 (stable at 2022/06/27).
# See also https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
FROM scipy-notebook:3.10.5

LABEL maintainer "Hiro Ishikawa <takahiro.ishikawa@cons.jp>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

# Updated apt-get and insall postgresql.
# We need the PostgreSQL to manipulate a postgres-cstore server as a client.
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    postgresql && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# scipy-notebook has the basic python libraries such as,
#   - Everything in jupyter/minimal-notebook and its ancestor images
#   - altair, beautifulsoup4, bokeh, bottleneck, cloudpickle, conda-forge::blas=*=openblas, cython, dask, dill,
#     h5py, matplotlib-base, numba, numexpr, pandas, patsy, protobuf, pytables, scikit-image, scikit-learn, scipy,
#     seaborn, sqlalchemy, statsmodel, sympy, widgetsnbextension, xlrd packages
#   - ipympl and ipywidgets for interactive visualizations and plots in Python notebooks
#   - Facets for visualizing machine learning datasets

# We add some machine learning or probablistic modeling packages for the our experiments.
RUN arch=$(uname -m) && \
    if [ "${arch}" == "aarch64" ]; then \
        # Prevent libmamba from sporadically hanging on arm64 under QEMU
        # <https://github.com/mamba-org/mamba/issues/1611>
        export G_SLICE=always-malloc; \
    fi && \
    mamba install --quiet --yes \
    'pymc3' \
    'xgboost' \
    'lightgbm' \
    'tensorflow' \
    'tensorboard' \
    'tensorflow-probability' \
    'shap' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# We add other machine learning packages for the our experiments.
# The package dependence of the PyTorch is very strict in mamba install. So we add the PyTorch
# and related packages using pip. It will need packages in mamba install if we use GPU.
RUN pip install --no-cache-dir \
    'torch' \
    'torchvision' \
    'torchaudio' \
    'torchtext' \
    'torchinfo' \
    --extra-index-url https://download.pytorch.org/whl/cpu && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# We add a postgres_cstore package for python into the system site-packages.
# See also https://github.com/takahish/postgres-cstore
COPY lib/postgres-cstore/postgres_cstore/ /opt/conda/lib/python3.10/site-packages/postgres_cstore
