# Install from source code

```bash
git clone https://github.com/melezhik/doubletap.git
cd doubletap
go build .
export PATH=$PWD:$PATH
export DT_API=http://doubletap.sparrowhub.io
```

## Check that dtap cli works

This command should succeed

```bash
dtap  --check_list
```

Go to *[bash](/bash)* to see how to incorporate dtap into Bash scripts
