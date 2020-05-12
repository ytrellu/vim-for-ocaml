# vim-for-ocaml

Cygwin/WSL is sometimes not enough to have Ocaml running on a windows machine
(e.g for the Core module).
This image is my OCaml IDE (using the Vim editor with merlin & ocp-indent)
which I thought might be useful for other people.

You might appreciate it to..
- Have a Vim + OCaml environment on any machines with docker.
- Use as testbench to configure your environment on your debian machine.
- Better understand how to configure Vim to work well with OCaml.
- Understand needed requirements for camlpdf, owl, and owl-plplot.

## Testing the Image

```bash
$ docker run --rm -it ytrellu2/vim-for-ocaml
```
And once inside:
```bash
~/ws$ echo "open Core" > test.ml && corebuild test.byte
```

## Resources

This image builds on top of those resources:

- https://dev.realworldocaml.org/install.html
- https://hub.docker.com/r/ocaml/opam2
- https://github.com/ycm-core/YouCompleteMe/wiki/Building-Vim-from-source
