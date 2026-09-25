# Install from source code

## Server

```bash

# build backend

git clone https://github.com/melezhik/doubletap.git
cd doubletap/server
go build .

# build rules checker

mkdir -p ~/.rakupp
cd ~/.rakupp
wget https://github.com/ash/rakupp/releases/download/v3.26.0/rakupp-linux-x86_64.tar.gz
tar -xzf rakupp-linux-x86_64.tar.gz
export PATH=~/.rakupo/rakupp/bin/:~/.raku/bin:$PATH
rakupp install --no-test Sparrow6
echo 'export PATH=~/.rakupp/rakupp/bin/:~/.raku/bin:$PATH' >> ~/.bashrc
echo 'export PATH=~/.rakupp/rakupp/bin/:~/.raku/bin:$PATH' >> ~/.bash_profile

# run server
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

Go to *[bash](/bash.md)* to see how to incorporate dtap into Bash scripts
