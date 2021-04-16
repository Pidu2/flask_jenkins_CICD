FROM tiangolo/uwsgi-nginx-flask:python3.8

COPY requirements.txt /tmp/

RUN pip3 install -U pip
RUN pip3 install -r /tmp/requirements.txt

COPY hello_world.py /app/main.py
