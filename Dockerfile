FROM python:3.7-alpine3.13 as builder

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev build-base
RUN mkdir -p /usr/src/aardvark \
    && pip install --upgrade wheel setuptools pip

WORKDIR /usr/src/aardvark

COPY . /usr/src/aardvark
RUN pip install .

FROM python:3.7-alpine3.13

COPY --from=builder /usr/src/aardvark /usr/src/aardvark
WORKDIR /etc/aardvark

ENV AARDVARK_DATA_DIR=/data \
    AARDVARK_ROLE=Aardvark \
    ARN_PARTITION=aws \
    AWS_DEFAULT_REGION=us-east-1

EXPOSE 5000

COPY ./entrypoint.sh /etc/aardvark/entrypoint.sh

ENTRYPOINT [ "/etc/aardvark/entrypoint.sh" ]

CMD [ "aardvark" ]
