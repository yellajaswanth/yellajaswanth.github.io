FROM jekyll/jekyll:latest
WORKDIR /srv/jekyll
EXPOSE 4000
CMD ["jekyll", "serve", "--watch", "--host", "0.0.0.0"]
