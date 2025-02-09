# Generated by Django 4.2.4 on 2023-09-05 22:45

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='CallOrderForm',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(verbose_name='Имя пользователя', max_length=200)),
                ('phone', models.IntegerField(verbose_name='Телефон', max_length=200)),
                ('consent', models.BooleanField(default=True, verbose_name='Согласие с политикой конфиденциальности')),
            ],
            options={
                'verbose_name': 'Форма заказать звонок',
                'verbose_name_plural': 'Формы заказать звонок',
            },
        ),
    ]
