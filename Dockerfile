FROM ruby:4.0.6-bookworm
RUN apt-get update && apt-get install -y --no-install-recommends \
    imagemagick nodejs python3 python3-venv \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /srv/jekyll
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY requirements.txt ./
RUN python3 -m venv /opt/notebooks && /opt/notebooks/bin/pip install -r requirements.txt
ENV PATH="/opt/notebooks/bin:${PATH}"
EXPOSE 4000
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0"]
