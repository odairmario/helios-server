from python:3.6
ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

# install databases dependencies
RUN apt update && apt install -y postgresql-client libpq-dev

# setup user and workspace
RUN useradd -m app
WORKDIR /home/app

# Copy
COPY . ./
RUN pip install -r ./requirements.txt

RUN chown app:app -R /home/app
USER app

CMD ["./entrypoint.sh"]
