# Install from source code


## Server

```bash
git clone https://github.com/melezhik/doubletap.git
cd doubletap/server
go build .
./dtap_server
```

## Client

```bash
git clone https://github.com/melezhik/doubletap.git
cd doubletap
go build .
export PATH=$PWD:$PATH
```

## Check that dtap cli works

This command should succeed

```bash
dtap  --check_list
```

Go to *[bash](/bash)* to see how to incorporate dtap into Bash scripts
