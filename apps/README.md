# Apps

These are some various application configurations that I have.



## Resume/CV

File: [resume.nix](resume.nix)

Usage:

```
nix-build resume.nix
```

The output will be *somewhere* in the nix store, which it will print out on completion. Initial run can take a while as it needs to download most of the LaTeX packages out there to build my resume.