with import <nixpkgs> {};

pkgs.runCommand "cv.pdf" rec {
  resume_src = ./resume.tex;
  cv_src = ./cv.tex;
  bin = with pkgs.texlive; combine {
    inherit scheme-full collection-latexrecommended collection-fontsextra moderncv etoolbox;
  };
  buildInputs = [ bin ];
  allowSubstitutes = false;
} ''
  ln -s $resume_src resume.tex
  ln -s $cv_src cv.tex
  latexmk -pdf resume.tex
  latexmk -pdf cv.tex
  mkdir $out
  mv *pdf $out/
''
