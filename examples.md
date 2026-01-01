# ssh login attempts


Find unsuccessful login attempts and return
all found logins.

## check

```
~regexp: "Failed password for" \s+ (\S+) \s+ from

code: <<stat
!raku
my @data;
for captures()<> -> $i {
   push @data, $i.head;
}
update_state(%( data => $data ));
stat
```

### box

```
sudo cat /var/log/auth.log > data.in
```
