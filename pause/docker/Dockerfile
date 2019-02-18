FROM registry.example.com/alpine

ENV PORT="3000"

COPY ./app/ /app/

WORKDIR /app

RUN apk add --no-cache \
    python2 \
    py-pip

LABEL name="pause" \
      description="A special image that mocks unfinished projects that are deployed in Kubernetes." \
      os="Alpine Linux" \
      component.name="pause"

ENTRYPOINT []

CMD ["python","/app/app.py"]
