FROM ruby:3.0.2

WORKDIR /ping_server
COPY . /ping_server
RUN bundle install

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
