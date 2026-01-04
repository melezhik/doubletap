my $path = [
  ".",
];

task-run "build", "go-build", %(
  :$path,
);
