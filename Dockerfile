FROM python:3.7-alpine3.13

RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev build-base
RUN mkdir -p /usr/src/aardvark \
    && pip install --upgrade wheel setuptools pip

RUN addgroup aardvark
RUN adduser --disabled-password --ingroup aardvark aardvark
RUN mkdir /etc/aardvark && chown -R aardvark:aardvark /etc/aardvark

WORKDIR /usr/src/aardvark

COPY . /usr/src/aardvark
RUN chown -R aardvark:aardvark /usr/src/aardvark

RUN python setup.py develop
USER aardvark:aardvark
RUN pip install .

ENV AARDVARK_DATA_DIR=/data \
    AARDVARK_ROLE=Aardvark \
    ARN_PARTITION=aws \
    AWS_DEFAULT_REGION=us-east-1

EXPOSE 5000

COPY ./entrypoint.sh /etc/aardvark/entrypoint.sh

ENTRYPOINT [ "/etc/aardvark/entrypoint.sh" ]

CMD [ "aardvark" ]
