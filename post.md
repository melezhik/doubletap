---
title: DTAP - super simple testing protocol for infrastructure audit
published: true
description: How to test infrastructure using DTAP 
tags: testing, inspec, infrastructure, devops 
# cover_image: https://direct_url_to_image.jpg
# Use a ratio of 100:42 for best results.
# published_at: 2026-01-08 12:25 +0000
---

[DTAP](http://doubletap.sparrowhub.io) is a new testing protocol allowing to test infrastructure with just a Bash scripts. Here is a quick example, let's test that `/etc/dhcp/` directory and `/etc/dhcpcd.conf` file exists:


```bash
#!/bin/bash

session=$(date +%s)

ls /etc/dhcp/ 2>&1 | dtap --box - \
--session $session \
--params path=/etc/dhcp/ \
--check path-ok \
--desc "dhcp/ dir"

ls /etc/dhcpcd.conf  2>&1 | dtap --box - \
--session $session \
--params path=/etc/dhcpcd.conf \
--check path-ok \
--desc "dhcpcd.conf file"

dtap  --report  --session $session
```

The result will be:

```
DTAP report
session: 1767875428
===
dhcp/ dir ...... OK
dhcpcd.conf file ...... OK
```

Plain and simple

---

As one can see test scripts are just plain Bash commands, no fancy YAML or even high level programming languages.

Also DTAP follows WYSIWYG principle when we get exactly what we see, in a sense this is something we would do trying to check existence  of the mentioned directory and file:

```
ls /etc/dhcp/
ls /etc/dhcpcd.conf
```

And if any errors occurr we will get exactly what we are asking for - output of `ls` command which most of the Linux users probably are familiar with:

```bash
!/bin/bash
ls  /etc/does-not-exist 2>&1 | dtap --box - \
--session $session \
--params path=/etc/does-not-exist \
--check path-ok \
--desc "/etc/does-not-exist dir"
```

Output:

```
DTAP report
session: 1767875841
===
/etc/does-not-exist dir ...... FAIL
[report]
15:37:22 :: [sparrowtask] - run sparrow task .@path=/etc/does-not-exist
15:37:22 :: [sparrowtask] - run [.], thing: .@path=/etc/does-not-exist
[task run: task.bash - .]
[task stdout]
15:37:23 :: ls: cannot access '/etc/does-not-exist': No such file or directory
[task check]
stdout match <^^ "/etc/does-not-exist"  $$> False
=================
TASK CHECK FAIL
2
```

---

How this works?

There are two essentials primitives in DTAP:

* boxes

* and - checks


Box is an abstraction for everything we want to test - from web server to messages in syslog files. Boxes produces some output to be checked against check rules ( aka checks ). In the previous examples - boxe is just `ls` command which output redirected to a certain check rule via `--box -` notation ( meaning read box output from STDIN ). DTAP comes with some predefined boxes user can use them without writing any piece of code, but most of the time boxes - are something a user would write as a chain of Bash commands something likes that:

```bash
#!/bin/bash
( 
  2>&1
  cmd1;
  cmd2;
  cmd3;
  # ...
) | tap --box -
```

Or with a single script:

```bash
#!/bin/bash
. /some/box/script.sh | tap --box -
```

Checks are rules written on formal [DSL](https://github.com/melezhik/Sparrow6/blob/master/documentation/taskchecks.md) and executed remotely on DTAP server, so users don't need to install anything, only small [tap binary](http://doubletap.sparrowhub.io/install) written on golang that interacts with a server send output from boxes to a server and get results back. Checks DSL is based on regular expressions and is super flexible, allowing many things to do including extension by using many general programming languages. 

As an example if you look inside [path-ok](https://github.com/melezhik/doubletap/blob/main/checks/path-ok/task.check) check that verifies file/directory existence you'll see something like this:


```
generator: <<OK
!bash
echo "regexp: ^^ \"$(config path)\"  \$\$"
OK
```

---

To list available checks just run:

```bash
tap --check_list
```

Follow double tap web site [documentation](http://doubletap.sparrowhub.io/checks) to get details on using available checks.

It's easy to create new checks and add them to DTAP distribution, if you are instead please let me know. There is quick start introduction  into check DSL could be found [here](https://git.resf.org/testing/sparrow_task_check_quick_start/src/branch/main)

---

Conclusion.

DTAP is a new kid on the block, that allows to test infrastructure with using just a Bash yet very flexible and powerful. I encourage you to play with it, you can start with [installation](http://doubletap.sparrowhub.io/install) guide

---

Thanks for reading 
