FROM ubuntu as ikoznov_jekyll
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

# texlive is needed for beautiful TikZ pictures.
# And it is installed first because it's large.
# So it is faster to build Dockerfile with locall changes -
# docker caches this step and do not rerun it.
RUN apt-get -f -y --no-install-recommends install \
    texlive-latex-extra

RUN apt-get -f -y --no-install-recommends install \
    python3 python3-pip \
    ruby rubygems \
    default-jre \
    git git-lfs

RUN apt-get -f -y --no-install-recommends install \
    graphviz \
    pdf2svg

# https://stackoverflow.com/questions/53997175/puppeteer-error-chromium-revision-is-not-downloaded
#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
#RUN npm install -g mermaid.cli --unsafe-perm=true --allow-root
#RUN npm install --global yarn
#RUN yarn global add mermaid.cli

#RUN apt-get -f -y --no-install-recommends install \
#    nodejs npm

#RUN apt-get -f -y --no-install-recommends install \
#    curl wget gnupg ca-certificates
#RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
#    && apt-get install -y nodejs \
#    && npm install -g npm@latest

# Install Mermaid CLI globally
#RUN npm install -g @mermaid-js/mermaid-cli

RUN gem install --no-document \
    asciidoctor \
    asciidoctor-diagram
    # asciidoctor-kroki

# https://chrisfreeman.github.io/gitdags_install.html
RUN echo "TEXMFHOME=/texmf" >> /etc/texmf/texmf.d/00debian.cnf \
    && update-texmf \
    && mkdir -p `kpsewhich -var-value=TEXMFHOME`/tex/latex \
    && cd `kpsewhich -var-value=TEXMFHOME`/tex/latex \
    && git clone https://github.com/Jubobs/gitdags.git --depth 1 \
    && kpsewhich gitdags.sty

RUN apt-get -f -y --no-install-recommends install \
    ruby-dev bundler build-essential

ENV MY_GEMS=/opt/gems
RUN mkdir -p "$MY_GEMS" && cd "$MY_GEMS" \
    && git clone https://github.com/jekyll/minima.git --depth 1
COPY Gemfile /tmp/
RUN cd /tmp/ && bundle install && rm -rf /tmp/*
