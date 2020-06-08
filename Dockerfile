FROM ocaml/opam2

LABEL "maintainer"="yoann.trellu@yahoo.com"

USER opam

## apt update
RUN sudo apt-get update

## install Vim IDE
## https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
RUN git clone https://github.com/vim/vim.git
RUN cd vim/ && git checkout tags/v8.2.0740
RUN sudo apt install -y python-dev python3-dev libncurses5-dev \
libgtk2.0-dev libatk1.0-dev libcairo2-dev libxpm-dev libxt-dev

RUN cd vim/ && ./configure --with-features=huge \
--enable-multibyte \
--enable-pythoninterp=yes \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
--enable-python3interp=yes \
--with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu \
--enable-cscope --prefix=/usr/local

RUN cd vim/ && make VIMRUNTIMEDIR=/usr/local/share/vim/vim82
RUN cd vim/ && sudo make install

######
## Vim is now installed, now forward with its configuration
######

## m4 dependency required for the utop REPL
RUN sudo apt install -y m4

## install recommanded REPL, completion & indenting tool for OCaml
RUN opam install utop merlin ocp-indent

## Will configure vim to use the Merlin & Ocp-indent tools 
RUN opam user-setup install

## Installing ALE for live syntax & semantic errors
RUN mkdir -p ~/.vim/pack/git-plugins/start \
&& git clone --depth 1 https://github.com/dense-analysis/ale.git \
~/.vim/pack/git-plugins/start/ale

## Popular Vim remapping you might want
RUN echo "imap jj <Esc>" >> /home/opam/.vimrc

######
## At this stage, we have
## Linting (Syntax & Semantics checking): automatic while typing
## Type Information: `\t` in normal mode
## Auto-completion: `<C-x><C-o>` in editing mode
## Indentation: `=` in visual mode, otherwise automatic while typing
##
## Vim is configured, now forward with some useful OCaml libraries
######

## install janestreet standard libs for OCaml 
RUN opam install base core && echo "PKG core" > ~/.merlin

## To parse well-formatted pdfs
# RUN opam install camlpdf
## Set language to have latin-encoded character sets
ENV LC_ALL=C.UTF-8
ENV LANG="$LC_ALL"

## For scientific computing (owl) & graphics utilities (owl-plplot)
# RUN sudo apt install liblapacke-dev libopenblas-dev libplplot-dev libshp-dev
## For owl-plplot (graphs will be directly saved in the container)
# RUN echo "export QT_QPA_PLATFORM='offscreen'" >> /home/opam/.profile \
# && source /home/opam/.profile
# RUN opam install owl owl-plplot


## Create a workspace directory owned by the opam user
ENV WS /home/opam/ws
RUN mkdir $WS
WORKDIR $WS
RUN sudo chown -R opam .
