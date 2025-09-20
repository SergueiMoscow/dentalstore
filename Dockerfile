FROM python:3.11

COPY . /app/
WORKDIR /app

RUN pip install -r dentalstore/requirements.txt

RUN python dentalstore/manage.py collectstatic --noinput
CMD ["python", "dentalstore/manage.py", "runserver", "0.0.0.0.8000"]
