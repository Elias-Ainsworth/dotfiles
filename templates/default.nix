let
  c = {
    path = ./c;
    description = "C dev environment";
  };

  cplusplus = {
    path = ./cplusplus;
    description = "C++ dev environment";
  };

  javascript = {
    path = ./javascript;
    description = "Javascript / Typescript dev environment";
  };

  latex = {
    path = ./latex;
    description = "LaTex / Tex dev environment";
  };

  python = {
    path = ./python;
    description = "Python dev environment";
  };

  rust = {
    path = ./rust;
    description = "Rust dev environment";
  };

  rust-stable = {
    path = ./rust-stable;
    description = "Rust (latest stable from fenix) dev environment";
  };
in
{
  inherit
    c
    cplusplus
    javascript
    latex
    python
    rust
    rust-stable
    ;

  # c = c would be fucking stupid
  cpp = cplusplus;
  js = javascript;
  ts = javascript;
  lx = latex;
  py = python;
  rs = rust;
  rs-stable = rust-stable;
}
