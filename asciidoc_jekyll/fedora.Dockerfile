FROM fedora:latest as ikoznov_jekyll

RUN dnf update -y

# texlive is needed for beautiful TikZ pictures.
# And it is installed first because it's large.
# So it is faster to build Dockerfile with locall changes -
# docker caches this step and do not rerun it.
RUN dnf install -y \
    texlive-collection-latexextra

RUN dnf install -y \
    python3 python3-pip \
    ruby rubygems \
    java-latest-openjdk \
    git git-lfs

RUN dnf install -y \
    graphviz \
    pdf2svg

# https://stackoverflow.com/questions/53997175/puppeteer-error-chromium-revision-is-not-downloaded
#ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
#RUN npm install -g mermaid.cli --unsafe-perm=true --allow-root
#RUN npm install --global yarn
#RUN yarn global add mermaid.cli

#RUN apt-get -f -y install \
#    nodejs npm

#RUN apt-get -f -y install \
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
RUN echo "TEXMFHOME=/texmf" >> /etc/texlive/texmf.d \
    && mkdir -p `kpsewhich -var-value=TEXMFHOME`/tex/latex \
    && cd `kpsewhich -var-value=TEXMFHOME`/tex/latex \
    && git clone https://github.com/Jubobs/gitdags.git --depth 1 \
    && kpsewhich gitdags.sty

RUN dnf install -y \
    ruby-devel bundler @c-development @development-tools

ENV MY_GEMS=/opt/gems
RUN mkdir -p "$MY_GEMS" && cd "$MY_GEMS" \
    && git clone https://github.com/jekyll/minima.git --depth 1
COPY Gemfile /tmp/
RUN cd /tmp/ && bundle install && rm -rf /tmp/*
