FROM python:3.11

COPY . /app/
WORKDIR /app/dentalstore

RUN pip install -r requirements.txt

RUN python manage.py collectstatic --noinput
#CMD ["python", "dentalstore/manage.py", "runserver", "0.0.0.0.8000"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "dentalstore.wsgi:application"]