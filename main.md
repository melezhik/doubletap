# Introduction

Text and Test Anything Protocol

Double TAP is lightweight testing framework where users write black box tests as rules checking output from tested "boxes". Boxes could be anything from http client, web server to messages in syslog. This universal approach allows to test anything with just dropping text rules describing system behavior in black box manner.

Following a simple example for http web server.

---

Check rule code:

```
HTTP/1.1 200 OK
Server: gunicorn/19.9.0
```

Implementation code aka box (the one producing output):

```
#!/bin/bash
curl http://httpbin.org -D - -s -o /deb/null | head
```

Test report:

```
[task stdout]
22:39:23 :: HTTP/1.1 200 OK
22:39:23 :: Date: Wed, 31 Dec 2025 19:39:23 GMT
22:39:23 :: Content-Type: text/html; charset=utf-8
22:39:23 :: Content-Length: 9593
22:39:23 :: Connection: keep-alive
22:39:23 :: Server: gunicorn/19.9.0
[task check]
stdout match <HTTP/1.1 200 OK> True
stdout match <Server: gunicorn/19.9.0> True
```

---

Imaging we have saved the previous check into file and uploaded it to some server (performing checks) under name web-server-ok, now we can run the check using API call:

```
#!/bin/bash
curl http://httpbin.org -D - -s -o /deb/null | head | \
dtap --box - --check web-server-ok --params fashion=gunicorn
```

API reply:

```
{
  "status": "OK",
  "report": " ... "
}
```

---

Boxes could be predefined, allow to reuse implementations for some standard cases like checking if packages are installed, services are enabled and web servers work correctly, etc.

The previous example could be rewritten with using web-server box (which under the hood executes curl call):

```
#!/bin/bash
dtap --box web-server \
--check web-server-ok \
--params site=http://httpbin.org,fashion=gunicorn
```

---

Check some *[examples](/examples)* here. Or read *[quick start](https://git.resf.org/testing/sparrow_task_check_crash_course)* of double TAP rules language.


# Protocol features

**Decoupled tests**

---

Write once, use for many boxes. Tests define "interface", which could be implemented in many ways on many tested boxes. For example if write test for package installation like this:

```
Status: install ok installed
```

The implementation logic could be verified for many Linux distributions.

Debian/Ubuntu:

```bash
dpkg  -s nano # stdout - Status: install ok installed
```

Rocky Linux:

```bash
rpm -q  nano && echo "Status: install ok installed"
```


**Predefined boxes**

---

Predefined boxes come as a part of dtap cli distribution. No need to implement tests for some typical cases, just use them with --box parameter and overriding box input settings via `--params`

---

For custom boxes just redirect output for verification via `--box -`

To list all available boxes:

```
dtap  --box_list
```


**Community driven tests**

---

With time the more people involved the more boxes and check rules are available for public consumption. Tests are no longer embedded into hidden implementation, test driven development encourages other participants to implement software that passes tests, not software including tests

---

**TDD/BDD embedded**

---

Check rules are blueprint, rough specification of system behavior. So we not just write test, we describe the system before it's even implemented. Think cucumber tool but with focus on messages.

---

To list all available checks:

```
dtap  --check_list
```

---

**Why it's called Double TAP**

---

TAP is well known and mature protocol that is widely used in unit testing. The pun is to add "texting" to "testing", so we end up double T or Double TAP protocol. Here is the association ends. Double TAP differs from TAP, being more generic and black box testing framework. Texting means tests are based on the idea of verifying system behavior by checking produced text messages against set of rules.