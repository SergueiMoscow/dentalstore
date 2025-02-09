# Generated by Django 4.2.4 on 2023-09-21 23:17

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('feedback', '0002_alter_callorderform_name_alter_callorderform_phone'),
    ]

    operations = [
        migrations.CreateModel(
            name='SendMessageForm',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=200, verbose_name='Имя пользователя')),
                ('phone', models.CharField(verbose_name='Телефон', max_length=200)),
                ('email', models.CharField(verbose_name='Email', max_length=200)),
                ('text_message', models.TextField(verbose_name='Сообщение')),
                ('consent', models.BooleanField(default=True, verbose_name='Согласие с политикой конфиденциальности')),
            ],
            options={
                'verbose_name': 'Форма отправить сообщение',
                'verbose_name_plural': 'Формы отправить сообщение',
            },
        ),
    ]
