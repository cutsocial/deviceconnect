# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


FROM python:3.14.0a3-slim

ENV PYTHONUNBUFFERED True
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

# A dummy echo to trigger a rebuild
RUN echo "Triggering rebuild"

# Install production dependencies.
# Arman added gcc and python3-dev to install the required packages for the psycopg2 library
RUN apt-get update && apt-get install -y gcc python3-dev

RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_ENV=PRODUCTION

CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app.main:app
