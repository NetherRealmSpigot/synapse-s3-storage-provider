ARG SYNAPSE_VERSION
FROM ghcr.io/element-hq/synapse:$SYNAPSE_VERSION AS builder

WORKDIR /tmp

COPY scripts ./scripts
COPY LICENSE ./
COPY MANIFEST.in ./
COPY s3_storage_provider.py ./
COPY setup.cfg ./
COPY setup.py ./
COPY test_s3.py ./
COPY tox.ini ./
COPY README.md ./

RUN python -m pip install --upgrade build twine
RUN python -m build


ARG SYNAPSE_VERSION
FROM ghcr.io/element-hq/synapse:$SYNAPSE_VERSION

COPY --from=builder /tmp/dist /tmp/dist
RUN cd /tmp/dist && pip install *.whl && rm -rf /tmp/dist
