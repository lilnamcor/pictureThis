import os

if 'RDS_HOSTNAME' in os.environ:
    DATABASES = {
        'default': {
            'ENGINE': 'pyPgSQL.PgSQL',
            'NAME': os.environ['RDS_DB_NAME'],
            'USER': os.environ['RDS_USERNAME'],
            'PASSWORD': os.environ['RDS_PASSWORD'],
            'HOST': os.environ['RDS_HOSTNAME'],
            'PORT': os.environ['RDS_PORT'],
        }
    }
else:
    DATABASES = {
        'default': {
            'ENGINE': 'pyPgSQL.PgSQL',
            'NAME': 'itaireuveni',
            'USER': '',
            'PASSWORD': '',
            'HOST': 'localhost',
            'PORT': 5432,
        }
    }
